//
//  ImageWithLabelCell.swift
//  TourOfHeroes
//
//  Created by Nayanda Haberty (ID) on 22/08/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import NamadaLayout
import UIKit

class ImageWithLabelCell: CollectionMoleculeCell {
    
    override open var layoutBehaviour: CellLayoutingBehaviour { .layoutOnce }
    
    // MARK: View
    lazy var cellImage: UIImageView = build {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = .x8
    }
    lazy var label: UILabel = build {
        $0.font = .systemFont(ofSize: .x12)
        $0.textColor = .darkGray
        $0.lineBreakMode = .byTruncatingTail
        $0.numberOfLines = 1
        $0.textAlignment = .center
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.image = .placeHolder
        label.text = nil
        label.attributedText = nil
    }
    
    override func layoutContent(_ layout: LayoutInsertable) {
        layout.put(cellImage)
            .at(.fullTop, .equalTo(layoutMargins), to: .parent)
        layout.put(label)
            .top(.equalTo(.x16), to: cellImage.bottomAnchor)
            .at(.fullBottom, .equalTo(layoutMargins), to: .parent)
            .height(.equalTo(label.font.lineHeight))
    }
    
    override func calculatedCellSize(for collectionContentWidth: CGFloat) -> CGSize {
        let cellWidth: CGFloat = collectionContentWidth / 4
        let cellHeight: CGFloat = cellWidth * 4 / 3
        return .init(width: cellWidth, height: cellHeight)
    }
}
