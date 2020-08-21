//
//  LargeHeroCell.swift
//  TourOfHeroes
//
//  Created by Nayanda Haberty (ID) on 21/08/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import NamadaLayout
import UIKit

class LargeHeroCell: CollectionCellLayoutable {
    
    // MARK: View
    lazy var heroImage: UIImageView = build {
        $0.contentMode = .scaleAspectFit
    }
    lazy var heroLabel: UILabel = build {
        $0.font = .systemFont(ofSize: 16, weight: .medium)
        $0.textColor = .darkGray
        $0.lineBreakMode = .byTruncatingTail
        $0.numberOfLines = 1
    }
    
    override func layoutChild(_ thisLayout: ViewLayout) {
        thisLayout.put(heroImage) { imgLayout in
            imgLayout.fixToParent(.fullTop, with: .init(inset: 18))
        }
        thisLayout.put(heroLabel) { labelLayout in
            labelLayout.atBottom(of: heroImage, spacing: 9)
            labelLayout.fixToParent(.fullTop, with: .init(inset: 18))
            
        }
    }
}
