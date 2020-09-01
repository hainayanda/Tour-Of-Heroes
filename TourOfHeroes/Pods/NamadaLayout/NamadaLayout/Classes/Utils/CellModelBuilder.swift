//
//  Array+Extensions.swift
//  NamadaLayout
//
//  Created by Nayanda Haberty (ID) on 24/08/20.
//

import Foundation

public class TableCellBuilder {
    var sections: [UITableView.Section]
    var lastSection: UITableView.Section {
        sections.last!
    }
    
    public init(section: UITableView.Section = .init()) {
        self.sections = [section]
    }
    
    public func next<Cell: TableCellModel, Item>(type: Cell.Type, from items: [Item], _ builder: (inout Cell, Item) -> Void) -> TableCellBuilder {
        for item in items {
            var cell = Cell.init()
            builder(&cell, item)
            lastSection.add(cell: cell)
        }
        return self
    }
    
    public func nextSection(_ section: UITableView.Section = .init()) -> TableCellBuilder {
        sections.append(section)
        return self
    }
    
    public func build() -> [UITableView.Section] {
        return sections
    }
}

public class CollectionCellBuilder {
    var sections: [UICollectionView.Section]
    var lastSection: UICollectionView.Section {
        sections.last!
    }
    
    public init(section: UICollectionView.Section = .init()) {
        self.sections = [section]
    }
    
    public func next<Cell: CollectionCellModel, Item>(type: Cell.Type, from items: [Item], _ builder: (inout Cell, Item) -> Void) -> CollectionCellBuilder {
        for item in items {
            var cell = Cell.init()
            builder(&cell, item)
            lastSection.add(cell: cell)
        }
        return self
    }
    
    public func nextSection(_ section: UICollectionView.Section = .init()) -> CollectionCellBuilder {
        sections.append(section)
        return self
    }
    
    public func build() -> [UICollectionView.Section] {
        return sections
    }
}

public extension Array where Element == UICollectionView.Section {
    static func create(section: UICollectionView.Section = .init()) -> CollectionCellBuilder {
        return CollectionCellBuilder(section: section)
    }
}

public extension Array where Element == UITableView.Section {
    static func create(section: UITableView.Section = .init()) -> TableCellBuilder {
        return TableCellBuilder(section: section)
    }
}
