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

class ImageWithLabelCell: CollectionCellLayoutable {
    
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
    
    override func layoutChild(_ thisLayout: ViewLayout) {
        let labelHeight: CGFloat = label.font.lineHeight
        thisLayout.put(cellImage) { imgLayout in
            imgLayout.fixToParent(.fullTop, with: layoutMargins)
            imgLayout.width.equal(
                with: thisLayout.width,
                multipliedBy: 1,
                offsetBy: -(layoutMargins.left + layoutMargins.right),
                priority: .required
            )
            imgLayout.height.equal(
                with: thisLayout.height,
                multipliedBy: 1,
                offsetBy: -(layoutMargins.top + .x16 + labelHeight + layoutMargins.bottom),
                priority: .required
            )
        }
        thisLayout.put(label) { labelLayout in
            labelLayout.atBottom(of: cellImage, spacing: .x16)
            labelLayout.fixToParent(.fullBottom, with: layoutMargins)
            labelLayout.height.equal(with: labelHeight)
            labelLayout.width.lessThan(
                cellImage.layout.width,
                multipliedBy: 1,
                offsetBy: 0,
                priority: .required
            )
        }
    }
    
    override func calculatedCellSize(for collectionContentWidth: CGFloat) -> CGSize {
        let cellWidth: CGFloat = collectionContentWidth / 4
        let cellHeight: CGFloat = cellWidth * 4 / 3
        return .init(width: cellWidth, height: cellHeight)
    }
}
