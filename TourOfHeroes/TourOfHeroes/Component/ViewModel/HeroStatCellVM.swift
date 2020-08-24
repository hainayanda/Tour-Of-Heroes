//
//  HeroStatCellVM.swift
//  TourOfHeroes
//
//  Created by Nayanda Haberty (ID) on 22/08/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import UIKit
import NamadaLayout

class HeroAttributeCellVM: UICollectionViewCell.Model<LargeImageWithLabelCell> {
    
    @ViewState var imageConvertible: ImageConvertible?
    @ViewState var primaryAttr: String?
    
    override func bind(with view: LargeImageWithLabelCell) {
        super.bind(with: view)
        $imageConvertible.observe(observer: self)
            .didSet(runIn: .main) { [weak view = view] _, changes in
                view?.heroImage.imageConvertible = changes.new
        }
        $primaryAttr.bind(with: view.heroLabel, \.text)
    }
    
    override func didApplying(_ view: UICollectionViewCell.Model<LargeImageWithLabelCell>.View) {
        view.heroImage.imageConvertible = imageConvertible
    }
}
