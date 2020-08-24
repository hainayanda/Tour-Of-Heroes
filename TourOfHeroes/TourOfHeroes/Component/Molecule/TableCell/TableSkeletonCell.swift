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

class TableSkeletonCell: TableCellLayoutable {
    
    lazy var skeletonImage: UIImageView = .init()
    lazy var labels: [UILabel] = [.init(), .init(), .init(), .init()]
    lazy var skeletonLabel2: UILabel = .init()
    lazy var skeletonLabel3: UILabel = .init()
    lazy var skeletonLabel4: UILabel = .init()
    
    override func layoutChild(_ thisLayout: ViewLayout) {
        thisLayout.put(skeletonImage) { imageLayout in
            imageLayout.fixToParent(.fullLeft, with: .init(inset: .x16))
            imageLayout.size(equalWith: .init(width: .x96, height: .x128))
        }
        thisLayout.putVerticalStack { stackLayout in
            for label in labels {
                stackLayout.putStacked(label) {
                    $0.height.equal(with: .x16)
                }
                stackLayout.put(spacing: .x8)
            }
            stackLayout.fixToParent(.topRight, with: .init(inset: .x24))
            stackLayout.left.distance(to: skeletonImage.layout.right, at: .x16)
            stackLayout.bottom.distanceToSafeArea(moreThan: .x24)
        }.apply {
            $0.isSkeletonable = true
            $0.alignment = .fill
            $0.distribution = .fill
        }
    }
    
    class Model: UITableViewCell.Model<TableSkeletonCell> {
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
