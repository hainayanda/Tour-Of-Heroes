//
//  NamadaLayoutCompatible.swift
//  NamadaLayout
//
//  Created by Nayanda Haberty (ID) on 28/08/20.
//

import Foundation

public protocol NamadaLayoutCompatible { }

public extension NamadaLayoutCompatible where Self: UIView {
    func layout(withDelegate delegate: NamadaLayoutDelegate? = nil, _ options: SublayoutingOption = .addNew, _ layouter: (ViewLayout<Self>) -> Void) {
        translatesAutoresizingMaskIntoConstraints = false
        layouting(withDelegate: delegate, options, layouter)
    }
    
    func layoutContent(withDelegate delegate: NamadaLayoutDelegate? = nil, _ options: SublayoutingOption = .addNew, _ layouter: (LayoutContainer<Self>) -> Void) {
        layouting(withDelegate: delegate, options) { myLayout in
            myLayout.layoutContent(layouter)
        }
    }
    
    private func layouting(withDelegate delegate: NamadaLayoutDelegate? = nil, _ options: SublayoutingOption = .addNew, _ layouter: (ViewLayout<Self>) -> Void) {
        switch options {
        case .cleanLayoutAndAddNew:
            cleanSubViews()
        case .removeOldAndAddNew:
            removeAllNamadaCreatedConstraints()
        default:
            break
        }
        let viewLayout = ViewLayout(view: self, context: .init(delegate: delegate))
        layouter(viewLayout)
        let constraints = viewLayout.constructedConstraints
        switch options {
        case .editExisting:
            let newConstraintsIds = constraints.compactMap { $0.identifier }
            mostTopParentForLayout.removeAll(identifiedConstraints: newConstraintsIds)
        default:
            break
        }
        NSLayoutConstraint.activate(constraints)
    }
    
}

public extension NamadaLayoutCompatible where Self: UIViewController {
    func layout(withDelegate delegate: NamadaLayoutDelegate? = nil, _ options: SublayoutingOption = .addNew, _ layouter: (ViewLayout<UIView>) -> Void) {
        view.layout(withDelegate: delegate, options, layouter)
    }
    
    func layoutContent(withDelegate delegate: NamadaLayoutDelegate? = nil, _ options: SublayoutingOption = .addNew, _ layouter: (LayoutContainer<UIView>) -> Void) {
        view.layoutContent(withDelegate: delegate, options, layouter)
    }
}

extension UIView: NamadaLayoutCompatible { }

extension UIViewController: NamadaLayoutCompatible { }
