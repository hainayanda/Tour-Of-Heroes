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

class HeroStatusCell: TableMoleculeCell {
    
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
        $0.detail.text = "-"
    }
    lazy var manaLabel: LabelWithDetail = build {
        $0.label.text = "Mana"
        $0.detail.text = "-"
    }
    lazy var attackLabel: LabelWithDetail = build {
        $0.label.text = "Attack"
        $0.detail.text = "-"
    }
    lazy var speedLabel: LabelWithDetail = build {
        $0.label.text = "Speed"
        $0.detail.text = "-"
    }
    lazy var armourLabel: LabelWithDetail = build {
        $0.label.text = "Armour"
        $0.detail.text = "-"
    }
    lazy var rangeLabel: LabelWithDetail = build {
        $0.label.text = "Range"
        $0.detail.text = "-"
    }
    lazy var spacerView1: UIView = .init()
    lazy var spacerView2: UIView = .init()
    
    // MARK: Dimensions
    let margins: UIEdgeInsets = .init(vertical: .x4, horizontal: .x16)
    let underlineHeight: CGFloat = .x2
    let spacer: CGFloat = .x4
    let hiSpacer: CGFloat = .x24
    let statHeight: CGFloat = .x64
    let stackSpacing: CGFloat = .x8
    lazy var stackHeight: CGFloat = statHeight + stackSpacing + statHeight
    
    override func moleculeWillLayout() {
        contentView.backgroundColor = .white
    }
    
    override func layoutContent(_ layout: LayoutInsertable) {
        layout.put(label)
            .at(.topLeft, .equalTo(margins), to: .parent)
        layout.put(underline)
            .at(.bottomOf(label), .equalTo(spacer))
            .left(.equal, to: label.leftAnchor)
            .right(.equal, to: label.rightAnchor)
            .height(.equalTo(underlineHeight))
        layout.put(hStack1)
            .top(.equalTo(hiSpacer), to: underline.bottomAnchor)
            .height(.equalTo(statHeight))
            .horizontal(.equalTo(margins), to: .parent)
            .layoutContent { content in
                content.putStacked(healthLabel)
                content.putStacked(manaLabel)
                content.putStacked(attackLabel)
                content.putStacked(speedLabel)
        }
        layout.put(hStack2)
            .top(.equalTo(stackSpacing), to: hStack1.bottomAnchor)
            .height(.equalTo(statHeight))
            .at(.fullBottom, .equalTo(margins), to: .parent)
            .layoutContent { content in
                content.putStacked(armourLabel)
                content.putStacked(rangeLabel)
                content.putStacked(spacerView1)
                content.putStacked(spacerView2)
        }
    }
    
    class Model: TableViewCellModel<HeroStatusCell> {
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
