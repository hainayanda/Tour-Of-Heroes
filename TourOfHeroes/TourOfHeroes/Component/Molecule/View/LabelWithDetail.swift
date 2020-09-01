//
//  LabelWithDetail.swift
//  TourOfHeroes
//
//  Created by Nayanda Haberty (ID) on 24/08/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import NamadaLayout
import UIKit

class LabelWithDetail: UIView, MoleculeView {
    lazy var label: UILabel = build {
        $0.font = .boldSystemFont(ofSize: .x12)
        $0.numberOfLines = 1
        $0.lineBreakMode = .byTruncatingTail
        $0.textColor = .gray
        $0.textAlignment = .center
    }
    lazy var detail: UILabel = build {
        $0.font = .boldSystemFont(ofSize: .x16)
        $0.numberOfLines = 1
        $0.lineBreakMode = .byTruncatingTail
        $0.textColor = .black
        $0.textAlignment = .center
    }
    
    func layoutContent(_ layout: LayoutInsertable) {
        layout.put(detail)
            .top(.equal, to: .parent)
            .horizontal(.moreThan, to: .parent)
            .centerX(.equal, to: .parent)
        layout.put(label)
            .top(.equal, to: detail.bottomAnchor)
            .horizontal(.moreThan, to: .parent)
            .centerX(.equal, to: .parent)
            .bottom(.equal, to: .parent)
        
    }
}
