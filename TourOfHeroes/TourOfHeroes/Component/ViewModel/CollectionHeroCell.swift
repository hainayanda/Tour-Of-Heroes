//
//  CollectionHeroCell.swift
//  TourOfHeroes
//
//  Created by Nayanda Haberty (ID) on 23/08/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import UIKit
import NamadaLayout

class CollectionHeroCellVM: UITableViewCell.Model<CollectionInTableCell> {
    
    @ViewState var attributeVMs: [HeroWithStat] = []
    var didTap: ((ImageWithLabelCell, HeroCellVM) -> Void)?
    
    override func willApplying(_ view: CollectionInTableCell) {
        view.collectionView.makeAndEditLayout {
            let contentHeight: CGFloat = .x192
            let verticalMargin: CGFloat = .x8
            let singleHeight: CGFloat = verticalMargin + contentHeight + verticalMargin
            $0.height.equal(with: singleHeight * 4)
        }
    }
    
    override func bind(with view: CollectionInTableCell) {
        super.bind(with: view)
        $attributeVMs.observe(observer: self)
            .didSet { [weak collection = view] model, changes in
                guard let collection = collection else { return }
                let heroCell: [HeroCellVM] = changes.new.compactMap { hero in
                    build { vm in
                        vm.hero = hero
                    }
                }
                collection.collectionView.cells = heroCell
        }
    }
    
    override func didApplying(_ view: CollectionInTableCell) {
        view.collectionView.allowsSelection = true
        view.collectionView.delegate = self
    }
}

extension CollectionHeroCellVM: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let cell = collectionView.cellForItem(at: indexPath) as? ImageWithLabelCell,
            let model: HeroCellVM = cell.bindedModel() else {
                return
        }
        didTap?(cell, model)
    }
}
