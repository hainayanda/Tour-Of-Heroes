//
//  HeroCellVM.swift
//  TourOfHeroes
//
//  Created by Nayanda Haberty (ID) on 22/08/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import UIKit
import NamadaLayout

class HeroCellVM: CollectionViewCellModel<ImageWithLabelCell> {
    
    @ObservableState var hero: Hero = .init()
    @ObservableState var imageConvertible: ImageConvertible?
    @ViewState var text: String?
    
    override func bind(with view: ImageWithLabelCell) {
        super.bind(with: view)
        $hero.observe(observer: self)
            .didSet(runIn: .main) { model, changes in
                model.imageConvertible = changes.new.imageURL
                model.text = changes.new.localizedName
        }
        $imageConvertible.observe(observer: self)
            .didSet(runIn: .main) { model, changes in
                model.view?.cellImage.imageConvertible = changes.new
        }
        $text.observe(observer: self)
            .didSet { model, changes in
                model.view?.label.text = changes.new
        }
    }
}
