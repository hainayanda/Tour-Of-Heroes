//
//  SimilarHeroCell.swift
//  TourOfHeroes
//
//  Created by Nayanda Haberty (ID) on 24/08/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation

import NamadaLayout
import UIKit

class SimilarHeroCell: TableCellLayoutable {
    
    // MARK: View
    lazy var label: UILabel = build {
        $0.text = "Similar Hero"
        $0.font = .boldSystemFont(ofSize: .x16)
        $0.numberOfLines = 1
        $0.lineBreakMode = .byTruncatingTail
        $0.textColor = .black
    }
    lazy var hStack: UIStackView = build {
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.spacing = .x16
    }
    lazy var similarHero1: PhotoWithDetailCell = .init()
    lazy var similarHero2: PhotoWithDetailCell = .init()
    lazy var similarHero3: PhotoWithDetailCell = .init()
    
    // MARK: Dimensions
    let margins: UIEdgeInsets = .init(vertical: .x4, horizontal: .x16)
    let spacer: CGFloat = .x12
    let imageHeight: CGFloat = .x96
    let imageToLabelSpace: CGFloat = .x12
    lazy var stackHeight: CGFloat = similarHero1.layoutMargins.top
        + imageHeight + imageToLabelSpace + similarHero1.label.font.lineHeight
        + similarHero1.layoutMargins.bottom
    
    override func layoutChild(_ thisLayout: ViewLayout) {
        contentView.backgroundColor = .white
        thisLayout.put(label) { labelLayout in
            labelLayout.fixToParent(.topLeft, with: margins)
            labelLayout.height.equal(with: label.font.lineHeight)
        }
        thisLayout.put(stack: hStack) { hStackLayout in
            hStackLayout.top.distance(to: label.layout.bottom, at: spacer)
            hStackLayout.height.equal(with: stackHeight)
            hStackLayout.bottom.distanceToParent(at: margins.bottom, priority: .required)
            hStackLayout.left.distanceToParent(at: margins.left, priority: .required)
            hStackLayout.right.distanceToParent(at: margins.right, priority: .required)
            hStackLayout.putStacked(similarHero1)
            hStackLayout.putStacked(similarHero2)
            hStackLayout.putStacked(similarHero3)
        }
    }
    
    override func calculatedCellHeight(for cellWidth: CGFloat) -> CGFloat {
        return margins.top + label.font.lineHeight + spacer + stackHeight + margins.bottom
    }
    
    class Model: UITableViewCell.Model<SimilarHeroCell> {
        @ObservableState var hero1: Hero?
        @ObservableState var hero2: Hero?
        @ObservableState var hero3: Hero?
        @ObservableState var heroImage1: ImageConvertible?
        @ObservableState var heroImage2: ImageConvertible?
        @ObservableState var heroImage3: ImageConvertible?
        @ViewState var heroName1: String?
        @ViewState var heroName2: String?
        @ViewState var heroName3: String?
        
        var didTapHero: ((Hero) -> Void)?
        
        override func bind(with view: SimilarHeroCell) {
            super.bind(with: view)
            $hero1.observe(observer: self).didSet { model, changes in
                model.heroName1 = changes.new?.localizedName
                model.heroImage1 = changes.new?.imageURL
            }
            $hero2.observe(observer: self).didSet { model, changes in
                model.heroName2 = changes.new?.localizedName
                model.heroImage2 = changes.new?.imageURL
            }
            $hero3.observe(observer: self).didSet { model, changes in
                model.heroName3 = changes.new?.localizedName
                model.heroImage3 = changes.new?.imageURL
            }
            $heroImage1.observe(observer: self).didSet { model, changes in
                view.similarHero1.photoImage.imageConvertible = changes.new
            }
            $heroImage2.observe(observer: self).didSet { model, changes in
                view.similarHero2.photoImage.imageConvertible = changes.new
            }
            $heroImage3.observe(observer: self).didSet { model, changes in
                view.similarHero3.photoImage.imageConvertible = changes.new
            }
            $heroName1.bind(with: view.similarHero1.label, \.text)
            $heroName2.bind(with: view.similarHero2.label, \.text)
            $heroName3.bind(with: view.similarHero3.label, \.text)
            view.similarHero1.hoverButton.didClicked { [weak self] _ in
                guard let self = self, let hero = self.hero1 else { return }
                self.didTapHero?(hero)
            }
            view.similarHero2.hoverButton.didClicked { [weak self] _ in
                guard let self = self, let hero = self.hero2 else { return }
                self.didTapHero?(hero)
            }
            view.similarHero3.hoverButton.didClicked { [weak self] _ in
                guard let self = self, let hero = self.hero3 else { return }
                self.didTapHero?(hero)
            }
        }
        
        override func didApplying(_ view: UITableViewCell.Model<SimilarHeroCell>.View) {
            $hero1.invokeWithCurrentValue()
            $hero2.invokeWithCurrentValue()
            $hero3.invokeWithCurrentValue()
        }
    }
}
