//
//  HeroCell.swift
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
    lazy var heroImage: UIImageView = build {
        $0.contentMode = .scaleAspectFit
    }
    lazy var heroLabel: UILabel = build {
        $0.font = .systemFont(ofSize: .x12)
        $0.textColor = .darkGray
        $0.lineBreakMode = .byTruncatingTail
        $0.numberOfLines = 1
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        heroImage.imageCompat = UIImage(color: .gray)
        heroLabel.text = nil
        heroLabel.attributedText = nil
    }
    
    override func layoutChild(_ thisLayout: ViewLayout) {
        thisLayout.put(heroImage) { imgLayout in
            imgLayout.fixToParent(.fullTop, with: .init(inset: .x8))
            imgLayout.size(equalWith: .init(width: .x128, height: .x192))
        }
        thisLayout.put(heroLabel) { labelLayout in
            labelLayout.atBottom(of: heroImage, spacing: .x8)
            labelLayout.fixToParent(.fullBottom, with: .init(inset: .x8))
        }
    }
}
