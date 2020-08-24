//
//  PhotoWithDetailCell.swift
//  TourOfHeroes
//
//  Created by Nayanda Haberty (ID) on 24/08/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import NamadaLayout
import UIKit

class PhotoWithDetailCell: UIView, MoleculeLayout {
    
    // MARK: View
    lazy var hoverButton: UIButton = build {
        $0.backgroundColor = .clear
        $0.setTitle(nil, for: .normal)
    }
    lazy var photoImage: UIImageView = build {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = .x8
    }
    lazy var label: UILabel = build {
        $0.font = .systemFont(ofSize: .x12, weight: .medium)
        $0.textColor = .darkGray
        $0.lineBreakMode = .byTruncatingTail
        $0.numberOfLines = 1
        $0.textAlignment = .center
    }
    
    var photoSize: CGSize = .init(width: .x72, height: .x96)
    
    func layoutChild(_ thisLayout: ViewLayout) {
        let labelHeight: CGFloat = label.font.lineHeight
        thisLayout.put(photoImage) { imgLayout in
            imgLayout.fixToParent(.fullTop, with: layoutMargins)
            imgLayout.size(equalWith: photoSize, priority: .defaultHigh)
        }
        thisLayout.put(label) { labelLayout in
            labelLayout.atBottom(of: photoImage, spacing: .x12)
            labelLayout.fixToParent(.fullBottom, with: layoutMargins)
            labelLayout.height.equal(with: labelHeight)
        }
        thisLayout.put(hoverButton) { btnLayout in
            btnLayout.fillParent()
        }
    }
}
