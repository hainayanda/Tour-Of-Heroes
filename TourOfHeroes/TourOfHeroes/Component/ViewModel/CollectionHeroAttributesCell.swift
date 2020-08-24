//
//  CollectionHeroAttributesCell.swift
//  TourOfHeroes
//
//  Created by Nayanda Haberty (ID) on 23/08/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import UIKit
import NamadaLayout

class CollectionHeroAttributesCellVM: UITableViewCell.Model<CollectionInTableCell> {
    
    @ViewState var attributeVMs: [HeroWithStat] = []
    var didTap: ((LargeImageWithLabelCell, HeroAttributeCellVM) -> Void)?
    
    override func willApplying(_ view: CollectionInTableCell) {
        view.collectionView.makeAndEditLayout {
            let contentHeight: CGFloat = .x256
            let verticalMargin: CGFloat = .x8
            $0.height.equal(with: verticalMargin + contentHeight + verticalMargin)
        }
    }
    
    override func bind(with view: CollectionInTableCell) {
        super.bind(with: view)
        $attributeVMs.observe(observer: self)
            .didSet { [weak collection = view] model, changes in
                guard let collection = collection else { return }
                let heroCell: [HeroAttributeCellVM] = changes.new.compactMap { hero in
                    build { vm in
                        vm.imageConvertible = hero.img
                        vm.primaryAttr = hero.primaryAttr
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

extension CollectionHeroAttributesCellVM: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let cell = collectionView.cellForItem(at: indexPath) as? LargeImageWithLabelCell,
            let model: HeroAttributeCellVM = cell.bindedModel() else {
                return
        }
        didTap?(cell, model)
    }
}
