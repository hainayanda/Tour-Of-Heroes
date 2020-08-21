//
//  UITableView+ViewModel.swift
//  NamadaLayout
//
//  Created by Nayanda Haberty (ID) on 11/08/20.
//

import Foundation
import UIKit

public protocol CellModel {
    static var cellViewClass: AnyClass { get }
    static var cellReuseIdentifier: String { get }
    func isSameModel(with other: CellModel) -> Bool
}

public extension CellModel {
    var reuseIdentifier: String {
        Self.cellReuseIdentifier
    }
    var cellClass: AnyClass {
        Self.cellViewClass
    }
    
    func isNotSameModel(with other: CellModel) -> Bool {
        return !isSameModel(with: other)
    }
}

public protocol CollectionCellModel: CellModel {
    func apply(cell: UICollectionReusableView)
}

public protocol TableCellModel: CellModel {
    func apply(cell: UITableViewCell)
}

extension UITableViewCell {
    
    open class Model<Cell: UITableViewCell>: ViewModel<Cell>, TableCellModel {
        
        public static var cellViewClass: AnyClass { Cell.self }
        public static var cellReuseIdentifier: String {
            String(describing: Cell.self).filter { $0.isLetter || $0.isNumber }.camelCaseToSnakeCase()
        }
        
        public var animateInteraction: Bool = false
        public var cellIdentifier: AnyHashable  = String.randomString()
        
        public func apply(cell: UITableViewCell) {
            guard let cell = cell as? Cell else {
                fatalError("UITableViewCell type is different with ViewModel")
            }
            self.apply(to: cell)
        }
        
        open override func bind(with view: Cell) {
            super.bind(with: view)
        }
        
        open override func willApplying(_ view: View) {
            super.willApplying(view)
        }
        
        open override func didApplying(_ view: View) {
            super.didApplying(view)
        }
        
        open override func modelWillMapped(from view: View) {
            super.modelWillMapped(from: view)
        }
        
        open override func modelDidMapped(from view: View) {
            super.modelDidMapped(from: view)
        }
        
        open override func willUnbind() {
            super.willUnbind()
        }
        
        open override func didUnbind() {
            super.didUnbind()
        }
        
        public func isSameModel(with other: CellModel) -> Bool {
            guard let otherAsSelf = other as? Self else { return false }
            if otherAsSelf === self { return true }
            return otherAsSelf.cellIdentifier == cellIdentifier
        }
    }
}

extension UICollectionViewCell {
    
    open class Model<Cell: UICollectionViewCell>: ViewModel<Cell>, CollectionCellModel {
        
        public static var cellViewClass: AnyClass { Cell.self }
        public static var cellReuseIdentifier: String {
            String(describing: Cell.self).filter { $0.isLetter || $0.isNumber }.camelCaseToSnakeCase()
        }
        
        public var cellIdentifier: AnyHashable  = String.randomString()
        
        public func apply(cell: UICollectionReusableView) {
            guard let cell = cell as? Cell else {
                fatalError("UICollectionViewCell type is different with ViewModel")
            }
            self.apply(to: cell)
        }
        
        open override func bind(with view: Cell) {
            super.bind(with: view)
        }
        
        open override func willApplying(_ view: View) {
            super.willApplying(view)
        }
        
        open override func didApplying(_ view: View) {
            super.didApplying(view)
        }
        
        open override func modelWillMapped(from view: View) {
            super.modelWillMapped(from: view)
        }
        
        open override func modelDidMapped(from view: View) {
            super.modelDidMapped(from: view)
        }
        
        open override func willUnbind() {
            super.willUnbind()
        }
        
        open override func didUnbind() {
            super.didUnbind()
        }
        
        public func isSameModel(with other: CellModel) -> Bool {
            guard let otherAsSelf = other as? Self else { return false }
            if otherAsSelf === self { return true }
            return otherAsSelf.cellIdentifier == cellIdentifier
        }
    }
}