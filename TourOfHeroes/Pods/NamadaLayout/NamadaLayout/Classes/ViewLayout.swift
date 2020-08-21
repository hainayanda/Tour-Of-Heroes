//
//  ViewLayout.swift
//  NamadaLayout
//
//  Created by Nayanda Haberty (ID) on 05/07/20.
//

import Foundation
import UIKit

open class ViewLayout: ViewLayoutable {
    
    public typealias LayoutProtocolType = ViewLayout
    
    public private(set) weak var parentLayout: ViewLayout?
    public let view: UIView
    public internal(set) var subLayouts: [ViewLayout] = []
    public let identifier: String
    public let context: LayoutContext
    
    public let safeArea: AreaLayout
    public let top: EdgeLayout<NSLayoutYAxisAnchor>
    public let bottom: EdgeLayout<NSLayoutYAxisAnchor>
    public let left: EdgeLayout<NSLayoutXAxisAnchor>
    public let right: EdgeLayout<NSLayoutXAxisAnchor>
    public let center: CenterAnchorLayout
    public let width: DimensionLayout
    public let height: DimensionLayout
    
    init<View: UIView>(context: LayoutContext, view: View, parentLayout: ViewLayout?) {
        self.context = context
        self.view = view
        self.parentLayout = parentLayout
        self.identifier = "namada_\(View.self)\(view.accessibilityIdentifier ?? "")\(view.uniqueKey)"
        self.safeArea = .init(
            context: context,
            view: view,
            parentLayout: parentLayout
        )
        self.top = .init(
            context: context,
            anchor: view.topAnchor,
            identifier: "\(identifier)_top",
            parentRelated: parentLayout?.top,
            parentSafeEdge: parentLayout?.safeArea.top
        )
        self.left = .init(
            context: context,
            anchor: view.leftAnchor,
            identifier: "\(identifier)_left",
            parentRelated: parentLayout?.left,
            parentSafeEdge: parentLayout?.safeArea.left
        )
        self.right = .init(
            context: context,
            anchor: view.rightAnchor,
            multiplier: .negative,
            identifier: "\(identifier)_right",
            parentRelated: parentLayout?.right,
            parentSafeEdge: parentLayout?.safeArea.right
        )
        self.bottom = .init(
            context: context,
            anchor: view.bottomAnchor,
            multiplier: .negative,
            identifier: "\(identifier)_bottom",
            parentRelated: parentLayout?.bottom,
            parentSafeEdge: parentLayout?.safeArea.bottom
        )
        self.center = .init(
            context: context,
            xAxis: .init(
                context: context,
                anchor: view.centerXAnchor,
                identifier: "\(identifier)_centerX",
                parentRelated: parentLayout?.center.xAxis
            ),
            yAxis: .init(
                context: context,
                anchor: view.centerYAnchor,
                identifier: "\(identifier)_centerY",
                parentRelated: parentLayout?.center.yAxis
            ),
            identifier: "\(identifier)_center",
            parentRelated: parentLayout?.center
        )
        self.width = .init(
            context: context,
            layoutDimension: view.widthAnchor,
            identifier: "\(view.hashValue)_width",
            parentRelated: parentLayout?.width
        )
        self.height = .init(
            context: context,
            layoutDimension: view.heightAnchor,
            identifier: "\(view.hashValue)_height",
            parentRelated: parentLayout?.height
        )
    }
    
    func add(subView: UIView) {
        subView.translatesAutoresizingMaskIntoConstraints = false
        guard let parent = subView.superview else {
            self.view.addSubview(subView)
            return
        }
        guard parent != self.view else { return }
        self.view.addSubview(subView)
    }
    
    @discardableResult
    public func put<V: UIView>(_ view: V, _ builder: (ViewLayout) -> Void = { _ in }) -> ViewApplicator<V> {
        add(subView: view)
        let subViewLayout = ViewLayout(context: context, view: view, parentLayout: self)
        builder(subViewLayout)
        if let molecule = view as? MoleculeLayout {
            molecule.layoutChild(subViewLayout)
        }
        subLayouts.append(subViewLayout)
        return .init(view: view)
    }
    
    @discardableResult
    public func put(_ viewController: UIViewController, _ builder: (ViewLayout) -> Void = { _ in }) -> ViewApplicator<UIView> {
        ifHaveViewController { thisVC in
            thisVC.addChild(viewController)
            add(subView: viewController.view)
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
    
    func ifHaveViewController(do actions: (UIViewController) -> Void) {
        if let viewController = context.currentViewController {
            actions(viewController)
            return
        }
        do {
            if let viewController = try context.layoutDelegate.layoutBuilderNeedViewController(self) {
                actions(viewController)
            } else {
                print("No View Controller found")
            }
        } catch {
            guard let layoutError: LayoutError = error as? LayoutError else {
                print(error.localizedDescription)
                return
            }
            context.layoutDelegate.layoutBuilder(self, onError: layoutError)
        }
        return
    }
}

extension ViewLayout {
    
    private func view<V: UIView>(with restorationId: String?, ifNotPresent createView: @autoclosure () -> V) -> V {
        let viewForPut: V
        if let id = restorationId {
            viewForPut = view.subviews.first {
                $0.restorationIdentifier == id
                } as? V ?? createView()
        } else {
            viewForPut = createView()
        }
        return viewForPut
    }
    
    @discardableResult
    public func putView(restorationId: String? = nil, _ builder: (ViewLayout) -> Void) -> ViewApplicator<UIView> {
        put(view(with: restorationId, ifNotPresent: UIView()), builder)
    }
    
    @discardableResult
    public func putLabel(restorationId: String? = nil, _ builder: (ViewLayout) -> Void) -> ViewApplicator<UILabel> {
        put(view(with: restorationId, ifNotPresent: UILabel()), builder)
    }
    
    @discardableResult
    public func putButton(restorationId: String? = nil, _ builder: (ViewLayout) -> Void) -> ViewApplicator<UIButton> {
        put(view(with: restorationId, ifNotPresent: UIButton()), builder)
    }
    
    @discardableResult
    public func putImage(restorationId: String? = nil, _ builder: (ViewLayout) -> Void) -> ViewApplicator<UIImageView> {
        put(view(with: restorationId, ifNotPresent: UIImageView()), builder)
    }
    
    @discardableResult
    public func putTextField(restorationId: String? = nil, _ builder: (ViewLayout) -> Void) -> ViewApplicator<UITextField> {
        put(view(with: restorationId, ifNotPresent: UITextField()), builder)
    }
    
    @discardableResult
    public func putTextView(restorationId: String? = nil, _ builder: (ViewLayout) -> Void) -> ViewApplicator<UITextView> {
        put(view(with: restorationId, ifNotPresent: UITextView()), builder)
    }
    
    @discardableResult
    public func putSlider(restorationId: String? = nil, _ builder: (ViewLayout) -> Void) -> ViewApplicator<UISlider> {
        put(view(with: restorationId, ifNotPresent: UISlider()), builder)
    }
    
    @discardableResult
    public func putSwitch(restorationId: String? = nil, _ builder: (ViewLayout) -> Void) -> ViewApplicator<UISwitch> {
        put(view(with: restorationId, ifNotPresent: UISwitch()), builder)
    }
    
    @discardableResult
    public func putSegment(restorationId: String? = nil, _ builder: (ViewLayout) -> Void) -> ViewApplicator<UISegmentedControl> {
        put(view(with: restorationId, ifNotPresent: UISegmentedControl()), builder)
    }
    
    @discardableResult
    public func putPageControl(restorationId: String? = nil, _ builder: (ViewLayout) -> Void) -> ViewApplicator<UIPageControl> {
        put(view(with: restorationId, ifNotPresent: UIPageControl()), builder)
    }
    
    @discardableResult
    public func putProgress(restorationId: String? = nil, _ builder: (ViewLayout) -> Void) -> ViewApplicator<UIProgressView> {
        put(view(with: restorationId, ifNotPresent: UIProgressView()), builder)
    }
    
    @discardableResult
    public func putSearchBar(restorationId: String? = nil, _ builder: (ViewLayout) -> Void) -> ViewApplicator<UISearchBar> {
        put(view(with: restorationId, ifNotPresent: UISearchBar()), builder)
    }
    
    @discardableResult
    public func putScroll(restorationId: String? = nil, _ builder: (ViewLayout) -> Void) -> ViewApplicator<UIScrollView> {
        put(view(with: restorationId, ifNotPresent: UIScrollView()), builder)
    }
    
    @discardableResult
    public func putActivityIndicator(restorationId: String? = nil, _ builder: (ViewLayout) -> Void) -> ViewApplicator<UIActivityIndicatorView> {
        put(view(with: restorationId, ifNotPresent: UIActivityIndicatorView()), builder)
    }
    
    @discardableResult
    public func putPickerView(restorationId: String? = nil, _ builder: (ViewLayout) -> Void) -> ViewApplicator<UIPickerView> {
        put(view(with: restorationId, ifNotPresent: UIPickerView()), builder)
    }
    
    @discardableResult
    public func putDatePicker(restorationId: String? = nil, _ builder: (ViewLayout) -> Void) -> ViewApplicator<UIDatePicker> {
        put(view(with: restorationId, ifNotPresent: UIDatePicker()), builder)
    }
    
    @discardableResult
    public func putStepper(restorationId: String? = nil, _ builder: (ViewLayout) -> Void) -> ViewApplicator<UIStepper> {
        put(view(with: restorationId, ifNotPresent: UIStepper()), builder)
    }
    
    @available(iOS 13.0, *)
    @discardableResult
    public func putSearchTextField(restorationId: String? = nil, _ builder: (ViewLayout) -> Void) -> ViewApplicator<UISearchTextField> {
        put(view(with: restorationId, ifNotPresent: UISearchTextField()), builder)
    }
    
    @discardableResult
    public func putVisualEffect(restorationId: String? = nil, _ builder: (ViewLayout) -> Void) -> ViewApplicator<UIVisualEffectView> {
        put(view(with: restorationId, ifNotPresent: UIVisualEffectView()), builder)
    }
    
    @discardableResult
    public func putNavigationBar(restorationId: String? = nil, _ builder: (ViewLayout) -> Void) -> ViewApplicator<UINavigationBar> {
        put(view(with: restorationId, ifNotPresent: UINavigationBar()), builder)
    }
    
    @discardableResult
    public func putTabbar(restorationId: String? = nil, _ builder: (ViewLayout) -> Void) -> ViewApplicator<UITabBar> {
        put(view(with: restorationId, ifNotPresent: UITabBar()), builder)
    }
    
    @discardableResult
    public func putTable(restorationId: String? = nil, _ builder: (ViewLayout) -> Void) -> ViewApplicator<UITableView> {
        put(view(with: restorationId, ifNotPresent: UITableView()), builder)
    }
    
    @discardableResult
    public func putCollection(with layout: UICollectionViewLayout, restorationId: String? = nil, _ builder: (ViewLayout) -> Void) -> ViewApplicator<UICollectionView> {
        put(view(with: restorationId, ifNotPresent: UICollectionView(frame: .zero, collectionViewLayout: layout)), builder)
    }
    
    @discardableResult
    public func putVerticalStack(restorationId: String? = nil, _ builder: (StackedLayout) -> Void) -> ViewApplicator<UIStackView> {
        let stack = view(with: restorationId, ifNotPresent: UIStackView())
        stack.axis = .vertical
        return put(stack: stack, stackedStrategy: .append, builder)
    }
    
    @discardableResult
    public func putHorizontalStack(restorationId: String? = nil, _ builder: (StackedLayout) -> Void) -> ViewApplicator<UIStackView> {
        let stack = view(with: restorationId, ifNotPresent: UIStackView())
        stack.axis = .horizontal
        return put(stack: stack, stackedStrategy: .append, builder)
    }
    
    @discardableResult
    public func put(stack: UIStackView, stackedStrategy: LayoutStackedStrategy = .replaceDifferences, _ builder: (StackedLayout) -> Void = { _ in }) -> ViewApplicator<UIStackView> {
        stack.translatesAutoresizingMaskIntoConstraints = false
        add(subView: stack)
        let subViewLayout = StackedLayout(context: context, stack: stack, stackedStrategy: stackedStrategy, parentLayout: self)
        builder(subViewLayout)
        if let molecule = stack as? MoleculeLayout {
            molecule.layoutChild(subViewLayout)
        }
        subViewLayout.applyStack()
        subLayouts.append(subViewLayout)
        return .init(view: stack)
    }
    
}
