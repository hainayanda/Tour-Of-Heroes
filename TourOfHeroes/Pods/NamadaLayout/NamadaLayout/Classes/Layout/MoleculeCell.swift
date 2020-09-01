//
//  MoleculeCell.swift
//  NamadaLayout
//
//  Created by Nayanda Haberty (ID) on 28/08/20.
//

import Foundation
import UIKit

public protocol MoleculeCell: MoleculeView {
    var layoutPhase: CellLayoutingPhase { get }
    var layoutBehaviour: CellLayoutingBehaviour { get }
    
    func layoutOption(on phase: CellLayoutingPhase) -> SublayoutingOption
}

open class TableMoleculeCell: UITableViewCell, MoleculeCell {
    private var _layoutPhase: CellLayoutingPhase = .firstLoad
    public var layoutPhase: CellLayoutingPhase {
        get {
            layouted ? _layoutPhase : .firstLoad
        }
        set {
            _layoutPhase = newValue
        }
    }
    private(set) var layouted: Bool = false
    
    open var layoutBehaviour: CellLayoutingBehaviour { .layoutOnce }
    
    open func layoutContent(_ layout: LayoutInsertable) { }
    
    open func moleculeWillLayout() {}
    
    open func moleculeDidLayout() {}
    
    @discardableResult
    open func layoutContentIfNeeded() -> Bool {
        defer {
            layouted = true
        }
        switch layoutBehaviour {
        case .layoutOn(let phase):
            if layoutPhase != .firstLoad && phase != layoutPhase {
                return false
            }
        case .layoutOnEach(let phases):
            if layoutPhase != .firstLoad && !phases.contains(where: { $0 == layoutPhase }) {
                return false
            }
        case .layoutOnce:
            guard layoutPhase == .firstLoad else { return false }
        default:
            break
        }
        moleculeWillLayout()
        contentView.layoutContent(layoutOption(on: layoutPhase)) { content in
            layoutContent(content)
        }
        moleculeDidLayout()
        return true
    }
    
    open func calculatedCellHeight(for cellWidth: CGFloat) -> CGFloat { .automatic }
    
    open override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        let layouted = layoutContentIfNeeded()
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
    
    open func layoutOption(on phase: CellLayoutingPhase) -> SublayoutingOption {
        switch phase {
        case .firstLoad:
            return .addNew
        default:
            return .removeOldAndAddNew
        }
    }
    
    open override func prepareForReuse() {
        layoutPhase = .reused
        layoutContentIfNeeded()
    }
    
    open override func setNeedsLayout() {
        defer {
            super.setNeedsLayout()
        }
        guard layouted else { return }
        layoutPhase = .setNeedsLayout
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        layoutContentIfNeeded()
        layoutPhase = .none
    }
}

open class CollectionMoleculeCell: UICollectionViewCell, MoleculeCell {
    private var _layoutPhase: CellLayoutingPhase = .firstLoad
    public var layoutPhase: CellLayoutingPhase {
        get {
            layouted ? _layoutPhase : .firstLoad
        }
        set {
            _layoutPhase = newValue
        }
    }
    private(set) var layouted: Bool = false
    open var layoutBehaviour: CellLayoutingBehaviour { .layoutOnce }
    
    var collectionContentWidth: CGFloat = UIScreen.main.bounds.width
    
    open func layoutContent(_ layout: LayoutInsertable) { }
    
    open func moleculeWillLayout() {}
    
    open func moleculeDidLayout() {}
    
    @discardableResult
    open func layoutContentIfNeeded() -> Bool {
        defer {
            layouted = true
        }
        switch layoutBehaviour {
        case .layoutOn(let phase):
            if layoutPhase != .firstLoad && phase != layoutPhase {
                return false
            }
        case .layoutOnEach(let phases):
            if layoutPhase != .firstLoad && !phases.contains(where: { $0 == layoutPhase }) {
                return false
            }
        case .layoutOnce:
            guard layoutPhase == .firstLoad else { return false }
        default:
            break
        }
        moleculeWillLayout()
        contentView.layoutContent(layoutOption(on: layoutPhase)) { content in
            layoutContent(content)
        }
        moleculeDidLayout()
        return true
    }
    
    open func calculatedCellSize(for collectionContentWidth: CGFloat) -> CGSize { .automatic }
    
    open override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let layouted = layoutContentIfNeeded()
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
    
    open func layoutOption(on phase: CellLayoutingPhase) -> SublayoutingOption {
        switch phase {
        case .firstLoad:
            return .addNew
        default:
            return .removeOldAndAddNew
        }
    }
    
    open override func prepareForReuse() {
        layoutPhase = .reused
        layoutContentIfNeeded()
    }
    
    open override func setNeedsLayout() {
        defer {
            super.setNeedsLayout()
        }
        guard layouted else { return }
        layoutPhase = .setNeedsLayout
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        layoutContentIfNeeded()
        layoutPhase = .none
    }
}
