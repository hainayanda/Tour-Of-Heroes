//
//  HeroHeaderCell.swift
//  TourOfHeroes
//
//  Created by Nayanda Haberty (ID) on 24/08/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import NamadaLayout
import UIKit

class HeroHeaderCell: TableCellLayoutable {
    // MARK: View
    lazy var photo: UIImageView = build {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = .x8
    }
    lazy var nameLabel: UILabel = build {
        $0.font = .systemFont(ofSize: .x24, weight: .heavy)
        $0.numberOfLines = 1
        $0.lineBreakMode = .byTruncatingTail
        $0.textColor = .black
    }
    lazy var attributeLabel: UILabel = build {
        $0.font = .systemFont(ofSize: .x16, weight: .medium)
        $0.numberOfLines = 1
        $0.lineBreakMode = .byTruncatingTail
        $0.textColor = .darkGray
    }
    lazy var typeLabel: UILabel = build {
        $0.font = .systemFont(ofSize: .x12)
        $0.numberOfLines = 1
        $0.lineBreakMode = .byTruncatingTail
        $0.textColor = .gray
    }
    
    // MARK: Dimension
    let topVoid: CGFloat = .x128
    let margins: UIEdgeInsets = .init(inset: .x16)
    let imageSize: CGSize = .init(width: .x64, height: .x72)
    
    override func layoutChild(_ thisLayout: ViewLayout) {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        thisLayout.putView { layout in
            layout.top.distanceToParent(at: topVoid)
            layout.fixToParent(.fullBottom)
            layout.put(photo) { photoLayout in
                photoLayout.fixToParent(.fullLeft, with: margins, priority: .required)
                photoLayout.size(equalWith: imageSize, priority: .required)
            }
            layout.put(nameLabel) { nameLayout in
                nameLayout.top.distanceToParent(at: margins.top)
                nameLayout.right.distanceToParent(moreThan: margins.right)
                nameLayout.left.distance(to: photo.layout.right, at: margins.left)
                nameLayout.height.equal(with: nameLabel.font.lineHeight)
            }
            layout.put(attributeLabel) { attrLayout in
                attrLayout.right.distanceToParent(moreThan: margins.right)
                attrLayout.left.distance(to: photo.layout.right, at: margins.left)
                attrLayout.top.distance(to: nameLabel.layout.bottom, at: .x2)
                attrLayout.height.equal(with: attributeLabel.font.lineHeight)
            }
            layout.put(typeLabel) { typeLayout in
                typeLayout.right.distanceToParent(moreThan: margins.right)
                typeLayout.left.distance(to: photo.layout.right, at: margins.left)
                typeLayout.top.distance(to: attributeLabel.layout.bottom, at: .x1)
                typeLayout.height.equal(with: typeLabel.font.lineHeight)
            }
        }
        .apply {
            $0.backgroundColor = .white
            $0.addDropShadow(at: .top)
        }
    }
    
    override func calculatedCellHeight(for cellWidth: CGFloat) -> CGFloat {
        return topVoid + margins.top + imageSize.height + margins.bottom
    }
    
    class Model: UITableViewCell.Model<HeroHeaderCell> {
        @ObservableState var hero: Hero?
        @ObservableState var heroImage: ImageConvertible?
        @ViewState var heroName: String?
        @ViewState var heroAttribute: String?
        @ViewState var heroType: String?
        
        override func bind(with view: HeroHeaderCell) {
            super.bind(with: view)
            $hero.observe(observer: self).didSet { model, changes in
                model.heroImage = changes.new?.imageURL
                model.heroName = changes.new?.localizedName
                model.heroAttribute = "Attribute: \(changes.new?.primaryAttributes ?? "-")"
                model.heroType = "Hero Type: \(changes.new?.attackType ?? "-")"
            }
            $heroImage.observe(observer: self).didSet { model, changes in
                model.view?.photo.imageConvertible = changes.new
            }
            $heroName.bind(with: view.nameLabel, \.text)
            $heroAttribute.bind(with: view.attributeLabel, \.text)
            $heroType.bind(with: view.typeLabel, \.text)
        }
        
        override func didApplying(_ view: HeroHeaderCell) {
            $hero.invokeWithCurrentValue()
        }
    }
}
