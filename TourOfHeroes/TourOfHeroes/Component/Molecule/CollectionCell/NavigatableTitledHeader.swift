//
//  NavigatableTitledHeader.swift
//  TourOfHeroes
//
//  Created by Nayanda Haberty (ID) on 22/08/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import UIKit
import NamadaLayout

class NavigatableTitledHeader: CollectionCellLayoutable {
    var titleLabel: UILabel = build {
        $0.font = .boldSystemFont(ofSize: .x16)
        $0.numberOfLines = 1
        $0.lineBreakMode = .byTruncatingTail
        $0.textColor = .black
    }
    var descLabel: UILabel = build {
        $0.font = .systemFont(ofSize: .x12)
        $0.numberOfLines = 5
        $0.lineBreakMode = .byTruncatingTail
        $0.textColor = .black
    }
    var button: UIButton = build {
        $0.setTitleColor(.gray, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: .x12)
        $0.setTitle("See All", for: .normal)
    }
    
    override func layoutChild(_ thisLayout: ViewLayout) {
        backgroundColor = .white
        let margin: UIEdgeInsets = .init(vertical: .x24, horizontal: .x12)
        thisLayout.put(button) { buttonLayout in
            buttonLayout.fixToParent(.topRight, with: margin.asHorizontalInset.asEdgeInset)
            buttonLayout.left.distance(to: titleLabel.layout.right, moreThan: .x12)
            buttonLayout.bottom.equal(with: titleLabel.layout.bottom)
        }
        thisLayout.put(titleLabel) { labelLayout in
            labelLayout.fixToParent(.topLeft, with: margin)
            labelLayout.height.equal(with: titleLabel.font.lineHeight, priority: .defaultHigh)
        }
        thisLayout.put(descLabel) { descLayout in
            descLayout.left.distanceToParent(at: margin.left)
            descLayout.right.distanceToParent(at: margin.right)
            descLayout.bottom.distanceToParent(moreThan: margin.bottom)
            descLayout.top.distance(to: titleLabel.layout.bottom, at: .x8)
            descLayout.width.equal(
                with: thisLayout.width,
                multipliedBy: 1,
                offsetBy: -(margin.left + margin.right),
                priority: .defaultHigh
            )
        }
    }
    
    class Model: UICollectionViewCell.Model<NavigatableTitledHeader> {
        var shouldNavigate: ((Model) -> Void)?
        @ViewState var title: String?
        @ViewState var desc: String?
        
        override func bind(with view: NavigatableTitledHeader) {
            super.bind(with: view)
            view.button.didClicked { [weak self] button in
                guard let self = self else { return }
                self.shouldNavigate?(self)
            }
            $title.bind(with: view.titleLabel, \.text)
            $desc.bind(with: view.descLabel, \.text)
        }
    }
}
