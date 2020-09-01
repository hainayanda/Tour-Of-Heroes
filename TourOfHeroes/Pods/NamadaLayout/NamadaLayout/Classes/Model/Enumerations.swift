//
//  Enumerations.swift
//  NamadaLayout
//
//  Created by Nayanda Haberty (ID) on 27/08/20.
//

import Foundation

public enum LayoutDimension {
    case height
    case width
}

public enum LayoutRelation<Related> {
    case moreThanTo(Related)
    case lessThanTo(Related)
    case equalTo(Related)
    case moreThan
    case lessThan
    case equal
}

public enum InterRelation<Related> {
    case moreThanTo(Related)
    case lessThanTo(Related)
    case equalTo(Related)
}

public enum NamadaMiddlePosition {
    case horizontally(LayoutRelation<InsetsConvertible>)
    case vertically(LayoutRelation<InsetsConvertible>)
}

public enum ParentRelated: String {
    case parent
    case safeArea
}

public enum SublayoutingOption {
    case addNew
    case editExisting
    case removeOldAndAddNew
    case cleanLayoutAndAddNew
}

public enum CellLayoutingPhase {
    case firstLoad
    case setNeedsLayout
    case reused
    case none
}

public enum CellLayoutingBehaviour {
    case layoutOnce
    case layoutOn(CellLayoutingPhase)
    case layoutOnEach([CellLayoutingPhase])
    case alwaysLayout
}

public enum NamadaLayoutPosition {
    case top
    case bottom
    case left
    case right
}

public enum NamadaRelatedPosition {
    case topOf(UIView)
    case bottomOf(UIView)
    case leftOf(UIView)
    case rightOf(UIView)
    case topOfAndParallelWith(UIView)
    case bottomOfAndParallelWith(UIView)
    case leftOfAndParallelWith(UIView)
    case rightOfAndParallelWith(UIView)
}
