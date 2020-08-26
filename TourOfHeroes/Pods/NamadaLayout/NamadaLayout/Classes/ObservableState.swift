//
//  ObservableState.swift
//  NamadaLayout
//
//  Created by Nayanda Haberty (ID) on 23/08/20.
//

import Foundation

public protocol StateObservable {
    func invokeWithCurrentValue()
    func remove<Observer: AnyObject>(observer: Observer)
    func removeAllObservers()
}

@propertyWrapper
open class ObservableState<Wrapped>: StateObservable {
    private var observers: [WrappedPropertyObserver<Wrapped>] = []
    var _wrappedValue: Wrapped
    public var wrappedValue: Wrapped {
        get {
            getAndObserve(value: _wrappedValue)
        }
        set {
            observedSet(value: newValue, from: .state)
        }
    }
    
    func getAndObserve(value: Wrapped) -> Wrapped {
        observers.forEach { observer in
            observer.willGetListener?(_wrappedValue)
        }
        defer {
            observers.forEach { observer in
                observer.didGetListener?(_wrappedValue)
            }
        }
        return _wrappedValue
    }
    
    func observedSet(value: Wrapped, from: Changes<Wrapped>.Trigger) {
        observedWillSet(value: value, from: from)
        setAndObserve(value: value, from: from)
    }
    
    func observedWillSet(value: Wrapped, from: Changes<Wrapped>.Trigger) {
        let oldValue = _wrappedValue
        var changes = Changes(new: value, old: oldValue, trigger: from)
        changes = Changes(new: value, old: oldValue, trigger: from)
        observers.forEach { observer in
            observer.willSetListener?(changes)
        }
    }
    
    func setAndObserve(value: Wrapped, from: Changes<Wrapped>.Trigger) {
        let oldValue = _wrappedValue
        _wrappedValue = value
        var changes = Changes(new: value, old: oldValue, trigger: from)
        changes = Changes(new: value, old: oldValue, trigger: from)
        observers.forEach { observer in
            observer.triggerDidSet(with: changes)
        }
    }
    
    public var projectedValue: ObservableState<Wrapped> { self }
    
    public init(wrappedValue: Wrapped) {
        self._wrappedValue = wrappedValue
    }
    
    public func observe<Observer: AnyObject>(observer: Observer) -> PropertyObservers<Observer, Wrapped> {
        remove(observer: observer)
        let newObserver = PropertyObservers<Observer, Wrapped>(obsever: observer)
        self.observers.append(newObserver)
        return newObserver
    }
    
    public func remove<Observer: AnyObject>(observer: Observer) {
        self.observers.removeAll { ($0 as? PropertyObservers<Observer, Wrapped>)?.observer === observer }
    }
    
    public func removeAllObservers() {
        observers.removeAll()
    }
    
    public func invokeWithCurrentValue() {
        observers.forEach { observer in
            let changes: Changes = .init(new: _wrappedValue, old: _wrappedValue, trigger: .invoked)
            observer.triggerDidSet(with: changes)
        }
    }
}

@propertyWrapper
public class WeakObservableState<Wrapped: AnyObject>: ObservableState<Wrapped?> {
    weak var _weakWrappedValue: Wrapped?
    override var _wrappedValue: Wrapped? {
        get {
            _weakWrappedValue
        }
        set {
            _weakWrappedValue = newValue
        }
    }
    public override var wrappedValue: Wrapped? {
        get {
            super.wrappedValue
        }
        set {
            super.wrappedValue = newValue
        }
    }
    public override var projectedValue: ObservableState<Wrapped?> { self }
    
    public override init(wrappedValue: Wrapped?) {
        super.init(wrappedValue: wrappedValue)
    }
    
    public override func observe<Observer: AnyObject>(observer: Observer) -> PropertyObservers<Observer, Wrapped?> {
        super.observe(observer: observer)
    }
    
    public override func remove<Observer>(observer: Observer) where Observer : AnyObject {
        super.remove(observer: observer)
    }
    
    public override func removeAllObservers() {
        super.removeAllObservers()
    }
}
