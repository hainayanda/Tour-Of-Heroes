//
//  Protocols.swift
//  NamadaLayout
//
//  Created by Nayanda Haberty (ID) on 04/07/20.
//

import Foundation

public protocol StatedViewModel {
    var bindableStates: [ViewStateBindable] { get }
    var observables: [StateObservable] { get }
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

public protocol ViewModelObserver {
    func viewDidLayouted(_ view: Any)
}

public protocol ObservableView {
    associatedtype Observer
    var observer: Observer? { get }
}
