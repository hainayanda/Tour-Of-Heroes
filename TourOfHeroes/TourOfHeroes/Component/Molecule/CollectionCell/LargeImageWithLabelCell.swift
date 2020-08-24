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
    
    override var layoutBehaviour: CellLayoutBehaviour { .editEveryLayout }
    
    override func layoutChild(_ thisLayout: ViewLayout) {
        label.font = .systemFont(ofSize: .x16, weight: .medium)
        super.layoutChild(thisLayout)
    }
    
    override func calculatedCellSize(for collectionContentWidth: CGFloat) -> CGSize {
        let cellWidth: CGFloat = collectionContentWidth / 3
        let cellHeight: CGFloat = cellWidth * 4 / 3
        return .init(width: cellWidth, height: cellHeight)
    }
}
