//
//  HeroAttributeCellVM.swift
//  TourOfHeroes
//
//  Created by Nayanda Haberty (ID) on 22/08/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import UIKit
import NamadaLayout

class HeroAttributeCellVM: UICollectionViewCell.Model<LargeImageWithLabelCell> {
    
    @ObservableState var imageConvertible: ImageConvertible?
    @ViewState var primaryAttr: String?
    @ObservableState var selected: Bool = false
    
    override func willApplying(_ view: LargeImageWithLabelCell) {
        view.layoutMargins = selected ?
            .init(vertical: .x8, horizontal: .x4)
            : .init(vertical: .x24, horizontal: .x12)
        view.label.textColor = selected ? .black : .darkGray
        view.setNeedsLayout()
    }
    
    override func bind(with view: LargeImageWithLabelCell) {
        super.bind(with: view)
        $imageConvertible.observe(observer: self)
            .didSet(runIn: .main) { model, changes in
                model.view?.cellImage.imageConvertible = changes.new
        }
        $primaryAttr.bind(with: view.label, \.text)
        $selected.observe(observer: self)
            .didSet { model, changes in
                guard let cell = model.view, changes.new != changes.old else { return }
                cell.label.font = .systemFont(ofSize: .x16, weight: changes.new ? .semibold : .medium)
                cell.label.textColor = changes.new ? .black : .darkGray
                cell.layoutMargins = changes.new ?
                    .init(vertical: .x8, horizontal: .x4)
                    : .init(vertical: .x24, horizontal: .x12)
                cell.setNeedsLayout()
                cell.layoutIfNeeded()
                
        }
    }
    
    override func didApplying(_ view: UICollectionViewCell.Model<LargeImageWithLabelCell>.View) {
        view.cellImage.imageConvertible = imageConvertible
    }
}
