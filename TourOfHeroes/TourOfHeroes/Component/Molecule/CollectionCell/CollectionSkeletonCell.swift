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

class CollectionSkeletonCell: CollectionCellLayoutable {
    
    // MARK: View
    lazy var skeletonImage: UIImageView = .init()
    lazy var skeletonLabel: UILabel = .init()
    
    override func layoutChild(_ thisLayout: ViewLayout) {
        thisLayout.put(skeletonImage) { imgLayout in
            imgLayout.fixToParent(.fullTop, with: layoutMargins)
            imgLayout.height.equal(with: imgLayout.width, multipliedBy: 4/3)
        }
        thisLayout.put(skeletonLabel) { labelLayout in
            labelLayout.top.distance(to: skeletonImage.layout.bottom, at: .x16)
            labelLayout.fixToParent(.fullBottom, with: .init(inset: .x8))
            labelLayout.height.equal(with: .x16)
        }
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
    
    class Model: UICollectionViewCell.Model<CollectionSkeletonCell> {
        override func willApplying(_ view: UICollectionViewCell.Model<CollectionSkeletonCell>.View) {
            view.layoutMargins = .init(inset: .x12)
        }
        
        override func didApplying(_ view: CollectionSkeletonCell) {
            guard view.layoutPhase == .initial else { return }
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
