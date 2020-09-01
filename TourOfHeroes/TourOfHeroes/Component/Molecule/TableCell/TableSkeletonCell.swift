//
//  TableSkeletonCell.swift
//  TourOfHeroes
//
//  Created by Nayanda Haberty (ID) on 22/08/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import UIKit
import NamadaLayout
import SkeletonView

class TableSkeletonCell: TableMoleculeCell {
    
    lazy var skeletonImage: UIImageView = .init()
    lazy var verticalStack: UIStackView = build {
        $0.isSkeletonable = true
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = .x8
    }
    lazy var labels: [UILabel] = [.init(), .init(), .init(), .init()]
    lazy var skeletonLabel2: UILabel = .init()
    lazy var skeletonLabel3: UILabel = .init()
    lazy var skeletonLabel4: UILabel = .init()
    
    override func layoutContent(_ layout: LayoutInsertable) {
        layout.put(skeletonImage)
            .at(.fullLeft, .equalTo(CGFloat.x16), to: .parent)
            .size(.equalTo(.init(width: .x96, height: .x128)))
        layout.put(verticalStack)
            .at(.topRight, .equalTo(CGFloat.x24), to: .parent)
            .left(.equalTo(.x16), to: .parent)
            .bottom(.moreThanTo(.x24), to: .safeArea)
            .layoutContent { stack in
                for label in labels {
                    stack.putStacked(label).height(.equalTo(.x16))
                }
        }
    }
    
    class Model: TableViewCellModel<TableSkeletonCell> {
        override func didApplying(_ view: TableSkeletonCell) {
            dispatchOnMainThread { [weak view = view] in
                guard let view = view else { return }
                view.isSkeletonable = true
                view.contentView.isSkeletonable = true
                view.skeletonImage.isSkeletonable = true
                let animation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)
                view.skeletonImage.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .skeletonDefault), animation: animation)
                for label in view.labels {
                    label.isSkeletonable = true
                    label.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .skeletonDefault), animation: animation)
                }
            }
        }
    }
}
