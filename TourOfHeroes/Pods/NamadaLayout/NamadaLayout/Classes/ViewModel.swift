//
//  ViewModel.swift
//  FBSnapshotTestCase
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
}

@objc class AssociatedWrapper: NSObject {
    var wrapped: Any
    
    init(wrapped: Any) {
        self.wrapped = wrapped
    }
}

open class ViewModel<View: NSObject>: NSObject, BindableViewModel {
    required public override init() {
        super.init()
    }
    
    final public func apply(to view: View) {
        willApplying(view)
        let states = bindableStates
        states.forEach {
            var state = $0
            state.bindingState = .applying
        }
        bind(with: view)
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
    
    open func willUnbind() { }
    
    open func didUnbind() { }
    
    open func bind(with view: View) {
        let oldModel: ViewModel<View>? = view.bindedModel()
        oldModel?.unbind()
        let modelWrapper = AssociatedWrapper(wrapped: self)
        objc_setAssociatedObject(view,  &NSObject.AssociatedKey.model, modelWrapper, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    final func unbind() {
        willUnbind()
        bindableStates.forEach {
            $0.unbind()
        }
        didUnbind()
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
