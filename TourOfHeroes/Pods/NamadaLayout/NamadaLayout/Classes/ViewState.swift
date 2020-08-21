//
//  ViewState.swift
//  FBSnapshotTestCase
//
//  Created by Nayanda Haberty (ID) on 10/08/20.
//

import Foundation
import UIKit

@propertyWrapper
open class ViewState<Wrapped>: ViewStateBindable {
    public var bindingState: BindingState = .none
    private var binder: AnyViewBinder?
    private var observers: [WrappedPropertyObserver<Wrapped>] = []
    var token: NSObjectProtocol?
    var _wrappedValue: Wrapped
    public var wrappedValue: Wrapped {
        get {
            getAndObserve(value: _wrappedValue)
        }
        set {
            let oldValue = _wrappedValue
            observedSet(value: newValue, from: .state)
            binder?.signalApplicator(with: newValue)
            binder?.signalStateListener(with: newValue, old: oldValue)
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
            observer.didSetListener?(changes)
        }
    }
    
    public var projectedValue: ViewState<Wrapped> { self }
    
    public init(wrappedValue: Wrapped) {
        self._wrappedValue = wrappedValue
    }
    
    deinit {
        reset()
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
    
    @discardableResult
    public func oneWayBind<View: UIView>(
        with view: View,
        _ keyPath: KeyPath<View, Wrapped>) -> PartialBinder<View, Wrapped> {
        unbind()
        observedSet(value: view[keyPath: keyPath], from: .bind)
        observe(view: view, keyPath)
        let binder: PartialBinder<View, Wrapped> = .init(view: view)
        self.binder = binder
        return binder
    }
    
    @discardableResult
    public func apply<View: UIView>(
        into view: View,
        _ keyPath: ReferenceWritableKeyPath<View, Wrapped>) -> CompleteBinder<View, Wrapped> {
        bind(with: view, keyPath, state: .applying)
    }
    
    @discardableResult
    public func map<View: UIView>(
        from view: View,
        _ keyPath: ReferenceWritableKeyPath<View, Wrapped>) -> CompleteBinder<View, Wrapped> {
        bind(with: view, keyPath, state: .mapping)
    }
    
    @discardableResult
    public func bind<View: UIView>(
        with view: View,
        _ keyPath: ReferenceWritableKeyPath<View, Wrapped>,
        state: BindingState? = nil) -> CompleteBinder<View, Wrapped> {
        unbind()
        let bindingState = state ?? self.bindingState
        switch bindingState {
        case .mapping:
            observedSet(value: view[keyPath: keyPath], from: .bind)
        case .applying:
            view[keyPath: keyPath] = wrappedValue
        case .none:
            break
        }
        observe(view: view, keyPath)
        let binder: CompleteBinder<View, Wrapped> = .init(view: view)
        self.binder = binder
        binder.applicator = { view, newValue in
            view[keyPath: keyPath] = newValue
        }
        binder.view = view
        return binder
    }
    
    public func reset() {
        unbind()
        removeAllObservers()
    }
    
    public func unbind() {
        if let token = self.token {
            NotificationCenter.default.removeObserver(token)
            self.token = nil
        }
        binder = nil
    }
    
    public func removeAllObservers() {
        observers.removeAll()
    }
    
    @objc public func onTextInput(_ sender: Notification) {
        guard let view = sender.object as? UIView,
            let textInput = view as? UITextInput,
            let textRange = textInput.textRange(from: textInput.beginningOfDocument, to: textInput.endOfDocument),
            let newValue = textInput.text(in: textRange) as? Wrapped else { return }
        let oldValue = _wrappedValue
        observedSet(value: newValue, from: .view(view))
        binder?.signalViewListener(from: view, with: newValue, old: oldValue)
    }
    
    func observe<View: UIView>(view: View, _ keyPath: KeyPath<View, Wrapped>) {
        if let field = view as? UITextInput, NSExpression(forKeyPath: keyPath).keyPath == "text" {
            self.token = addTextInputObserver(for: view, field)
        } else if let searchBar = view as? UISearchBar, NSExpression(forKeyPath: keyPath).keyPath == "text" {
            self.token = addTextInputObserver(for: searchBar, searchBar.textField)
        } else {
            self.token = view.observe(keyPath, options: [.new, .old, .prior]) { [weak self] view, changes in
                guard let self = self,
                    let newValue = changes.newValue,
                    let oldValue = changes.oldValue else { return }
                let trigger: Changes<Wrapped>.Trigger = .view(view)
                if changes.isPrior {
                    self.observedWillSet(value: newValue, from: trigger)
                } else {
                    self.setAndObserve(value: newValue, from: trigger)
                    self.binder?.signalViewListener(from: view, with: newValue, old: oldValue)
                }
            }
        }
    }
    
    func addTextInputObserver<View: UIView>(for view: View, _ field: UITextInput) -> NSObjectProtocol {
        let notificationName: NSNotification.Name = field as? UITextView != nil
            ? UITextView.textDidChangeNotification : UITextField.textDidChangeNotification
        return NotificationCenter.default
            .addObserver(forName: notificationName, object: field, queue: nil) { [weak self, weak view = view, weak field = field] _ in
                guard let self = self,
                    let view = view,
                    let field = field else { return }
                let oldValue = self._wrappedValue
                if let textRange = field.textRange(from: field.beginningOfDocument, to: field.endOfDocument),
                    let newValue = field.text(in: textRange) as? Wrapped {
                    self.observedSet(value: newValue, from: .view(view))
                    self.binder?.signalViewListener(from: view, with: newValue, old: oldValue)
                } else if let newValue: Wrapped = Optional<String>(nilLiteral: ()) as? Wrapped {
                    self.observedSet(value: newValue, from: .view(view))
                    self.binder?.signalViewListener(from: view, with: newValue, old: oldValue)
                }
        }
    }
}

@propertyWrapper
public class WeakViewState<Wrapped: AnyObject>: ViewState<Wrapped?> {
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
    public override var projectedValue: ViewState<Wrapped?> { self }
    
    public override init(wrappedValue: Wrapped?) {
        super.init(wrappedValue: wrappedValue)
    }
    
    public override func observe<Observer: AnyObject>(observer: Observer) -> PropertyObservers<Observer, Wrapped?> {
        super.observe(observer: observer)
    }
    
    public override func remove<Observer>(observer: Observer) where Observer : AnyObject {
        super.remove(observer: observer)
    }
    
    @discardableResult
    public override func oneWayBind<View: UIView>(
        with view: View,
        _ keyPath: KeyPath<View, Wrapped?>) -> PartialBinder<View, Wrapped?> {
        super.oneWayBind(with: view, keyPath)
    }
    
    @discardableResult
    public override func apply<View: UIView>(
        into view: View,
        _ keyPath: ReferenceWritableKeyPath<View, Wrapped?>) -> CompleteBinder<View, Wrapped?> {
        super.apply(into: view, keyPath)
    }
    
    @discardableResult
    public override func map<View: UIView>(
        from view: View,
        _ keyPath: ReferenceWritableKeyPath<View, Wrapped?>) -> CompleteBinder<View, Wrapped?> {
        super.map(from: view, keyPath)
    }
    
    @discardableResult
    public override func bind<View: UIView>(
        with view: View,
        _ keyPath: ReferenceWritableKeyPath<View, Wrapped?>,
        state: BindingState? = nil) -> CompleteBinder<View, Wrapped?> {
        super.bind(with: view, keyPath, state: state)
    }
    
    public override func reset() {
        super.reset()
    }
    
    public override func unbind() {
        super.unbind()
    }
    
    public override func removeAllObservers() {
        super.removeAllObservers()
    }
}
