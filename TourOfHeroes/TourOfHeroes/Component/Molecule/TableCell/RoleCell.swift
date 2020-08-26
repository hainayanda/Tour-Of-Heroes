//
//  RoleCell.swift
//  TourOfHeroes
//
//  Created by Nayanda Haberty (ID) on 24/08/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation

import NamadaLayout
import UIKit

class RoleCell: TableCellLayoutable {
    
    // MARK: View
    lazy var label: UILabel = build {
        $0.text = "Role Potential"
        $0.font = .boldSystemFont(ofSize: .x16)
        $0.numberOfLines = 1
        $0.lineBreakMode = .byTruncatingTail
        $0.textColor = .black
    }
    lazy var descLabel: UILabel = build {
        $0.font = .systemFont(ofSize: .x12, weight: .medium)
        $0.numberOfLines = 3
        $0.lineBreakMode = .byTruncatingTail
        $0.textColor = .darkGray
    }
    
    // MARK: Dimensions
    let margins: UIEdgeInsets = .init(vertical: .x12, horizontal: .x16)
    let spacer: CGFloat = .x4
    
    override func layoutChild(_ thisLayout: ViewLayout) {
        contentView.backgroundColor = .white
        thisLayout.put(label) { labelLayout in
            labelLayout.fixToParent(.topLeft, with: margins)
            labelLayout.height.equal(with: label.font.lineHeight)
        }
        thisLayout.put(descLabel) { descLayout in
            descLayout.top.distance(to: label.layout.bottom, at: spacer)
            descLayout.bottom.distanceToParent(at: margins.bottom, priority: .required)
            descLayout.left.distanceToParent(at: margins.left, priority: .required)
            descLayout.right.distanceToParent(moreThan: margins.right, priority: .required)
        }
    }
    
    override func calculatedCellHeight(for cellWidth: CGFloat) -> CGFloat {
        return margins.top
            + label.font.lineHeight
            + spacer
            + (descLabel.font.lineHeight * 3)
            + margins.bottom
    }
    
    class Model: UITableViewCell.Model<RoleCell> {
        @ObservableState var roles: [String] = []
        @ViewState var label: String?
        
        override func bind(with view: RoleCell) {
            super.bind(with: view)
            $roles.observe(observer: self).didSet { model, changes in
                var text: String = "This Hero potential role are "
                for role in changes.new {
                    text = "\(text) \(role),"
                }
                model.label = text.replacingOccurrences(of: ", (\\S+),$", with: " and $1", options: .regularExpression, range: nil)
            }
            $label.bind(with: view.descLabel, \.text)
        }
    }
}
