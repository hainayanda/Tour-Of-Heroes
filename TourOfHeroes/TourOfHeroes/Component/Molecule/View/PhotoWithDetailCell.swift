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

class PhotoWithDetailCell: UIView, MoleculeView {
    
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
    
    var photoSize: CGSize = .init(width: .x72, height: .x72)
    
    func layoutContent(_ layout: LayoutInsertable) {
        layout.put(photoImage)
            .size(.equalTo(photoSize), priority: 1000)
            .at(.fullTop, .moreThanTo(layoutMargins), to: .parent)
            .centerX(.equal, to: .parent)
        layout.put(label)
            .top(.equalTo(.x12), to: photoImage.bottomAnchor)
            .at(.fullBottom, .equalTo(layoutMargins), to: .parent)
        layout.put(hoverButton)
            .edges(.equal, to: .parent)
    }
}
