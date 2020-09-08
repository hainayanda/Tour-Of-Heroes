//
//  LayoutInsertable.swift
//  NamadaLayout
//
//  Created by Nayanda Haberty (ID) on 27/08/20.
//

import Foundation
import UIKit

public protocol LayoutInsertable: class {
    var subLayoutables: [LayoutConstraintsBuilder] { get set }
    var context: LayoutContext { get }
    @discardableResult
    func put<V: UIView>(_ view: V) -> ViewLayout<V>
    @discardableResult
    func put(_ viewController: UIViewController) -> ViewLayout<UIView>
}

public protocol ViewLayoutInsertable: LayoutInsertable {
    associatedtype View: UIView
    var view: View { get }
}

public extension ViewLayoutInsertable where View: UIStackView {
    @discardableResult
    func putStacked<V>(_ view: V) -> ViewLayout<V> where V : UIView {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addArrangedSubview(view)
        let layoutable = ViewLayout(view: view, context: context)
        subLayoutables.append(layoutable)
        if let molecule = view as? MoleculeView {
            layoutable.layoutContent(molecule.layoutContent(_:))
        }
        return layoutable
    }
    
    @discardableResult
    func putStacked(_ viewController: UIViewController) -> ViewLayout<UIView> {
        if let parentController: UIViewController = view.parentViewController
            ?? context.delegate.namadaLayout(neededViewControllerFor: viewController) {
            parentController.addChild(viewController)
        } else {
            context.delegate.namadaLayout(
                view,
                erroWhenLayout: .init(description:
                    "Try to put UIViewController when view is not in UIViewController"
                )
            )
        }
        return putStacked(viewController.view)
    }
}

public extension ViewLayoutInsertable {
    @discardableResult
    func put<V: UIView>(_ view: V) -> ViewLayout<V> {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(view)
        let layoutable = ViewLayout(view: view, context: context)
        subLayoutables.append(layoutable)
        if let molecule = view as? MoleculeView {
            layoutable.layoutContent(molecule.layoutContent(_:))
        }
        return layoutable
    }
    
    @discardableResult
    func put(_ viewController: UIViewController) -> ViewLayout<UIView> {
        if let parentController: UIViewController = view.parentViewController
            ?? context.delegate.namadaLayout(neededViewControllerFor: viewController) {
            parentController.addChild(viewController)
        } else {
            context.delegate.namadaLayout(
                view,
                erroWhenLayout: .init(description:
                    "Try to put UIViewController when view is not in UIViewController"
                )
            )
        }
        return put(viewController.view)
    }
}

public class LayoutContainer<View: UIView>: ViewLayoutInsertable {
    public var view: View
    public var subLayoutables: [LayoutConstraintsBuilder] = []
    public var context: LayoutContext
    
    init(view: View, context: LayoutContext) {
        self.view = view
        self.context = context
    }
}
