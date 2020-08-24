//
//  UICollectionView+ViewModel.swift
//  NamadaLayout
//
//  Created by Nayanda Haberty (ID) on 12/08/20.
//

import Foundation
import UIKit

public extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension UICollectionView {
    
    public var model: UICollectionView.Model {
        if let model = bindedModel() as? UICollectionView.Model {
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
    
    public var cells: [CollectionCellModel] {
        get {
            model.sections.first?.cells ?? []
        }
        set {
            let section = Section(identifier: "single_section", cells: newValue)
            model.sections = [section]
        }
    }
    
    public class Model: ViewModel<UICollectionView> {
        public var unreloadedSections: [Section]?
        @ObservableState public var sections: [Section] = []
        public var reloadStrategy: CellReloadStrategy = .reloadLinearDifferences
        
        public override func bind(with view: UICollectionView) {
            super.bind(with: view)
            $sections.observe(observer: self).didSet { model, changes  in
                guard let collection = model.view else {
                    model.unreloadedSections = changes.new
                    model.$sections._wrappedValue = changes.old
                    return
                }
                model.unreloadedSections = nil
                collection.registerNewCell(from: changes.new)
                DispatchQueue.main.async { [weak model, weak collection] in
                    guard let model = model, let collection = collection else { return }
                    model.reload(collection, with: changes.new, oldSections: changes.old)
                }
            }
        }
        
        public override func didApplying(_ view: UICollectionView) {
            view.dataSource = self
            guard let unreloadedSections = unreloadedSections else { return }
            sections = unreloadedSections
        }
    }
    
    open class Section: Equatable {
        
        public var cells: [CollectionCellModel]
        public var cellCount: Int { cells.count }
        public var sectionIdentifier: AnyHashable
        
        public init(identifier: AnyHashable = String.randomString(), cells: [CollectionCellModel] = []) {
            self.sectionIdentifier = identifier
            self.cells = cells
        }
        
        public func add(cell: CollectionCellModel) {
            cells.append(cell)
        }
        
        public func add(cells: [CollectionCellModel]) {
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
        
        public static func == (lhs: UICollectionView.Section, rhs: UICollectionView.Section) -> Bool {
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
        
        public init(title: String, identifier: AnyHashable = String.randomString(), cells: [CollectionCellModel] = []) {
            self.title = title
            super.init(identifier: identifier, cells: cells)
        }
        
        public override func copy() -> Section {
            return TitledSection(title: title, identifier: sectionIdentifier, cells: cells)
        }
        
        public static func == (lhs: UICollectionView.TitledSection, rhs: UICollectionView.TitledSection) -> Bool {
            guard let left = lhs.copy() as? UICollectionView.TitledSection,
                let right = rhs.copy() as? UICollectionView.TitledSection else {
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
    
    public class SupplementedSection: Section {
        
        public var header: CollectionCellModel?
        public var footer: CollectionCellModel?
        
        public init(header: CollectionCellModel? = nil, footer: CollectionCellModel? = nil, identifier: AnyHashable = String.randomString(), cells: [CollectionCellModel] = []) {
            self.header = header
            self.footer = footer
            super.init(identifier: identifier, cells: cells)
        }
        
        public override func copy() -> Section {
            return SupplementedSection(header: header, footer: footer, identifier: sectionIdentifier, cells: cells)
        }
        
        public static func == (lhs: UICollectionView.SupplementedSection, rhs: UICollectionView.SupplementedSection) -> Bool {
            guard let left = lhs.copy() as? UICollectionView.SupplementedSection,
                let right = rhs.copy() as? UICollectionView.SupplementedSection else {
                    return false
            }
            guard left.sectionIdentifier == right.sectionIdentifier,
                left.cells.count == right.cells.count else { return false }
            for (index, cell) in left.cells.enumerated() where !right.cells[index].isSameModel(with: cell) {
                return false
            }
            if let leftHeader = left.header, let rightHeader = right.header,
                leftHeader.isNotSameModel(with: rightHeader) {
                return false
            } else if (left.header == nil && right.header != nil) || (left.header != nil && right.header != nil) {
                return false
            }
            if let leftFooter = left.footer, let rightFooter = right.footer,
                leftFooter.isNotSameModel(with: rightFooter) {
                return false
            } else if (left.footer == nil && right.footer != nil) || (left.footer != nil && right.footer != nil) {
                return false
            }
            return true
        }
    }
}

extension UICollectionView {
    
    private func registerNewCell(from sections: [UICollectionView.Section]) {
        self.register(
            UICollectionViewCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "Namada_Layout_plain_\(UICollectionView.elementKindSectionHeader)"
        )
        self.register(
            UICollectionViewCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: "Namada_Layout_plain_\(UICollectionView.elementKindSectionFooter)"
        )
        self.register(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: "Namada_Layout_plain_cell"
        )
        var registeredCells: [String] = []
        var registeredHeaderSupplements: [String] = []
        var registeredFooterSupplements: [String] = []
        for section in sections {
            for cell in section.cells where !registeredCells.contains(cell.reuseIdentifier) {
                self.register(cell.cellClass, forCellWithReuseIdentifier: cell.reuseIdentifier)
                registeredCells.append(cell.reuseIdentifier)
            }
            if let supplementSection = section as? UICollectionView.SupplementedSection {
                if let header = supplementSection.header,
                    !registeredHeaderSupplements.contains(header.reuseIdentifier) {
                    self.register(
                        header.cellClass,
                        forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                        withReuseIdentifier: header.reuseIdentifier
                    )
                    registeredHeaderSupplements.append(header.reuseIdentifier)
                }
                if let footer = supplementSection.footer,
                    !registeredFooterSupplements.contains(footer.reuseIdentifier) {
                    self.register(
                        footer.cellClass,
                        forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                        withReuseIdentifier: footer.reuseIdentifier
                    )
                    registeredFooterSupplements.append(footer.reuseIdentifier)
                }
            }
        }
    }
}

extension UICollectionView.Model {
    
    func dataIsValid(_ collectionView: UICollectionView, oldData: [UICollectionView.Section]) -> Bool {
        guard collectionView.numberOfSections == oldData.count else { return false }
        for (section, cells) in oldData.enumerated() {
            guard collectionView.numberOfItems(inSection: section) == cells.cellCount else { return false }
        }
        return true
    }
    
    func reload(_ collectionView: UICollectionView, with sections: [UICollectionView.Section], oldSections: [UICollectionView.Section]) {
        let new = sections.compactMap { $0.copy() }
        let old = oldSections.compactMap { $0.copy() }
        guard !old.isEmpty, dataIsValid(collectionView, oldData: oldSections) else {
            collectionView.reloadData()
            collectionView.collectionViewLayout.invalidateLayout()
            return
        }
        switch self.reloadStrategy {
        case .reloadAll:
            reloadAll(collectionView, with: new, oldSections: old)
            return
        case .reloadLinearDifferences:
            reloadBatch(for: collectionView, with: new, oldSections: old) {
                linearReloadCell(for: collectionView, $0, with: $1, sectionIndex: $2)
            }
        case .reloadArangementDifferences:
            reloadBatch(for: collectionView, with: new, oldSections: old) {
                arrangeReloadCell(for: collectionView, $0, with: $1, sectionIndex: $2)
            }
        }
    }
    
    func reloadAll(_ collectionView: UICollectionView, with sections: [UICollectionView.Section], oldSections: [UICollectionView.Section]) {
        collectionView.performBatchUpdates({
            let oldCount = max(oldSections.count, 1)
            let newCount = max(sections.count, 1)
            let difference = newCount - oldCount
            let reloaded = min(oldCount, newCount)
            let inserted = max(difference, 0)
            let deleted = max(-difference, 0)
            if reloaded > 1 {
                collectionView.reloadSections(.init(0 ... (reloaded - 1)))
            } else {
                collectionView.reloadSections(.init(arrayLiteral: 0))
            }
            if inserted == 1 {
                collectionView.insertSections(.init(arrayLiteral: oldCount))
            } else if inserted > 1 {
                collectionView.insertSections(.init(oldCount ... (newCount - 1)))
            }
            if deleted == 1 {
                collectionView.deleteSections(.init(arrayLiteral: newCount))
            } else if deleted > 1 {
                collectionView.deleteSections(.init(newCount ... (oldCount - 1)))
            }
        }, completion: { success in
            guard success else { return }
            collectionView.collectionViewLayout.invalidateLayout()
        })
    }
    
    func firstRemovedSectionIndex(
        for collectionView: UICollectionView,
        with sections: [UICollectionView.Section],
        oldSections: [UICollectionView.Section],
        whenNotRemoved: (UICollectionView.Section, UICollectionView.Section, Int) -> Void) -> Int? {
        var greaterIndex: Int?
        for (sectionIndex, oldSection) in oldSections.enumerated() {
            guard let newSection = sections[safe: sectionIndex] else {
                greaterIndex = sectionIndex
                break
            }
            guard newSection.isSameSection(with: oldSection) else {
                collectionView.reloadSections(.init(arrayLiteral: sectionIndex))
                continue
            }
            whenNotRemoved(oldSection, newSection, sectionIndex)
        }
        return greaterIndex
    }
    
    func reloadBatch(
        for collectionView: UICollectionView,
        with sections: [UICollectionView.Section],
        oldSections: [UICollectionView.Section],
        _ reloader: (UICollectionView.Section, UICollectionView.Section, Int) -> Void) {
        collectionView.performBatchUpdates({
            let removedIndex: Int? = firstRemovedSectionIndex(
                for: collectionView,
                with: sections,
                oldSections: oldSections,
                whenNotRemoved: reloader
            )
            if let removed = removedIndex {
                if removed == oldSections.endIndex {
                    collectionView.deleteSections(.init(arrayLiteral: removed))
                } else if oldSections.count > removed {
                    collectionView.deleteSections(.init(integersIn: removed ... sections.endIndex))
                }
            } else if oldSections.count < sections.count {
                if sections.count - oldSections.count == 1 {
                    collectionView.insertSections(.init(arrayLiteral: oldSections.count))
                } else {
                    collectionView.insertSections(
                        .init(integersIn: oldSections.count ... sections.endIndex)
                    )
                }
            }
        }, completion: { success in
            guard success else { return }
            collectionView.collectionViewLayout.invalidateLayout()
        })
    }
    
    func firstRemovedCellIndex(
        for collectionView: UICollectionView,
        with cells: [CollectionCellModel],
        oldCells: [CollectionCellModel],
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
            collectionView.reloadItems(at: cellDifference)
        }
        return firstRemovedCells
    }
    
    func linearReloadCell(
        for collectionView: UICollectionView,
        _ oldSection: UICollectionView.Section,
        with newSection: UICollectionView.Section,
        sectionIndex: Int) {
        let firstRemoved: Int? = firstRemovedCellIndex(
            for: collectionView,
            with: newSection.cells,
            oldCells: oldSection.cells,
            sectionIndex: sectionIndex
        )
        if let removed = firstRemoved {
            let end = oldSection.cells.count - 1
            collectionView.deleteItems(
                at: getDifference(from: removed, to: end, section: sectionIndex)
            )
        } else if oldSection.cells.count < newSection.cells.count {
            let start = oldSection.cells.count
            let end = newSection.cells.count - 1
            collectionView.insertItems(at: getDifference(from: start, to: end, section: sectionIndex))
        }
    }
    
    func removedUnpresentIndex(
        for collectionView: UICollectionView,
        old oldCells: [CollectionCellModel],
        new newCells: [CollectionCellModel],
        sectionIndex: Int) -> [CollectionCellModel] {
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
            collectionView.deleteItems(at: removedIndexes)
            var oldCellAfterDelete: [CollectionCellModel] = []
            for index in keepedIndexes {
                guard let oldCell = oldCells[safe: index] else { continue }
                oldCellAfterDelete.append(oldCell)
            }
            return oldCellAfterDelete
        }
        return oldCells
    }
    
    func arrangeReloadCell(
        for collectionView: UICollectionView,
        _ oldSection: UICollectionView.Section,
        with newSection: UICollectionView.Section,
        sectionIndex: Int) {
        let newCells = newSection.cells
        var oldCellsArranged = removedUnpresentIndex(
            for: collectionView,
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
                collectionView.moveItem(
                    at: .init(row: oldIndex, section: sectionIndex),
                    to: .init(row: index, section: sectionIndex)
                )
                oldCellsArranged.remove(at: oldIndex)
                oldCellsArranged.insert(newCell, at: index)
            } else {
                collectionView.insertItems(at: [.init(row: index, section: sectionIndex)])
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

extension UICollectionView.Model: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.sections[safe: section]?.cellCount ?? 0
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        self.sections.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = self.sections[safe: indexPath.section],
            let cellModel = section.cells[safe: indexPath.item]
            else {
                return collectionView.dequeueReusableCell(withReuseIdentifier: "Namada_Layout_plain_cell", for: indexPath)
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellModel.reuseIdentifier, for: indexPath)
        if let cellLayoutable = cell as? CollectionCellLayoutable {
            let contentWidth: CGFloat = min(
                collectionView.contentSize.width,
                collectionView.collectionViewLayout.collectionViewContentSize.width
            )
            let contentInset: UIHorizontalInset = collectionView.contentInset.asHorizontalInset
            let sectionInset: UIHorizontalInset = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?
                .sectionInset.asHorizontalInset ?? .zero
            cellLayoutable.collectionContentWidth = contentWidth - contentInset.left -
                contentInset.right - sectionInset.left - sectionInset.left
        }
        cellModel.apply(cell: cell)
        return cell
    }
    
    public func indexTitles(for collectionView: UICollectionView) -> [String]? {
        var titles: [String] = []
        var titleCount: Int = 0
        self.sections.forEach {
            if let title = ($0 as? UICollectionView.TitledSection)?.title {
                titleCount += 1
                titles.append(title)
            } else {
                titles.append("")
            }
        }
        guard titleCount > 0 else { return nil }
        return titles
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader,
            let section = sections[safe: indexPath.section] as? UICollectionView.SupplementedSection,
            let header = section.header {
            let headerCell = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: header.reuseIdentifier,
                for: indexPath
            )
            header.apply(cell: headerCell as! UICollectionViewCell)
            return headerCell
        } else if kind == UICollectionView.elementKindSectionFooter,
            let section = sections[safe: indexPath.section] as? UICollectionView.SupplementedSection,
            let footer = section.footer {
            let footerCell = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: footer.reuseIdentifier,
                for: indexPath
            )
            footer.apply(cell: footerCell as! UICollectionViewCell)
            return footerCell
        }
        return collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: "Namada_Layout_plain_\(kind)",
            for: indexPath
        )
    }
}
