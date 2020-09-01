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

class HeroAttributeCellVM: CollectionViewCellModel<LargeImageWithLabelCell> {
    
    @ObservableState var imageConvertible: ImageConvertible?
    @ObservableState var primaryAttr: String?
    @ObservableState var selected: Bool = false
    
    override func willApplying(_ view: LargeImageWithLabelCell) {
        view.layoutMargins = selected ?
            .init(vertical: .x8, horizontal: .x4)
            : .init(vertical: .x24, horizontal: .x12)
        view.label.font = .systemFont(ofSize: .x16, weight: selected ? .semibold : .medium)
        view.label.textColor = selected ? .black : .darkGray
    }
    
    override func bind(with view: LargeImageWithLabelCell) {
        super.bind(with: view)
        $imageConvertible.observe(observer: self)
            .didSet(runIn: .main) { model, changes in
                model.view?.cellImage.imageConvertible = changes.new
        }
        $selected.observe(observer: self)
            .didSet { model, changes in
                guard let cell = model.view else { return }
                cell.label.font = .systemFont(ofSize: .x16, weight: changes.new ? .semibold : .medium)
                cell.label.textColor = changes.new ? .black : .darkGray
                cell.layoutMargins = changes.new ?
                    .init(vertical: .x8, horizontal: .x4)
                    : .init(vertical: .x24, horizontal: .x12)
                UIView.animate(withDuration: .fluid) {
                    cell.setNeedsLayout()
                }
                
        }
        $primaryAttr.observe(observer: self)
            .didSet { model, changes in
                model.view?.label.text = changes.new
        }
    }
}
