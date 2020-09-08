//
//  UITableView+ViewModel.swift
//  NamadaLayout
//
//  Created by Nayanda Haberty (ID) on 12/08/20.
//

import Foundation
import UIKit

extension UITableView {
    
    public var model: UITableView.Model {
        if let model = bindedModel() as? UITableView.Model {
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
    
    public var cells: [TableCellModel] {
        get {
            model.sections.first?.cells ?? []
        }
        set {
            let section = Section(identifier: "single_section", cells: newValue)
            model.sections = [section]
        }
    }
    
    public class Model: ViewModel<UITableView> {
        var applicableSections: [Section] = []
        @ObservableState public var sections: [Section] = []
        public var insertRowAnimation: UITableView.RowAnimation = .left
        public var reloadRowAnimation: UITableView.RowAnimation = .fade
        public var deleteRowAnimation: UITableView.RowAnimation = .left
        public var insertSectionAnimation: UITableView.RowAnimation = .top
        public var reloadSectionAnimation: UITableView.RowAnimation = .top
        public var deleteSectionAnimation: UITableView.RowAnimation = .top
        public var reloadStrategy: CellReloadStrategy = .reloadLinearDifferences
        private var didReloadAction: ((Bool) -> Void)?
        
        public override func bind(with view: UITableView) {
            super.bind(with: view)
            $sections.observe(observer: self).didSet { model, changes  in
                guard let table = model.view else { return }
                let newSection = changes.new
                table.registerNewCell(from: newSection)
                let oldSection = model.applicableSections
                model.applicableSections = newSection
                model.reload(table, with: newSection, oldSections: oldSection, completion: model.didReloadAction)
            }
        }
        
        public func didReloadCells(then: ((Bool) -> Void)?) {
            didReloadAction = then
        }
        
        public override func didApplying(_ view: UITableView) {
            view.dataSource = self
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
    
    func dataIsValid(_ tableView: UITableView, oldData: [UITableView.Section]) -> Bool {
        guard tableView.numberOfSections == oldData.count else { return false }
        for (section, cells) in oldData.enumerated() {
            guard tableView.numberOfRows(inSection: section) == cells.cellCount else { return false }
        }
        return true
    }
    
    func reload(
        _ tableView: UITableView,
        with sections: [UITableView.Section],
        oldSections: [UITableView.Section],
        completion: ((Bool) -> Void)?) {
        defer {
            tableView.setNeedsDisplay()
        }
        guard !oldSections.isEmpty, dataIsValid(tableView, oldData: oldSections) else {
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                completion?(true)
            }
            tableView.reloadData()
            CATransaction.commit()
            return
        }
        switch self.reloadStrategy {
        case .reloadAll:
            reloadAll(tableView, with: sections, oldSections: oldSections, completion: completion)
            return
        case .reloadLinearDifferences:
            reloadBatch(for: tableView, with: sections, oldSections: oldSections, reloader: {
                linearReloadCell(for: tableView, $0, with: $1, sectionIndex: $2)
            }, completion: completion)
        case .reloadArangementDifferences:
            reloadBatch(for: tableView, with: sections, oldSections: oldSections, reloader: {
                arrangeReloadCell(for: tableView, $0, with: $1, sectionIndex: $2)
            }, completion: completion)
        }
    }
    
    func reloadAll(
        _ tableView: UITableView,
        with sections: [UITableView.Section],
        oldSections: [UITableView.Section],
        completion: ((Bool) -> Void)?) {
        tableView.beginUpdates()
        let oldCount = max(oldSections.count, 1)
        let newCount = max(sections.count, 1)
        let difference = newCount - oldCount
        let reloaded = min(oldCount, newCount)
        let inserted = max(difference, 0)
        let deleted = max(-difference, 0)
        if reloaded > 1 {
            tableView.reloadSections(.init(0 ... (reloaded - 1)), with: reloadSectionAnimation)
        } else {
            tableView.reloadSections(.init(arrayLiteral: 0), with: reloadSectionAnimation)
        }
        if inserted == 1 {
            tableView.insertSections(.init(arrayLiteral: oldCount), with: insertSectionAnimation)
        } else if inserted > 1 {
            tableView.insertSections(.init(oldCount ... (newCount - 1)), with: insertSectionAnimation)
        }
        if deleted == 1 {
            tableView.deleteSections(.init(arrayLiteral: newCount), with: deleteSectionAnimation)
        } else if deleted > 1 {
            tableView.deleteSections(.init(newCount ... (oldCount - 1)), with: deleteSectionAnimation)
        }
        tableView.endUpdates()
        completion?(true)
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
        reloader: (UITableView.Section, UITableView.Section, Int) -> Void,
        completion: ((Bool) -> Void)?) {
        tableView.beginUpdates()
        defer {
            tableView.endUpdates()
            completion?(true)
        }
        let removedIndex: Int? = firstRemovedSectionIndex(
            for: tableView,
            with: sections,
            oldSections: oldSections,
            whenNotRemoved: reloader
        )
        if let removed = removedIndex {
            if removed == oldSections.endIndex {
                tableView.deleteSections(.init(arrayLiteral: removed), with: deleteSectionAnimation)
            } else if oldSections.count > removed {
                tableView.deleteSections(.init(integersIn: removed ... sections.endIndex), with: deleteSectionAnimation)
            }
        } else if oldSections.count < sections.count {
            if sections.count - oldSections.count == 1 {
                tableView.insertSections(.init(arrayLiteral: oldSections.count), with: insertSectionAnimation)
            } else {
                tableView.insertSections(
                    .init(integersIn: oldSections.count ... sections.endIndex), with: insertSectionAnimation
                )
            }
        }
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
            guard let oldCell = oldCellsArranged[safe: index] else {
                tableView.insertRows(at: [.init(row: index, section: sectionIndex)], with: insertRowAnimation)
                oldCellsArranged.insert(newCell, at: index)
                continue
            }
            guard newCell.isNotSameModel(with: oldCell) else {
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
        self.applicableSections[safe: section]?.cellCount ?? 0
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        self.applicableSections.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = self.applicableSections[safe: indexPath.section],
            let cellModel = section.cells[safe: indexPath.item]
            else { return .init() }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellModel.reuseIdentifier, for: indexPath)
        cellModel.apply(cell: cell)
        return cell
    }
    
    public func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        var titles: [String] = []
        var titleCount: Int = 0
        self.applicableSections.forEach {
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

