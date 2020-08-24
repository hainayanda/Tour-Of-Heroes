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

class LabelWithDetail: UIView, MoleculeLayout {
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
    
    func layoutChild(_ thisLayout: ViewLayout) {
        thisLayout.put(detail) { detailLayout in
            detailLayout.top.equalWithParent()
            detailLayout.center.xAxis.equalWithParent()
            detailLayout.left.distanceToParent(moreThan: .zero)
            detailLayout.right.distanceToParent(moreThan: .zero)
            detailLayout.height.equal(with: detail.font.lineHeight)
        }
        thisLayout.put(label) { labelLayout in
            labelLayout.top.equal(with: detail.layout.bottom)
            labelLayout.center.xAxis.equalWithParent()
            labelLayout.left.distanceToParent(moreThan: .zero)
            labelLayout.right.distanceToParent(moreThan: .zero)
            labelLayout.height.equal(with: label.font.lineHeight)
        }
    }
}
