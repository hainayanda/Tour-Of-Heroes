//
//  MoleculeLayout.swift
//  NamadaLayout
//
//  Created by Nayanda Haberty (ID) on 27/08/20.
//

import Foundation
import UIKit

public protocol MoleculeView {
    func moleculeWillLayout()
    func layoutContent(_ layout: LayoutInsertable)
    func moleculeDidLayout()
}

public extension MoleculeView {
    func moleculeWillLayout() { }
    func moleculeDidLayout() { }
}

public extension MoleculeView where Self: UIView {
    
    func layoutMolecule(delegate: NamadaLayoutDelegate? = nil) {
        let viewLayout = ViewLayout<Self>(view: self, context: .init(delegate: delegate))
        moleculeWillLayout()
        viewLayout.layoutContent(self.layoutContent(_:))
        moleculeDidLayout()
        NSLayoutConstraint.activate(viewLayout.constructedConstraints)
    }
    
    func reLayout(delegate: NamadaLayoutDelegate? = nil) {
        removeAllNamadaCreatedConstraints()
        layoutMolecule(delegate: delegate)
    }
}
