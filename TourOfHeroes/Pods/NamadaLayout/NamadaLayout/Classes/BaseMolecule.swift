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
    
    func reLayout() -> Bool {
        switch layoutBehaviour {
        case .once:
            return false
        case .editEveryLayout:
            makeAndEditLayout()
        case .remakeEveryLayout:
            remakeLayout()
        case .custom:
            return customLayout()
        }
        return true
    }
    
    @discardableResult
    func customLayout() -> Bool {
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
            return false
        }
        return true
    }
    
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

open class CollectionCellLayoutable: UICollectionViewCell, MoleculeCellLayout {
    
    public private(set) var layoutPhase: CellLayouting = .initial
    open var layoutBehaviour: CellLayoutBehaviour { .once }
    var collectionContentWidth: CGFloat = UIScreen.main.bounds.width
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        let model = bindedModel() as? UICollectionViewCell.Model<Self>
        model?.unbind()
        layoutPhase = .reused
        layoutChildIfNeeded()
        layoutPhase = .none
    }
    
    open func calculatedCellSize(for collectionContentWidth: CGFloat) -> CGSize { .automatic }
    
    open override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let layouted = layoutChildIfNeeded()
        if layouted {
            setNeedsDisplay()
        }
        let calculatedSize = calculatedCellSize(for: collectionContentWidth)
        let automatedSize = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        let size: CGSize = .init(
            width: calculatedSize.width == .automatic ? automatedSize.width : calculatedSize.width,
            height: calculatedSize.height == .automatic ? automatedSize.height : calculatedSize.height
        )
        var newFrame = layoutAttributes.frame
        newFrame.size = size
        layoutAttributes.frame = newFrame
        return layoutAttributes
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        layoutChildIfNeeded()
        layoutPhase = .none
    }
    
    open override func setNeedsLayout() {
        super.setNeedsLayout()
        if layoutPhase == .none {
            layoutPhase = .needsLayoutSet
        }
    }
    
    open func layoutChild(_ thisLayout: ViewLayout) { }
    
    open func shouldLayout(on phase: CellLayouting) -> LayoutingStrategy {
        fatalError("Layout Behaviour is 'custom' but shouldLayout(on:) is not overriden")
    }
    
    @discardableResult
    func layoutChildIfNeeded() -> Bool {
        defer {
            layoutPhase = .none
        }
        switch layoutBehaviour {
        case .custom:
            return customLayout()
        default:
            switch layoutPhase {
            case .reused, .needsLayoutSet:
                return reLayout()
            case .initial:
                makeLayout()
            case .none:
                return false
            }
        }
        return true
    }
}

open class TableCellLayoutable: UITableViewCell, MoleculeCellLayout {
    public private(set) var layoutPhase: CellLayouting = .initial
    open var layoutBehaviour: CellLayoutBehaviour { .once }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        let model = bindedModel() as? UITableViewCell.Model<Self>
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
        super.setNeedsLayout()
        if layoutPhase == .none {
            layoutPhase = .needsLayoutSet
        }
    }
    
    open func calculatedCellHeight(for cellWidth: CGFloat) -> CGFloat { .automatic }
    
    open override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        let layouted = layoutChildIfNeeded()
        if layouted {
            setNeedsDisplay()
        }
        let size = super.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: horizontalFittingPriority,
            verticalFittingPriority: verticalFittingPriority
        )
        let cellHeight = calculatedCellHeight(for: size.width)
        let height = cellHeight == .automatic ? size.height : cellHeight
        return CGSize(width: size.width, height: height)
    }
    
    open func layoutChild(_ thisLayout: ViewLayout) { }
    
    open func shouldLayout(on phase: CellLayouting) -> LayoutingStrategy {
        fatalError("Layout Behaviour is 'custom' but shouldLayout(on:) is not overriden")
    }
    
    @discardableResult
    func layoutChildIfNeeded() -> Bool {
        defer {
            layoutPhase = .none
        }
        switch layoutBehaviour {
        case .custom:
            return customLayout()
        default:
            switch layoutPhase {
            case .reused, .needsLayoutSet:
                return reLayout()
            case .initial:
                makeLayout()
            case .none:
                return false
            }
        }
        return true
    }
}
