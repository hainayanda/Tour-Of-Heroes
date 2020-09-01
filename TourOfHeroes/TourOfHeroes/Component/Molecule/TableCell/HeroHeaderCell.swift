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

class HeroHeaderCell: TableMoleculeCell {
    // MARK: View
    lazy var card: UIView = build {
        $0.backgroundColor = .white
        $0.addDropShadow(at: .top)
    }
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
    let margins: UIEdgeInsets = .init(insets: .x16)
    let imageSize: CGSize = .init(width: .x64, height: .x72)
    
    override func moleculeWillLayout() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
    }
    
    override func layoutContent(_ layout: LayoutInsertable) {
        layout.put(card)
            .top(.equalTo(topVoid), to: .parent)
            .at(.fullBottom, .equal, to: .parent)
            .layoutContent { card in
                card.put(photo)
                    .at(.fullLeft, .equalTo(margins), to: .parent)
                    .size(.equalTo(imageSize), priority: 1000)
                card.put(nameLabel)
                    .top(.equalTo(margins.top), to: .parent)
                    .right(.moreThanTo(margins.right), to: .parent)
                    .left(.equalTo(.x16), to: photo.rightAnchor)
                card.put(attributeLabel)
                    .top(.equalTo(.x2), to: nameLabel.bottomAnchor)
                    .right(.moreThanTo(margins.right), to: .parent)
                    .left(.equalTo(.x16), to: photo.rightAnchor)
                card.put(typeLabel)
                    .top(.equalTo(.x2), to: attributeLabel.bottomAnchor)
                    .right(.moreThanTo(margins.right), to: .parent)
                    .left(.equalTo(.x16), to: photo.rightAnchor)
                    .bottom(.moreThanTo(margins.bottom), to: .parent, priority: 1000)
        }
    }
    
    class Model: TableViewCellModel<HeroHeaderCell> {
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
    }
}
