//
//  LargeImageWithLabelCell.swift
//  TourOfHeroes
//
//  Created by Nayanda Haberty (ID) on 21/08/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import NamadaLayout
import UIKit

class LargeImageWithLabelCell: ImageWithLabelCell {
    
    override open var layoutBehaviour: CellLayoutingBehaviour { .alwaysLayout }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func moleculeWillLayout() {
        label.font = .systemFont(ofSize: .x16, weight: .medium)
    }
    
    override func calculatedCellSize(for collectionContentWidth: CGFloat) -> CGSize {
        let cellWidth: CGFloat = collectionContentWidth / 3
        let cellHeight: CGFloat = cellWidth * 4 / 3
        return .init(width: cellWidth, height: cellHeight)
    }
    
    override func layoutOption(on phase: CellLayoutingPhase) -> SublayoutingOption {
        guard phase != .firstLoad else { return .addNew }
        return .removeOldAndAddNew
    }
}
