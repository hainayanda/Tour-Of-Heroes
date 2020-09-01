//
//  CollectionSkeletonCell.swift
//  TourOfHeroes
//
//  Created by Nayanda Haberty (ID) on 23/08/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import NamadaLayout
import UIKit
import SkeletonView

class CollectionSkeletonCell: CollectionMoleculeCell {
    
    // MARK: View
    lazy var skeletonImage: UIImageView = .init()
    lazy var skeletonLabel: UILabel = .init()
    
    override func layoutContent(_ layout: LayoutInsertable) {
        layout.put(skeletonImage)
            .at(.fullTop, .equalTo(layoutMargins), to: .parent)
            .height(.equalTo(skeletonImage.widthAnchor), multiplyBy: 4/3, constant: 0)
        layout.put(skeletonLabel)
            .at(.fullBottom, .equalTo(CGFloat.x8), to: .parent)
            .top(.equalTo(.x16), to: skeletonImage.bottomAnchor)
            .height(.equalTo(.x16))
    }
    
    override func calculatedCellSize(for collectionContentWidth: CGFloat) -> CGSize {
        let cellWidth: CGFloat = (collectionContentWidth / 3)
        let margin: UIEdgeInsets = layoutMargins
        let imageWidth: CGFloat = cellWidth - margin.left - margin.right
        let imageHeight: CGFloat = (imageWidth*4)/3
        let spaceImageToLabel: CGFloat = .x8
        let labelHeight: CGFloat = .x16
        let cellHeight: CGFloat = margin.top + imageHeight + spaceImageToLabel + labelHeight + margin.bottom
        return .init(width: cellWidth, height: cellHeight)
    }
    
    class Model: CollectionViewCellModel<CollectionSkeletonCell> {
        override func willApplying(_ view: CollectionSkeletonCell) {
            view.layoutMargins = .init(insets: .x12)
        }
        
        override func didApplying(_ view: CollectionSkeletonCell) {
            guard view.layoutPhase == .firstLoad else { return }
            dispatchOnMainThread { [weak view = view] in
                guard let view = view else { return }
                let animation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)
                view.isSkeletonable = true
                view.contentView.isSkeletonable = true
                view.skeletonImage.isSkeletonable = true
                view.skeletonImage.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .skeletonDefault), animation: animation)
                view.skeletonLabel.isSkeletonable = true
                view.skeletonLabel.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .skeletonDefault), animation: animation)
            }
        }
    }
}
