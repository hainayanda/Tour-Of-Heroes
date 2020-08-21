//
//  BaseMolecule.swift
//  NamadaLayout
//
//  Created by Nayanda Haberty (ID) on 16/07/20.
//

import Foundation
import UIKit

public enum CellLayouting {
    case reused
    case needsLayoutSet
    case initial
    case none
}

public enum LayoutingStrategy {
    case makeAndEditLayout
    case remakeLayout
    case makeLayout
    case makeLayoutCleanly
    case none
}

public protocol MoleculeCellLayout: MoleculeLayout {
    var layoutPhase: CellLayouting { get }
    var layoutBehaviour: CellLayoutBehaviour { get }
    
    func shouldLayout(on phase: CellLayouting) -> LayoutingStrategy
}

public extension MoleculeLayout where Self: LayoutCompatible {
    func makeAndEditLayout() {
        makeAndEditLayout(layoutChild(_:))
    }
    
    func remakeLayout() {
        remakeLayout(layoutChild(_:))
    }
    
    func makeLayout() {
        makeLayout(layoutChild(_:))
    }
    
    func makeLayoutCleanly() {
        makeLayoutCleanly(layoutChild(_:))
    }
}

public enum CellLayoutBehaviour {
    case once
    case remakeEveryLayout
    case editEveryLayout
    case custom
}

public extension MoleculeCellLayout where Self: LayoutCompatible {
    func layoutChildIfNeeded() {
        switch layoutBehaviour {
        case .custom:
            customLayout()
        default:
            switch layoutPhase {
            case .reused, .needsLayoutSet:
                reLayout()
            case .initial:
                makeLayout()
            case .none:
                return
            }
        }
    }
    
    func reLayout() {
        switch layoutBehaviour {
        case .once:
            return
        case .editEveryLayout:
            makeAndEditLayout()
        case .remakeEveryLayout:
            remakeLayout()
        case .custom:
            customLayout()
        }
    }
    
    func customLayout() {
        let layoutStrategy = shouldLayout(on: layoutPhase)
        switch layoutStrategy {
        case .makeAndEditLayout:
            makeAndEditLayout()
        case .makeLayout:
            makeLayout()
        case .makeLayoutCleanly:
            makeLayoutCleanly()
        case .remakeLayout:
            remakeLayout()
        case .none:
            return
        }
    }
}

open class CollectionCellLayoutable: UICollectionViewCell, MoleculeCellLayout {
    
    public private(set) var layoutPhase: CellLayouting = .initial
    open var layoutBehaviour: CellLayoutBehaviour { .once }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        let model: UICollectionViewCell.Model<Self>? = bindedModel()
        model?.unbind()
        layoutPhase = .reused
        layoutChildIfNeeded()
        layoutPhase = .none
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        layoutChildIfNeeded()
        layoutPhase = .none
    }
    
    open override func setNeedsLayout() {
        layoutPhase = .needsLayoutSet
        super.setNeedsLayout()
    }
    
    open func layoutChild(_ thisLayout: ViewLayout) { }
    
    open func shouldLayout(on phase: CellLayouting) -> LayoutingStrategy {
        fatalError("Layout Behaviour is 'custom' but shouldLayout(on:) is not overriden")
    }
}

open class TableCellLayoutable: UITableViewCell, MoleculeCellLayout {
    public private(set) var layoutPhase: CellLayouting = .initial
    open var layoutBehaviour: CellLayoutBehaviour { .once }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        let model: UITableViewCell.Model<Self>? = bindedModel()
        model?.unbind()
        layoutPhase = .reused
        layoutChildIfNeeded()
        layoutPhase = .none
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        layoutChildIfNeeded()
        layoutPhase = .none
    }
    
    open override func setNeedsLayout() {
        layoutPhase = .needsLayoutSet
        super.setNeedsLayout()
    }
    
    open func layoutChild(_ thisLayout: ViewLayout) { }
    
    open func shouldLayout(on phase: CellLayouting) -> LayoutingStrategy {
        fatalError("Layout Behaviour is 'custom' but shouldLayout(on:) is not overriden")
    }
}
