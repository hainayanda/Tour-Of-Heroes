//
//  ViewModel.swift
//  NamadaLayout
//
//  Created by Nayanda Haberty (ID) on 06/08/20.
//

import Foundation
import UIKit

public func build<B: Buildable>(_ builder: (inout B) -> Void) -> B {
    var buildable = B.init()
    builder(&buildable)
    return buildable
}

extension StatedViewModel {
    
    private func extractStateBindables(from mirror: Mirror, into states: inout [ViewStateBindable]) {
        for child in mirror.children {
            if let stateBindable = child.value as? ViewStateBindable {
                states.append(stateBindable)
            } else if let model = child.value as? StatedViewModel {
                states.append(contentsOf: model.bindableStates)
            }
        }
    }
    
    public var bindableStates: [ViewStateBindable] {
        let reflection = Mirror(reflecting: self)
        var states: [ViewStateBindable] = []
        var currentReflection: Mirror? = reflection
        repeat {
            guard let current: Mirror = currentReflection else {
                break
            }
            extractStateBindables(from: current, into: &states)
            currentReflection = current.superclassMirror
        } while currentReflection != nil
        return states
    }
    
    private func extractObservables(from mirror: Mirror, into states: inout [StateObservable]) {
        for child in mirror.children {
            if let stateObservable = child.value as? StateObservable {
                states.append(stateObservable)
            } else if let model = child.value as? StatedViewModel {
                states.append(contentsOf: model.observables)
            }
        }
    }
    
    public var observables: [StateObservable] {
        let reflection = Mirror(reflecting: self)
        var states: [StateObservable] = []
        var currentReflection: Mirror? = reflection
        repeat {
            guard let current: Mirror = currentReflection else {
                break
            }
            extractObservables(from: current, into: &states)
            currentReflection = current.superclassMirror
        } while currentReflection != nil
        return states
    }
    
}

@objc class AssociatedWrapper: NSObject {
    var wrapped: AnyObject
    
    init(wrapped: AnyObject) {
        self.wrapped = wrapped
    }
}

open class ViewModel<View: NSObject>: NSObject, BindableViewModel {
    weak public private(set) var view: View?
    required public override init() {
        super.init()
    }
    
    deinit {
        unbind()
    }
    
    final public func apply(to view: View) {
        willApplying(view)
        let states = bindableStates
        states.forEach {
            var state = $0
            state.bindingState = .applying
        }
        bind(with: view)
        observables.forEach {
            $0.invokeWithCurrentValue()
        }
        states.forEach {
            var state = $0
            state.bindingState = .none
        }
        didApplying(view)
    }
    
    final public func map(from view: View) {
        modelWillMapped(from: view)
        let states = bindableStates
        states.forEach {
            var state = $0
            state.bindingState = .mapping
        }
        bind(with: view)
        states.forEach {
            var state = $0
            state.bindingState = .none
        }
        modelDidMapped(from: view)
    }
    
    open func willApplying(_ view: View) { }
    
    open func didApplying(_ view: View) { }
    
    open func modelWillMapped(from view: View) { }
    
    open func modelDidMapped(from view: View) { }
    
    open func willUnbind(with view: View?) { }
    
    open func didUnbind(with view: View?) { }
    
    open func bind(with view: View) {
        let modelWrapper = AssociatedWrapper(wrapped: self)
        objc_setAssociatedObject(view,  &NSObject.AssociatedKey.model, modelWrapper, .OBJC_ASSOCIATION_RETAIN)
        self.view = view
    }
    
    final func unbind() {
        let currentView = self.view
        willUnbind(with: currentView)
        if let view = self.view {
            objc_setAssociatedObject(view,  &NSObject.AssociatedKey.model, nil, .OBJC_ASSOCIATION_RETAIN)
            self.view = nil
        }
        observables.forEach {
            $0.removeAllObservers()
        }
        bindableStates.forEach {
            $0.unbind()
        }
        didUnbind(with: currentView)
    }
}

public extension UIView {
    
    func apply<VM: BindableViewModel>(model: VM) {
        guard let selfAsView = self as? VM.View else {
            return
        }
        model.apply(to: selfAsView)
    }
    
    func map<VM: BindableViewModel>(to model: VM) {
        guard let selfAsView = self as? VM.View else {
            return
        }
        model.map(from: selfAsView)
    }
    
    func bind<VM: BindableViewModel>(to model: VM) {
        guard let selfAsView = self as? VM.View else {
            return
        }
        model.bind(with: selfAsView)
    }
}
