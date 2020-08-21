//
//  ViewApplicator.swift
//  NamadaLayout
//
//  Created by Nayanda Haberty (ID) on 18/08/20.
//

import Foundation
import UIKit

public class ViewApplicator<View: UIView> {
    var view: View
    
    init(view: View) {
        self.view = view
    }
    
    @discardableResult
    public func apply(_ applicator: (View) -> Void) -> ViewApplicator<View> {
        applicator(view)
        return self
    }
    
    @discardableResult
    public func apply<Property>(
        _ keyPath: ReferenceWritableKeyPath<View, Property>,
        with viewState: ViewState<Property>,
        stateDidSet: @escaping (View, Changes<Property>) -> Void = { _, _ in },
        viewDidSet: @escaping (View, Changes<Property>) -> Void = { _, _ in }) -> ViewApplicator<View> {
        bind(keyPath, with: viewState, state: .applying, stateDidSet: stateDidSet, viewDidSet: viewDidSet)
    }
    
    @discardableResult
    public func map<Property>(
        _ keyPath: ReferenceWritableKeyPath<View, Property>,
        with viewState: ViewState<Property>,
        stateDidSet: @escaping (View, Changes<Property>) -> Void = { _, _ in },
        viewDidSet: @escaping (View, Changes<Property>) -> Void = { _, _ in }) -> ViewApplicator<View> {
        bind(keyPath, with: viewState, state: .mapping, stateDidSet: stateDidSet, viewDidSet: viewDidSet)
    }
    
    @discardableResult
    public func bind<Property>(
        _ keyPath: ReferenceWritableKeyPath<View, Property>,
        with viewState: ViewState<Property>,
        state: BindingState = .none,
        stateDidSet: @escaping (View, Changes<Property>) -> Void = { _, _ in },
        viewDidSet: @escaping (View, Changes<Property>) -> Void = { _, _ in }) -> ViewApplicator<View> {
        viewState.bind(with: view, keyPath, state: state)
            .viewDidSet(then: viewDidSet)
            .stateDidSet(then: stateDidSet)
        return self
    }
    
    @discardableResult
    public func oneWayBind<Property>(
        _ keyPath: KeyPath<View, Property>,
        into viewState: ViewState<Property>,
        state: BindingState = .none,
        viewDidSet: @escaping (View, Changes<Property>) -> Void = { _, _ in }) -> ViewApplicator<View> {
        viewState.oneWayBind(with: view, keyPath).viewDidSet(then: viewDidSet)
        return self
    }
    
    @discardableResult
    public func apply<VM: ViewModel<View>>(viewModel: VM) -> ViewApplicator<View> {
        viewModel.apply(to: view)
        return self
    }
    
    @discardableResult
    public func map<VM: ViewModel<View>>(into viewModel: VM) -> ViewApplicator<View> {
        viewModel.map(from: view)
        return self
    }
    
    @discardableResult
    public func bind<VM: ViewModel<View>>(viewModel: VM) -> ViewApplicator<View> {
        viewModel.bind(with: view)
        return self
    }
}
