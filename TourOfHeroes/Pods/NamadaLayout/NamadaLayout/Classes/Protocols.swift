//
//  Protocols.swift
//  NamadaLayout
//
//  Created by Nayanda Haberty (ID) on 04/07/20.
//

import Foundation

public protocol ConstraintsBuilder {
    var constructedConstraints: [NSLayoutConstraint] { get }
}

public protocol LayoutBuilder: ConstraintsBuilder {
    associatedtype LayoutBuilderType: LayoutBuilder
    var context: LayoutContext { get }
    var identifier: String { get }
    var parentLayout: LayoutBuilderType? { get }
}

public protocol LayoutWithEdges {
    var top: EdgeLayout<NSLayoutYAxisAnchor> { get }
    var bottom: EdgeLayout<NSLayoutYAxisAnchor> { get }
    var left: EdgeLayout<NSLayoutXAxisAnchor> { get }
    var right: EdgeLayout<NSLayoutXAxisAnchor> { get }
}

public protocol AreaLayoutBuilder: LayoutBuilder, LayoutWithEdges {
    @discardableResult
    func fillParent(with margin: UIEdgeInsets, priority: UILayoutPriority) -> LayoutBuilderType
    @discardableResult
    func fixToParent(_ positions: [LayoutPosition], with margin: UIEdgeInsets, priority: UILayoutPriority) -> LayoutBuilderType
    func inParent(_ positions: [LayoutPosition], moreThan margin: UIEdgeInsets, priority: UILayoutPriority) -> LayoutBuilderType
    @discardableResult
    func inParent(_ positions: [LayoutPosition], lessThan margin: UIEdgeInsets, priority: UILayoutPriority) -> LayoutBuilderType
}

public protocol LayoutCompatible {
    var shouldAutoTranslatesAutoresizingMaskIntoConstraints: Bool { get }
    var viewForLayout: UIView { get }
    var layoutViewController: UIViewController? { get }
    var layout: ViewLayout { get }
    func makeLayout(delegate: LayoutBuilderDelegate, _ builder: (ViewLayout) -> Void)
    func makeLayoutCleanly(delegate: LayoutBuilderDelegate, _ builder: (ViewLayout) -> Void)
    func makeAndEditLayout(delegate: LayoutBuilderDelegate,_ builder: (ViewLayout) -> Void)
    func remakeLayout(delegate: LayoutBuilderDelegate, _ builder: (ViewLayout) -> Void)
}

public protocol MoleculeLayout {
    func layoutChild(_ thisLayout: ViewLayout)
}

public protocol StatedViewModel {
    var bindableStates: [ViewStateBindable] { get }
}

public protocol BindableViewModel: class, Buildable, StatedViewModel {
    associatedtype View: NSObject
    var view: View? { get }
    func map(from view: View)
    func apply(to view: View)
    func bind(with view: View)
    func willApplying(_ view: View)
    func didApplying(_ view: View)
    func modelWillMapped(from view: View)
    func modelDidMapped(from view: View)
    func willUnbind(with view: View?)
    func didUnbind(with view: View?)
}

public protocol Buildable {
    init()
}

public protocol ViewStateBindable {
    var bindingState: BindingState { get set }
    func unbind()
}

public protocol ObservableView {
    associatedtype Observer
    var observer: Observer? { get }
}

extension ObservableView where Self: NSObject {
    public var observer: Observer? {
        bindedModel() as? Observer
    }
}
