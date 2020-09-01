//
//  NavigatableTitledHeader.swift
//  TourOfHeroes
//
//  Created by Nayanda Haberty (ID) on 22/08/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import UIKit
import NamadaLayout

class NavigatableTitledHeader: CollectionMoleculeCell {
    var titleLabel: UILabel = build {
        $0.font = .boldSystemFont(ofSize: .x16)
        $0.numberOfLines = 1
        $0.lineBreakMode = .byTruncatingTail
        $0.textColor = .black
    }
    var descLabel: UILabel = build {
        $0.font = .systemFont(ofSize: .x12)
        $0.numberOfLines = 5
        $0.lineBreakMode = .byTruncatingTail
        $0.textColor = .black
    }
    var button: UIButton = build {
        $0.setTitleColor(.gray, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: .x12)
        $0.setTitle("See All", for: .normal)
    }
    
    override func moleculeWillLayout() {
        backgroundColor = .white
    }
    
    override func layoutContent(_ layout: LayoutInsertable) {
        let margins: UIEdgeInsets = .init(vertical: .x24, horizontal: .x12)
        layout.put(button)
            .at(.topRight, .equalTo(margins), to: .parent)
            .left(.moreThanTo(.x12), to: titleLabel.rightAnchor)
            .bottom(.equal, to: titleLabel.bottomAnchor)
        layout.put(titleLabel)
            .at(.topLeft, .equalTo(margins), to: .parent)
        layout.put(descLabel)
            .horizontal(.equalTo(margins), to: .parent)
            .bottom(.moreThanTo(margins.bottom), to: .parent)
            .top(.equalTo(.x8), to: titleLabel.bottomAnchor)
    }
    
    class Model: CollectionViewCellModel<NavigatableTitledHeader> {
        var shouldNavigate: ((Model) -> Void)?
        @ViewState var title: String?
        @ViewState var desc: String?
        
        override func bind(with view: NavigatableTitledHeader) {
            super.bind(with: view)
            view.button.didClicked { [weak self] button in
                guard let self = self else { return }
                self.shouldNavigate?(self)
            }
            $title.bind(with: view.titleLabel, \.text)
            $desc.bind(with: view.descLabel, \.text)
        }
    }
}
