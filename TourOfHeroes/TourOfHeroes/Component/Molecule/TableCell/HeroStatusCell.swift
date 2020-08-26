//
//  HeroStatusCell.swift
//  TourOfHeroes
//
//  Created by Nayanda Haberty (ID) on 24/08/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation

import NamadaLayout
import UIKit

class HeroStatusCell: TableCellLayoutable {
    
    // MARK: View
    lazy var label: UILabel = build {
        $0.text = "STATS"
        $0.font = .systemFont(ofSize: .x16, weight: .heavy)
        $0.numberOfLines = 1
        $0.lineBreakMode = .byTruncatingTail
        $0.textColor = .black
    }
    lazy var hStack1: UIStackView = build {
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.spacing = stackSpacing
    }
    lazy var hStack2: UIStackView = build {
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.spacing = stackSpacing
    }
    lazy var underline: UIView = build {
        $0.backgroundColor = .midnightBlue
    }
    lazy var healthLabel: LabelWithDetail = build {
        $0.label.text = "Health"
    }
    lazy var manaLabel: LabelWithDetail = build {
        $0.label.text = "Mana"
    }
    lazy var attackLabel: LabelWithDetail = build {
        $0.label.text = "Attack"
    }
    lazy var speedLabel: LabelWithDetail = build {
        $0.label.text = "Speed"
    }
    lazy var armourLabel: LabelWithDetail = build {
        $0.label.text = "Armour"
    }
    lazy var rangeLabel: LabelWithDetail = build {
        $0.label.text = "Range"
    }
    
    // MARK: Dimensions
    let margins: UIEdgeInsets = .init(vertical: .x4, horizontal: .x16)
    let underlineHeight: CGFloat = .x2
    let spacer: CGFloat = .x4
    let hiSpacer: CGFloat = .x24
    let statHeight: CGFloat = .x48
    let stackSpacing: CGFloat = .x8
    lazy var stackHeight: CGFloat = statHeight + stackSpacing + statHeight
    
    override func layoutChild(_ thisLayout: ViewLayout) {
        contentView.backgroundColor = .white
        thisLayout.put(label) { labelLayout in
            labelLayout.fixToParent(.topLeft, with: margins)
            labelLayout.height.equal(with: label.font.lineHeight)
        }
        thisLayout.put(underline) { layout in
            layout.atBottom(of: label, spacing: spacer)
            layout.width.equal(with: label.layout.width)
            layout.height.equal(with: underlineHeight)
        }
        thisLayout.put(stack: hStack1) { hStackLayout1 in
            hStackLayout1.top.distance(to: underline.layout.bottom, at: hiSpacer)
            hStackLayout1.height.equal(with: statHeight)
            hStackLayout1.fixToParent(.horizontal, with: margins)
            hStackLayout1.putStacked(healthLabel)
            hStackLayout1.putStacked(manaLabel)
            hStackLayout1.putStacked(attackLabel)
            hStackLayout1.putStacked(speedLabel)
        }
        thisLayout.put(stack: hStack2) { hStackLayout2 in
            hStackLayout2.top.distance(to: hStack1.layout.bottom, at: stackSpacing)
            hStackLayout2.height.equal(with: statHeight)
            hStackLayout2.fixToParent(.fullBottom, with: margins)
            hStackLayout2.putStacked(armourLabel)
            hStackLayout2.putStacked(rangeLabel)
            hStackLayout2.putStackedView(restorationId: "empty_view_1", { _ in })
            hStackLayout2.putStackedView(restorationId: "empty_view_2",  { _ in })
        }
    }
    
    class Model: UITableViewCell.Model<HeroStatusCell> {
        @ObservableState var hero: Hero?
        @ViewState var heroHealth: String?
        @ViewState var heroMana: String?
        @ViewState var heroAttack: String?
        @ViewState var heroSpeed: String?
        @ViewState var heroArmour: String?
        @ViewState var heroRange: String?
        
        override func bind(with view: HeroStatusCell) {
            super.bind(with: view)
            $hero.observe(observer: self).didSet { model, changes in
                model.heroHealth = "\(changes.new?.baseHealth ?? 0)"
                model.heroMana = "\(changes.new?.baseMana ?? 0)"
                model.heroAttack = "\(changes.new?.baseAttackMax ?? 0)"
                model.heroSpeed = "\(changes.new?.moveSpeed ?? 0)"
                model.heroArmour = "\(changes.new?.baseArmor ?? 0)"
                model.heroRange = "\(changes.new?.attackRange ?? 0)"
            }
            $heroHealth.bind(with: view.healthLabel.detail, \.text)
            $heroMana.bind(with: view.manaLabel.detail, \.text)
            $heroAttack.bind(with: view.attackLabel.detail, \.text)
            $heroSpeed.bind(with: view.speedLabel.detail, \.text)
            $heroArmour.bind(with: view.armourLabel.detail, \.text)
            $heroRange.bind(with: view.rangeLabel.detail, \.text)
        }
    }
}
