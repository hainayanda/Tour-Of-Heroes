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
    func put<View: UIView>(_ view: View) -> ViewLayout<View>
    @discardableResult
    func put(_ viewController: UIViewController) -> ViewLayout<UIView>
}

public protocol ViewLayoutInsertable: LayoutInsertable {
    associatedtype View: UIView
    var view: View { get }
}

public extension ViewLayoutInsertable where View: UIStackView {
    @discardableResult
    func putStacked<View>(_ view: View) -> ViewLayout<View> where View : UIView {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addArrangedSubview(view)
        let layoutable = ViewLayout(view: view, context: context)
        subLayoutables.append(layoutable)
        if let molecule = view as? MoleculeView {
            layoutable.layoutContent(molecule.layoutContent(_:))
        }
        return layoutable
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
    
    @discardableResult
    public func put<View>(_ view: View) -> ViewLayout<View> where View : UIView {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(view)
        let layoutable = ViewLayout(view: view, context: context)
        subLayoutables.append(layoutable)
        if let molecule = view as? MoleculeView {
            layoutable.layoutContent(molecule.layoutContent(_:))
        }
        return layoutable
    }
    
    public func put(_ viewController: UIViewController) -> ViewLayout<UIView> {
        if let parentController: UIViewController = view.parentViewController
            ?? context.delegate.namadaLayout(neededViewControllerFor: viewController) {
            parentController.addChild(viewController)
        } else {
            context.delegate.namadaLayout(view, erroWhenLayout: .init(description: "Try to put UIViewController when view is not in UIViewController"))
        }
        return put(viewController.view)
    }
}
