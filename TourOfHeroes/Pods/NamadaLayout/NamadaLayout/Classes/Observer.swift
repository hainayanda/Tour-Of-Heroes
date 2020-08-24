//
//  Observer.swift
//  NamadaLayout
//
//  Created by Nayanda Haberty (ID) on 18/08/20.
//

import Foundation
import UIKit

protocol AnyViewBinder {
    func signalViewListener(from view: UIView, with newValue: Any, old oldValue: Any)
    func signalStateListener(with newValue: Any, old oldValue: Any)
    func signalApplicator(with newValue: Any)
}

public class PartialBinder<View: UIView, State>: AnyViewBinder {
    var viewListener: ((View, Changes<State>) -> Void)?
    weak var view: View?
    
    init(view: View) {
        self.view = view
    }
    
    @discardableResult
    public func viewDidSet(then: @escaping (View, Changes<State>) -> Void) -> Self {
        viewListener = then
        return self
    }
    
    func signalViewListener(from view: UIView, with newValue: Any, old oldValue: Any) {
        guard let view = self.view, let new = newValue as? State, let old = oldValue as? State else { return }
        viewListener?(view, .init(new: new, old: old, trigger: .view(view)))
    }
    
    func signalStateListener(with newValue: Any, old oldValue: Any) { }
    
    func signalApplicator(with newValue: Any) { }
}

public class CompleteBinder<View: UIView, State>: PartialBinder<View, State> {
    var stateListener: ((View, Changes<State>) -> Void)?
    var applicator: ((View, State) -> Void)?
    
    @discardableResult
    public func stateDidSet(then: @escaping (View, Changes<State>) -> Void) -> Self {
        stateListener = then
        return self
    }
    
    @discardableResult
    public override func viewDidSet(then: @escaping (View, Changes<State>) -> Void) -> Self {
        super.viewDidSet(then: then)
        return self
    }
    
    override func signalStateListener(with newValue: Any, old oldValue: Any) {
        guard let view = self.view, let new = newValue as? State, let old = oldValue as? State else { return }
        stateListener?(view, .init(new: new, old: old, trigger: .state))
    }
    
    override func signalApplicator(with newValue: Any) {
        guard let view = self.view, let new = newValue as? State else { return }
        applicator?(view, new)
    }
}

public struct Changes<Change> {
    public var new: Change
    public var old: Change
    public var trigger: Trigger
    
    public enum Trigger: Equatable {
        case view(UIView)
        case state
        case bind
        case invoked
        
        public var triggeringView: UIView? {
            switch self {
            case .view(let view):
                return view
            default:
                return nil
            }
        }
    }
}

@propertyWrapper
struct Atomic<Wrapped> {
    
    private var value: Wrapped
    private let lock = NSLock()
    
    init(wrappedValue value: Wrapped) {
        self.value = value
    }
    
    var wrappedValue: Wrapped {
        get { return load() }
        set { store(newValue: newValue) }
    }
    
    func load() -> Wrapped {
        lock.lock()
        defer { lock.unlock() }
        return value
    }
    
    mutating func store(newValue: Wrapped) {
        lock.lock()
        defer { lock.unlock() }
        value = newValue
    }
}

public class WrappedPropertyObserver<Wrapped> {
    typealias SetListener = (Changes<Wrapped>) -> Void
    typealias GetListener = (Wrapped) -> Void
    var willSetListener: ((Changes<Wrapped>) -> Void)?
    var didSetListener: ((Changes<Wrapped>) -> Void)?
    var willGetListener: ((Wrapped) -> Void)?
    var didGetListener: ((Wrapped) -> Void)?
    
    var dispatcher: DispatchQueue = .main
    
    @Atomic var throttle: TimeInterval = 0
    @Atomic var delay: TimeInterval = 0
    @Atomic var latestChangesTriggered: Date = .distantPast
    @Atomic var latestChanges: Changes<Wrapped>?
    @Atomic var onDelayed: Bool = false
    
    func triggerDidSet(with changes: Changes<Wrapped>) {
        self.latestChanges = changes
        guard !self.onDelayed else { return }
        let intervalFromLatestTrigger = -(latestChangesTriggered.timeIntervalSinceNow)
        guard intervalFromLatestTrigger > delay else {
            onDelayed = true
            let nextTrigger = delay - intervalFromLatestTrigger
            dispatcher.asyncAfter(deadline: .now() + nextTrigger) { [weak self] in
                guard let self = self, let changes = self.latestChanges else { return }
                self.onDelayed = false
                self.triggerDidSet(with: changes)
            }
            return
        }
        dispatcher.asyncAfter(deadline: .now() + throttle) { [weak self] in
            guard let self = self, let changes = self.latestChanges else { return }
            self.latestChanges = nil
            self.didSetListener?(changes)
            self.latestChangesTriggered = Date()
        }
    }
}

public class PropertyObservers<Observer: AnyObject, Wrapped>: WrappedPropertyObserver<Wrapped> {
    typealias ObservedSetListener = (Observer, Changes<Wrapped>) -> Void
    typealias ObservedGetListener = (Observer, Wrapped) -> Void
    weak var observer: Observer?
    
    init(obsever: Observer) {
        self.observer = obsever
    }
    
    @discardableResult
    public func delayMultipleSetTrigger(by delay: TimeInterval) -> Self {
        self.delay = delay
        return self
    }
    
    @discardableResult
    public func throttle(by delay: TimeInterval) -> Self {
        self.throttle = delay
        return self
    }
    
    @discardableResult
    public func willSet(then: @escaping (Observer, Changes<Wrapped>) -> Void) -> Self {
        willSetListener = asListener(closure: then)
        return self
    }
    
    @discardableResult
    public func didSet(runIn dispatcher: DispatchQueue = .main, then: @escaping (Observer, Changes<Wrapped>) -> Void) -> Self {
        self.dispatcher = dispatcher
        didSetListener = asListener(closure: then)
        return self
    }
    
    @discardableResult
    public func didGet(then: @escaping (Observer, Wrapped) -> Void) -> Self {
        didGetListener = asListener(closure: then)
        return self
    }
    
    @discardableResult
    public func willGet(then: @escaping (Observer, Wrapped) -> Void) -> Self {
        willGetListener = asListener(closure: then)
        return self
    }
    
    func asListener(closure: @escaping ObservedSetListener) -> SetListener {
        return { [weak self] changes in
            guard let observer = self?.observer else { return }
            closure(observer, changes)
        }
    }
    
    func asListener(closure: @escaping ObservedGetListener) -> GetListener {
        return { [weak self] value in
            guard let observer = self?.observer else { return }
            closure(observer, value)
        }
    }
}
