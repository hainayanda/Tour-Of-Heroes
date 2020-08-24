//
//  StackedLayout.swift
//  FBSnapshotTestCase
//
//  Created by Nayanda Haberty (ID) on 13/08/20.
//

import Foundation
import UIKit

public class StackedLayout: ViewLayout {
    private var stackedStrategy: LayoutStackedStrategy = .replaceDifferences
    private var newStack: [UIView] = []
    private var currentStack: [UIView] { stack.arrangedSubviews }
    public var stack: UIStackView { view as! UIStackView }
    private var currentStackIndex: Int { newStack.count }
    
    public init<View>(context: LayoutContext, stack: View, stackedStrategy: LayoutStackedStrategy = .replaceDifferences, parentLayout: ViewLayout?) where View : UIStackView {
        self.stackedStrategy = stackedStrategy
        switch stackedStrategy {
        case .emptying:
            let currentStack = stack.arrangedSubviews
            currentStack.forEach { view in
                stack.removeArrangedSubview(view)
            }
        default:
            break
        }
        super.init(context: context, view: stack, parentLayout: parentLayout)
    }
    
    public func applyStack() {
        guard stackedStrategy == .replaceDifferences else { return }
        let currentStack = self.currentStack
        for (index, view) in currentStack.enumerated() where index >= newStack.count {
            stack.removeArrangedSubview(view)
        }
    }
    
    @available(iOS 11.0, *)
    public func put(spacing: CGFloat) {
        guard let lastView = newStack.last else { return }
        self.stack.setCustomSpacing(spacing, after: lastView)
    }
    
    @discardableResult
    public func putStacked<V: UIView>(_ view: V, _ builder: (ViewLayout) -> Void = { _ in }) -> ViewApplicator<V> {
        addArrange(subView: view)
        let subViewLayout = ViewLayout(context: context, view: view, parentLayout: self)
        builder(subViewLayout)
        if let molecule = view as? MoleculeLayout {
            molecule.layoutChild(subViewLayout)
        }
        subLayouts.append(subViewLayout)
        return .init(view: view)
    }
    
    @discardableResult
    public override func put<V: UIView>(_ view: V, _ builder: (ViewLayout) -> Void = { _ in }) -> ViewApplicator<V> {
        super.put(view, builder)
    }
    
    @discardableResult
    public override func put(_ viewController: UIViewController, _ builder: (ViewLayout) -> Void = { _ in }) -> ViewApplicator<UIView> {
        super.put(viewController, builder)
    }
    
    @discardableResult
    public func putStacked(stack: UIStackView, stackedStrategy: LayoutStackedStrategy = .replaceDifferences, _ builder: (StackedLayout) -> Void = { _ in }) -> ViewApplicator<UIStackView> {
        addArrange(subView: view)
        let subViewLayout = StackedLayout(context: context, stack: stack, stackedStrategy: stackedStrategy, parentLayout: self)
        builder(subViewLayout)
        if let molecule = view as? MoleculeLayout {
            molecule.layoutChild(subViewLayout)
        }
        subViewLayout.applyStack()
        subLayouts.append(subViewLayout)
        return .init(view: stack)
    }
    
    @discardableResult
    public func putStacked(_ viewController: UIViewController, _ builder: (ViewLayout) -> Void = { _ in }) -> ViewApplicator<UIView> {
        ifHaveViewController { thisVC in
            thisVC.addChild(viewController)
            addArrange(subView: viewController.view)
            let subViewLayout = ViewLayout(context: context, view: viewController.view, parentLayout: self)
            context.currentViewController = viewController
            builder(subViewLayout)
            if let molecule = view as? MoleculeLayout {
                molecule.layoutChild(subViewLayout)
            }
            subLayouts.append(subViewLayout)
            context.currentViewController = thisVC
        }
        return .init(view: viewController.view)
    }
    
    private func addArrange<V: UIView>(subView view: V) {
        view.translatesAutoresizingMaskIntoConstraints = false
        switch self.stackedStrategy {
        case .replaceDifferences:
            guard let currentView = currentStack[safe: currentStackIndex] else {
                self.stack.addArrangedSubview(view)
                newStack.append(view)
                return
            }
            guard currentView != view else {
                return
            }
            self.stack.removeArrangedSubview(currentView)
            self.stack.insertArrangedSubview(view, at: self.currentStackIndex)
            newStack.append(view)
        default:
            self.stack.addArrangedSubview(view)
            newStack.append(view)
        }
    }
}

extension StackedLayout {
    
    private func stackedView<V: UIView>(with restorationId: String?, ifNotPresent createView: @autoclosure () -> V) -> V {
        let viewForPut: V
        if let id = restorationId {
            viewForPut = stack.arrangedSubviews.first {
                $0.restorationIdentifier == id
                } as? V ?? createView()
        } else {
            viewForPut = createView()
        }
        return viewForPut
    }
    
    @discardableResult
    public func putStackedView(restorationId: String? = nil, _ builder: (ViewLayout) -> Void) -> ViewApplicator<UIView> {
        putStacked(stackedView(with: restorationId, ifNotPresent: UIView()), builder)
    }
    
    @discardableResult
    public func putStackedLabel(restorationId: String? = nil, _ builder: (ViewLayout) -> Void) -> ViewApplicator<UILabel> {
        putStacked(stackedView(with: restorationId, ifNotPresent: UILabel()), builder)
    }
    
    @discardableResult
    public func putStackedButton(restorationId: String? = nil, _ builder: (ViewLayout) -> Void) -> ViewApplicator<UIButton> {
        putStacked(stackedView(with: restorationId, ifNotPresent: UIButton()), builder)
    }
    
    @discardableResult
    public func putStackedImage(restorationId: String? = nil, _ builder: (ViewLayout) -> Void) -> ViewApplicator<UIImageView> {
        putStacked(stackedView(with: restorationId, ifNotPresent: UIImageView()), builder)
    }
    
    @discardableResult
    public func putStackedTextField(restorationId: String? = nil, _ builder: (ViewLayout) -> Void) -> ViewApplicator<UITextField> {
        putStacked(stackedView(with: restorationId, ifNotPresent: UITextField()), builder)
    }
    
    @discardableResult
    public func putStackedTextView(restorationId: String? = nil, _ builder: (ViewLayout) -> Void) -> ViewApplicator<UITextView> {
        putStacked(stackedView(with: restorationId, ifNotPresent: UITextView()), builder)
    }
    
    @discardableResult
    public func putStackedSlider(restorationId: String? = nil, _ builder: (ViewLayout) -> Void) -> ViewApplicator<UISlider> {
        putStacked(stackedView(with: restorationId, ifNotPresent: UISlider()), builder)
    }
    
    @discardableResult
    public func putStackedSwitch(restorationId: String? = nil, _ builder: (ViewLayout) -> Void) -> ViewApplicator<UISwitch> {
        putStacked(stackedView(with: restorationId, ifNotPresent: UISwitch()), builder)
    }
    
    @discardableResult
    public func putStackedSegment(restorationId: String? = nil, _ builder: (ViewLayout) -> Void) -> ViewApplicator<UISegmentedControl> {
        putStacked(stackedView(with: restorationId, ifNotPresent: UISegmentedControl()), builder)
    }
    
    @discardableResult
    public func putStackedPageControl(restorationId: String? = nil, _ builder: (ViewLayout) -> Void) -> ViewApplicator<UIPageControl> {
        putStacked(stackedView(with: restorationId, ifNotPresent: UIPageControl()), builder)
    }
    
    @discardableResult
    public func putStackedProgress(restorationId: String? = nil, _ builder: (ViewLayout) -> Void) -> ViewApplicator<UIProgressView> {
        putStacked(stackedView(with: restorationId, ifNotPresent: UIProgressView()), builder)
    }
    
    @discardableResult
    public func putStackedSearchBar(restorationId: String? = nil, _ builder: (ViewLayout) -> Void) -> ViewApplicator<UISearchBar> {
        putStacked(stackedView(with: restorationId, ifNotPresent: UISearchBar()), builder)
    }
    
    @discardableResult
    public func putStackedScroll(restorationId: String? = nil, _ builder: (ViewLayout) -> Void) -> ViewApplicator<UIScrollView> {
        putStacked(stackedView(with: restorationId, ifNotPresent: UIScrollView()), builder)
    }
    
    @discardableResult
    public func putStackedActivityIndicator(restorationId: String? = nil, _ builder: (ViewLayout) -> Void) -> ViewApplicator<UIActivityIndicatorView> {
        putStacked(stackedView(with: restorationId, ifNotPresent: UIActivityIndicatorView()), builder)
    }
    
    @discardableResult
    public func putStackedPickerView(restorationId: String? = nil, _ builder: (ViewLayout) -> Void) -> ViewApplicator<UIPickerView> {
        putStacked(stackedView(with: restorationId, ifNotPresent: UIPickerView()), builder)
    }
    
    @discardableResult
    public func putStackedDatePicker(restorationId: String? = nil, _ builder: (ViewLayout) -> Void) -> ViewApplicator<UIDatePicker> {
        putStacked(stackedView(with: restorationId, ifNotPresent: UIDatePicker()), builder)
    }
    
    @discardableResult
    public func putStackedStepper(restorationId: String? = nil, _ builder: (ViewLayout) -> Void) -> ViewApplicator<UIStepper> {
        putStacked(stackedView(with: restorationId, ifNotPresent: UIStepper()), builder)
    }
    
    @available(iOS 13.0, *)
    @discardableResult
    public func putStackedSearchTextField(restorationId: String? = nil, _ builder: (ViewLayout) -> Void) -> ViewApplicator<UISearchTextField> {
        putStacked(stackedView(with: restorationId, ifNotPresent: UISearchTextField()), builder)
    }
    
    @discardableResult
    public func putStackedVisualEffect(restorationId: String? = nil, _ builder: (ViewLayout) -> Void) -> ViewApplicator<UIVisualEffectView> {
        putStacked(stackedView(with: restorationId, ifNotPresent: UIVisualEffectView()), builder)
    }
    
    @discardableResult
    public func putStackedNavigationBar(restorationId: String? = nil, _ builder: (ViewLayout) -> Void) -> ViewApplicator<UINavigationBar> {
        putStacked(stackedView(with: restorationId, ifNotPresent: UINavigationBar()), builder)
    }
    
    @discardableResult
    public func putStackedTabbar(restorationId: String? = nil, _ builder: (ViewLayout) -> Void) -> ViewApplicator<UITabBar> {
        putStacked(stackedView(with: restorationId, ifNotPresent: UITabBar()), builder)
    }
    
    @discardableResult
    public func putStackedTable(restorationId: String? = nil, _ builder: (ViewLayout) -> Void) -> ViewApplicator<UITableView> {
        putStacked(stackedView(with: restorationId, ifNotPresent: UITableView()), builder)
    }
    
    @discardableResult
    public func putStackedCollection(with layout: UICollectionViewLayout, restorationId: String? = nil, _ builder: (ViewLayout) -> Void) -> ViewApplicator<UICollectionView> {
        putStacked(stackedView(with: restorationId, ifNotPresent: UICollectionView(frame: .zero, collectionViewLayout: layout)), builder)
    }
    
    @discardableResult
    public func putStackedVerticalStack(restorationId: String? = nil, _ builder: (StackedLayout) -> Void) -> ViewApplicator<UIStackView> {
        let stack = stackedView(with: restorationId, ifNotPresent: UIStackView())
        stack.axis = .vertical
        return putStacked(stack: stack, stackedStrategy: .append, builder)
    }
    
    @discardableResult
    public func putStackedHorizontalStack(restorationId: String? = nil, _ builder: (StackedLayout) -> Void) -> ViewApplicator<UIStackView> {
        let stack = stackedView(with: restorationId, ifNotPresent: UIStackView())
        stack.axis = .horizontal
        return putStacked(stack: stack, stackedStrategy: .append, builder)
    }
    
}
