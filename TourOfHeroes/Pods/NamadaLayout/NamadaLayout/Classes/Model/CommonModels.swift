//
//  CommonModels.swift
//  NamadaLayout
//
//  Created by Nayanda Haberty (ID) on 07/07/20.
//

import Foundation

public enum LayoutPosition {
    case top
    case bottom
    case left
    case right
}

public enum BindingState {
    case mapping
    case applying
    case none
}

public enum LayoutStackedStrategy {
    case emptying
    case append
    case replaceDifferences
}

public enum CellReloadStrategy {
    case reloadAll
    case reloadLinearDifferences
    case reloadArangementDifferences
}
