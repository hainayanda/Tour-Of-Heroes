//
//  UITableView+ViewModel.swift
//  FBSnapshotTestCase
//
//  Created by Nayanda Haberty (ID) on 12/08/20.
//

import Foundation
import UIKit

extension UITableView {
    
    public var model: UITableView.Model {
        if let model: UITableView.Model = bindedModel() {
            return model
        }
        let model = Model()
        model.apply(to: self)
        return model
    }
    
    public var sections: [Section] {
        get {
            model.sections
        }
        set {
            model.sections = newValue
        }
    }
    
    public class Model: ViewModel<UITableView> {
        @ViewState public var sections: [Section] = []
        public var insertRowAnimation: UITableView.RowAnimation = .left
        public var reloadRowAnimation: UITableView.RowAnimation = .fade
        public var deleteRowAnimation: UITableView.RowAnimation = .left
        public var insertSectionAnimation: UITableView.RowAnimation = .top
        public var reloadSectionAnimation: UITableView.RowAnimation = .top
        public var deleteSectionAnimation: UITableView.RowAnimation = .top
        public var reloadStrategy: CellReloadStrategy = .reloadLinearDifferences
        
        public override func bind(with view: UITableView) {
            super.bind(with: view)
            view.dataSource = self
            $sections.observe(observer: self).didSet { [weak view = view] model, changes  in
                guard let table = view else { return }
                table.registerNewCell(from: changes.new)
                model.reload(table, with: changes.new, oldSections: changes.old)
            }
        }
    }
    
    open class Section: Equatable {
        
        public var cells: [TableCellModel]
        public var cellCount: Int { cells.count }
        public var sectionIdentifier: AnyHashable
        
        public init(identifier: AnyHashable = String.randomString(), cells: [TableCellModel] = []) {
            self.sectionIdentifier = identifier
            self.cells = cells
        }
        
        public func add(cell: TableCellModel) {
            cells.append(cell)
        }
        
        public func add(cells: [TableCellModel]) {
            self.cells.append(contentsOf: cells)
        }
        
        func isSameSection(with other: Section) -> Bool {
            if other === self { return true }
            return other.sectionIdentifier == sectionIdentifier
        }
        
        public func clear() {
            cells.removeAll()
        }
        
        public func copy() -> Section {
            return Section(identifier: sectionIdentifier, cells: cells)
        }
        
        public static func == (lhs: UITableView.Section, rhs: UITableView.Section) -> Bool {
            let left = lhs.copy()
            let right = rhs.copy()
            guard left.sectionIdentifier == right.sectionIdentifier,
                left.cells.count == right.cells.count else { return false }
            for (index, cell) in left.cells.enumerated() where !right.cells[index].isSameModel(with: cell) {
                return false
            }
            return true
        }
    }
    
    public class TitledSection: Section {
        
        public var title: String
        
        public init(title: String, identifier: AnyHashable = String.randomString(), cells: [TableCellModel] = []) {
            self.title = title
            super.init(identifier: identifier, cells: cells)
        }
        
        public override func copy() -> Section {
            return TitledSection(title: title, identifier: sectionIdentifier, cells: cells)
        }
        
        public static func == (lhs: UITableView.TitledSection, rhs: UITableView.TitledSection) -> Bool {
            guard let left = lhs.copy() as? UITableView.TitledSection,
                let right = rhs.copy() as? UITableView.TitledSection else {
                    return false
            }
            guard left.sectionIdentifier == right.sectionIdentifier,
                left.title == right.title,
                left.cells.count == right.cells.count else { return false }
            for (index, cell) in left.cells.enumerated() where !right.cells[index].isSameModel(with: cell) {
                return false
            }
            return true
        }
    }
}

extension UITableView {
    
    private func registerNewCell(from sections: [UITableView.Section]) {
        var registeredCells: [String] = []
        for section in sections {
            for cell in section.cells where !registeredCells.contains(cell.reuseIdentifier) {
                self.register(cell.cellClass, forCellReuseIdentifier: cell.reuseIdentifier)
                registeredCells.append(cell.reuseIdentifier)
            }
        }
    }
}

extension UITableView.Model {
    func reload(_ tableView: UITableView, with sections: [UITableView.Section], oldSections: [UITableView.Section]) {
        let new = sections.compactMap { $0.copy() }
        let old = oldSections.compactMap { $0.copy() }
        guard !old.isEmpty else {
            tableView.reloadData()
            return
        }
        switch self.reloadStrategy {
        case .reloadAll:
            tableView.reloadData()
            return
        case .reloadLinearDifferences:
            reloadBatch(for: tableView, with: new, oldSections: old) {
                linearReloadCell(for: tableView, $0, with: $1, sectionIndex: $2)
            }
        case .reloadArangementDifferences:
            reloadBatch(for: tableView, with: new, oldSections: old) {
                arrangeReloadCell(for: tableView, $0, with: $1, sectionIndex: $2)
            }
        }
    }
    
    func firstRemovedSectionIndex(
        for tableView: UITableView,
        with sections: [UITableView.Section],
        oldSections: [UITableView.Section],
        whenNotRemoved: (UITableView.Section, UITableView.Section, Int) -> Void) -> Int? {
        var greaterIndex: Int?
        for (sectionIndex, oldSection) in oldSections.enumerated() {
            guard let newSection = sections[safe: sectionIndex] else {
                greaterIndex = sectionIndex
                break
            }
            guard newSection.isSameSection(with: oldSection) else {
                tableView.reloadSections(.init(arrayLiteral: sectionIndex), with: reloadSectionAnimation)
                continue
            }
            whenNotRemoved(oldSection, newSection, sectionIndex)
        }
        return greaterIndex
    }
    
    func reloadBatch(
        for tableView: UITableView,
        with sections: [UITableView.Section],
        oldSections: [UITableView.Section],
        _ reloader: (UITableView.Section, UITableView.Section, Int) -> Void) {
        tableView.beginUpdates()
        let removedIndex: Int? = firstRemovedSectionIndex(
            for: tableView,
            with: sections,
            oldSections: oldSections,
            whenNotRemoved: reloader
        )
        if let removed = removedIndex, removed < sections.count {
            let deleted: IndexSet = sections.endIndex == removed ? .init(arrayLiteral: removed)
                : .init(integersIn: removed ... sections.endIndex)
            tableView.deleteSections(deleted, with: deleteSectionAnimation)
        } else {
            let countDifference = sections.count - oldSections.count
            let inserted: IndexSet = countDifference == 1 ? .init(arrayLiteral: oldSections.count)
                : .init(integersIn: oldSections.count ... sections.endIndex)
            tableView.insertSections(inserted, with: insertSectionAnimation)
        }
        tableView.endUpdates()
    }
    
    func firstRemovedCellIndex(
        for tableView: UITableView,
        with cells: [TableCellModel],
        oldCells: [TableCellModel],
        sectionIndex: Int) -> Int? {
        var cellDifference: [IndexPath] = []
        var firstRemovedCells: Int?
        for (cellIndex, oldCell) in oldCells.enumerated() {
            guard let newCell = cells[safe: cellIndex] else {
                firstRemovedCells = cellIndex
                break
            }
            if newCell.isNotSameModel(with: oldCell) {
                cellDifference.append(.init(row: cellIndex, section: sectionIndex))
            }
        }
        if !cellDifference.isEmpty {
            tableView.reloadRows(at: cellDifference, with: reloadRowAnimation)
        }
        return firstRemovedCells
    }
    
    func linearReloadCell(
        for tableView: UITableView,
        _ oldSection: UITableView.Section,
        with newSection: UITableView.Section,
        sectionIndex: Int) {
        let firstRemoved: Int? = firstRemovedCellIndex(
            for: tableView,
            with: newSection.cells,
            oldCells: oldSection.cells,
            sectionIndex: sectionIndex
        )
        if let removed = firstRemoved {
            let end = oldSection.cells.count - 1
            tableView.deleteRows(
                at: getDifference(from: removed, to: end, section: sectionIndex),
                with: deleteRowAnimation
            )
        } else if oldSection.cells.count < newSection.cells.count {
            let start = oldSection.cells.count
            let end = newSection.cells.count - 1
            tableView.insertRows(
                at: getDifference(from: start, to: end, section: sectionIndex),
                with: insertSectionAnimation
            )
        }
    }
    
    func removedUnpresentIndex(
        for tableView: UITableView,
        old oldCells: [TableCellModel],
        new newCells: [TableCellModel],
        sectionIndex: Int) -> [TableCellModel] {
        var removedIndexes: [IndexPath] = []
        var keepedIndexes: [Int] = []
        for (index, oldCell) in oldCells.enumerated() {
            guard !newCells.contains(where: { $0.isSameModel(with: oldCell) }) else {
                keepedIndexes.append(index)
                continue
            }
            removedIndexes.append(.init(row: index, section: sectionIndex))
        }
        if !removedIndexes.isEmpty {
            tableView.deleteRows(at: removedIndexes, with: deleteRowAnimation)
            var oldCellAfterDelete: [TableCellModel] = []
            for index in keepedIndexes {
                guard let oldCell = oldCells[safe: index] else { continue }
                oldCellAfterDelete.append(oldCell)
            }
            return oldCellAfterDelete
        }
        return oldCells
    }
    
    func arrangeReloadCell(
        for tableView: UITableView,
        _ oldSection: UITableView.Section,
        with newSection: UITableView.Section,
        sectionIndex: Int) {
        let newCells = newSection.cells
        var oldCellsArranged = removedUnpresentIndex(
            for: tableView,
            old: oldSection.cells,
            new: newCells,
            sectionIndex: sectionIndex
        )
        for (index, newCell) in newCells.enumerated() {
            guard let oldCell = oldCellsArranged[safe: index],
                newCell.isNotSameModel(with: oldCell) else {
                    continue
            }
            if let oldIndex = oldCellsArranged.firstIndex(where: { $0.isSameModel(with: newCell) }) {
                tableView.moveRow(
                    at: .init(row: oldIndex, section: sectionIndex),
                    to: .init(row: index, section: sectionIndex)
                )
                oldCellsArranged.remove(at: oldIndex)
                oldCellsArranged.insert(newCell, at: index)
            } else {
                tableView.insertRows(at: [.init(row: index, section: sectionIndex)], with: insertRowAnimation)
                oldCellsArranged.insert(newCell, at: index)
            }
        }
    }
    
    func getDifference(from start: Int, to end: Int, section: Int) -> [IndexPath] {
        guard start < end else {
            return [.init(row: start, section: section)]
        }
        var indexPaths: [IndexPath] = []
        for index in start ..< end + 1 {
            indexPaths.append(.init(row: index, section: section))
        }
        return indexPaths
    }
}

extension UITableView.Model: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.sections[safe: section]?.cellCount ?? 0
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        self.sections.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = self.sections[safe: indexPath.section],
            let cellModel = section.cells[safe: indexPath.item]
            else { return .init() }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellModel.reuseIdentifier, for: indexPath)
        cellModel.apply(cell: cell)
        return cell
    }
    
    public func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        var titles: [String] = []
        var titleCount: Int = 0
        self.sections.forEach {
            if let title = ($0 as? UITableView.TitledSection)?.title {
                titleCount += 1
                titles.append(title)
            } else {
                titles.append("")
            }
        }
        guard titleCount > 0 else { return nil }
        return titles
    }
}

