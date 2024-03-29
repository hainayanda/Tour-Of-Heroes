//
//  Observer.swift
//  NamadaLayout
//
//  Created by Nayanda Haberty (ID) on 18/08/20.
//

import Foundation
import UIKit

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

public extension Changes where Change: Equatable {
    var isChanging: Bool { new != old }
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
    
    var mainHandler: ParallelOperationHandler = MainOperationHandler()
    
    @Atomic var delay: TimeInterval = 0
    @Atomic var latestChangesTriggered: Date = .distantPast
    @Atomic var latestChanges: Changes<Wrapped>?
    @Atomic var onDelayed: Bool = false
    
    func triggerDidSet(with changes: Changes<Wrapped>) {
        if let latest = self.latestChanges {
            self.latestChanges = .init(new: changes.new, old: latest.old, trigger: changes.trigger)
        } else {
            self.latestChanges = changes
        }
        let intervalFromLatestTrigger = -(latestChangesTriggered.timeIntervalSinceNow)
        guard intervalFromLatestTrigger > delay else {
            let nextTrigger = delay - intervalFromLatestTrigger
            DispatchQueue.main.asyncAfter(deadline: .now() + nextTrigger) { [weak self] in
                guard let self = self, let changes = self.latestChanges else { return }
                self.triggerDidSet(with: changes)
            }
            return
        }
        mainHandler.addOperation { [weak self] in
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
    public func willSet(then: @escaping (Observer, Changes<Wrapped>) -> Void) -> Self {
        willSetListener = asListener(closure: then)
        return self
    }
    
    @discardableResult
    public func didSet(then: @escaping (Observer, Changes<Wrapped>) -> Void) -> Self {
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

public extension PropertyObservers where Wrapped: Equatable {
    
    @discardableResult
    func didUniqueSet(then: @escaping (Observer, Changes<Wrapped>) -> Void) -> Self {
        didSetListener = { [weak self] value in
            guard let observer = self?.observer, value.isChanging else { return }
            then(observer, value)
        }
        return self
    }
    
    @discardableResult
    func willUniqueSet(then: @escaping (Observer, Changes<Wrapped>) -> Void) -> Self {
        willSetListener = { [weak self] value in
            guard let observer = self?.observer, value.isChanging else { return }
            then(observer, value)
        }
        return self
    }
}
