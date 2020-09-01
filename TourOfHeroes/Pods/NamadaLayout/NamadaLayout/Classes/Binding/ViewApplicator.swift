//
//  ViewApplicator.swift
//  NamadaLayout
//
//  Created by Nayanda Haberty (ID) on 18/08/20.
//

import Foundation
import UIKit

public extension NamadaLayoutable {
    
    @discardableResult
    func apply(_ applicator: (View) -> Void) -> Self {
        applicator(view)
        return self
    }
    
    @discardableResult
    func apply<Property>(
        _ keyPath: ReferenceWritableKeyPath<View, Property>,
        with viewState: ViewState<Property>,
        stateDidSet: @escaping (View, Changes<Property>) -> Void = { _, _ in },
        viewDidSet: @escaping (View, Changes<Property>) -> Void = { _, _ in }) -> Self {
        viewState.bindingState = .applying
        return bind(keyPath, with: viewState, stateDidSet: stateDidSet, viewDidSet: viewDidSet)
    }
    
    @discardableResult
    func map<Property>(
        _ keyPath: ReferenceWritableKeyPath<View, Property>,
        with viewState: ViewState<Property>,
        stateDidSet: @escaping (View, Changes<Property>) -> Void = { _, _ in },
        viewDidSet: @escaping (View, Changes<Property>) -> Void = { _, _ in }) -> Self {
        viewState.bindingState = .mapping
        return bind(keyPath, with: viewState, stateDidSet: stateDidSet, viewDidSet: viewDidSet)
    }
    
    @discardableResult
    func bind<Property>(
        _ keyPath: ReferenceWritableKeyPath<View, Property>,
        with viewState: ViewState<Property>,
        stateDidSet: @escaping (View, Changes<Property>) -> Void = { _, _ in },
        viewDidSet: @escaping (View, Changes<Property>) -> Void = { _, _ in }) -> Self {
        viewState.bind(with: view, keyPath)
            .viewDidSet(then: viewDidSet)
            .stateDidSet(then: stateDidSet)
        return self
    }
    
    @discardableResult
    func oneWayBind<Property>(
        _ keyPath: KeyPath<View, Property>,
        into viewState: ViewState<Property>,
        state: BindingState = .none,
        viewDidSet: @escaping (View, Changes<Property>) -> Void = { _, _ in }) -> Self {
        viewState.oneWayBind(with: view, keyPath).viewDidSet(then: viewDidSet)
        return self
    }
    
    @discardableResult
    func apply<VM: ViewModel<View>>(viewModel: VM) -> Self {
        viewModel.apply(to: view)
        return self
    }
    
    @discardableResult
    func map<VM: ViewModel<View>>(into viewModel: VM) -> Self {
        viewModel.map(from: view)
        return self
    }
    
    @discardableResult
    func bind<VM: ViewModel<View>>(viewModel: VM) -> Self {
        viewModel.bind(with: view)
        return self
    }
}
