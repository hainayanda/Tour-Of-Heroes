//
//  LayoutInsertableStack+Extensions.swift
//  NamadaLayout
//
//  Created by Nayanda Haberty (ID) on 08/09/20.
//

import Foundation
import UIKit
import WebKit

extension ViewLayoutInsertable where View: UIStackView {
    func putStackedAndCreateView<View: UIView>(thenAssignTo view: inout View?) -> ViewLayout<View> {
        let viewToputStacked = view ?? .init()
        defer {
            view = viewToputStacked
        }
        return putStacked(viewToputStacked)
    }
    
    //MARK: UIView
    @discardableResult
    public func putStackedView(assignTo view: inout UIView?) -> ViewLayout<UIView> {
        putStackedAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func putStackedView() -> ViewLayout<UIView> {
        putStacked(.init())
    }
    
    //MARK: UIActivityIndicatorView
    
    @discardableResult
    public func putStackedActivityIndicator(assignTo view: inout UIActivityIndicatorView?) -> ViewLayout<UIActivityIndicatorView> {
        putStackedAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func putStackedActivityIndicator() -> ViewLayout<UIActivityIndicatorView> {
        putStacked(.init())
    }
    
    //MARK: UIButton
    
    @discardableResult
    public func putStackedButton(assignTo view: inout UIButton?) -> ViewLayout<UIButton> {
        putStackedAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func putStackedButton() -> ViewLayout<UIButton> {
        putStacked(.init())
    }
    
    //MARK: UIDatePicker
    
    @discardableResult
    public func putStackedDatePicker(assignTo view: inout UIDatePicker?) -> ViewLayout<UIDatePicker> {
        putStackedAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func putStackedDatePicker() -> ViewLayout<UIDatePicker> {
        putStacked(.init())
    }
    
    //MARK: UIPickerView
    
    @discardableResult
    public func putStackedPicker(assignTo view: inout UIPickerView?) -> ViewLayout<UIPickerView> {
        putStackedAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func putStackedPicker() -> ViewLayout<UIPickerView> {
        putStacked(.init())
    }
    
    //MARK: UIImageView
    
    @discardableResult
    public func putStackedImageView(assignTo view: inout UIImageView?) -> ViewLayout<UIImageView> {
        putStackedAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func putStackedImageView() -> ViewLayout<UIImageView> {
        putStacked(.init())
    }
    
    //MARK: UIPageControl
    
    @discardableResult
    public func putStackedPageControl(assignTo view: inout UIPageControl?) -> ViewLayout<UIPageControl> {
        putStackedAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func putStackedPageControl() -> ViewLayout<UIPageControl> {
        putStacked(.init())
    }
    
    //MARK: UIProgressView
    
    @discardableResult
    public func putStackedProgress(assignTo view: inout UIProgressView?) -> ViewLayout<UIProgressView> {
        putStackedAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func putStackedProgress() -> ViewLayout<UIProgressView> {
        putStacked(.init())
    }
    
    //MARK: UISearchBar
    
    @discardableResult
    public func putStackedSearchBar(assignTo view: inout UISearchBar?) -> ViewLayout<UISearchBar> {
        putStackedAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func putStackedSearchBar() -> ViewLayout<UISearchBar> {
        putStacked(.init())
    }
    
    @available(iOS 13.0, *)
    @discardableResult
    public func putStackedSearchField(assignTo view: inout UISearchTextField?) -> ViewLayout<UISearchTextField> {
        putStackedAndCreateView(thenAssignTo: &view)
    }
    
    @available(iOS 13.0, *)
    @discardableResult
    public func putStackedSearchField() -> ViewLayout<UISearchTextField> {
        putStacked(.init())
    }
    
    //MARK: UISegmentedControl
    
    @discardableResult
    public func putStackedSegmentedControl(assignTo view: inout UISegmentedControl?) -> ViewLayout<UISegmentedControl> {
        putStackedAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func putStackedSegmentedControl() -> ViewLayout<UISegmentedControl> {
        putStacked(.init())
    }
    
    //MARK: UISlider
    
    @discardableResult
    public func putStackedSlider(assignTo view: inout UISlider?) -> ViewLayout<UISlider> {
        putStackedAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func putStackedSlider() -> ViewLayout<UISlider> {
        putStacked(.init())
    }
    
    //MARK: UIStackView
    
    @discardableResult
    public func putStackedStack(assignTo view: inout UIStackView?) -> ViewLayout<UIStackView> {
        putStackedAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func putStackedStack() -> ViewLayout<UIStackView> {
        putStacked(.init())
    }
    
    @discardableResult
    public func putStackedVStack(assignTo view: inout UIStackView?) -> ViewLayout<UIStackView> {
        let layout = putStackedAndCreateView(thenAssignTo: &view)
        view?.axis = .vertical
        return layout
    }
    
    @discardableResult
    public func putStackedVStack() -> ViewLayout<UIStackView> {
        let stack: UIStackView = .init()
        stack.axis = .vertical
        return putStacked(stack)
    }
    
    @discardableResult
    public func putStackedHStack(assignTo view: inout UIStackView?) -> ViewLayout<UIStackView> {
        let layout = putStackedAndCreateView(thenAssignTo: &view)
        view?.axis = .horizontal
        return layout
    }
    
    @discardableResult
    public func putStackedHStack() -> ViewLayout<UIStackView> {
        let stack: UIStackView = .init()
        stack.axis = .horizontal
        return putStacked(stack)
    }
    
    //MARK: UIStepper
    
    @discardableResult
    public func putStackedStepper(assignTo view: inout UIStepper?) -> ViewLayout<UIStepper> {
        putStackedAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func putStackedStepper() -> ViewLayout<UIStepper> {
        putStacked(.init())
    }
    
    //MARK: UISwitch
    
    @discardableResult
    public func putStackedSwitch(assignTo view: inout UISwitch?) -> ViewLayout<UISwitch> {
        putStackedAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func putStackedSwitch() -> ViewLayout<UISwitch> {
        putStacked(.init())
    }
    
    //MARK: UITextField
    
    @discardableResult
    public func putStackedTextField(assignTo view: inout UITextField?) -> ViewLayout<UITextField> {
        putStackedAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func putStackedTextField() -> ViewLayout<UITextField> {
        putStacked(.init())
    }
    
    //MARK: UITextView
    
    @discardableResult
    public func putStackedTextView(assignTo view: inout UITextView?) -> ViewLayout<UITextView> {
        putStackedAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func putStackedTextView() -> ViewLayout<UITextView> {
        putStacked(.init())
    }
    
    //MARK: UIToolbar
    
    @discardableResult
    public func putStackedToolbar(assignTo view: inout UIToolbar?) -> ViewLayout<UIToolbar> {
        putStackedAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func putStackedToolbar() -> ViewLayout<UIToolbar> {
        putStacked(.init())
    }
    
    //MARK: WKWebView
    
    @discardableResult
    public func putStackedWebView(assignTo view: inout WKWebView?) -> ViewLayout<WKWebView> {
        putStackedAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func putStackedWebView() -> ViewLayout<WKWebView> {
        putStacked(.init())
    }
    
    //MARK: UIScrollView
    
    @discardableResult
    public func putStackedScroll(assignTo view: inout UIScrollView?) -> ViewLayout<UIScrollView> {
        putStackedAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func putStackedScroll() -> ViewLayout<UIScrollView> {
        putStacked(.init())
    }
    
    //MARK: UITableView
    
    @discardableResult
    public func putStackedTable(assignTo view: inout UITableView?) -> ViewLayout<UITableView> {
        putStackedAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func putStackedTable() -> ViewLayout<UITableView> {
        putStacked(.init())
    }
    
    //MARK: UICollectionView
    
    @discardableResult
    public func putStackedCollection(assignTo view: inout UICollectionView?) -> ViewLayout<UICollectionView> {
        let collectionToputStacked = view ?? .init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        defer {
            view = collectionToputStacked
        }
        return putStacked(collectionToputStacked)
    }
    
    @discardableResult
    public func putStackedCollection() -> ViewLayout<UICollectionView> {
        putStacked(.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()))
    }
    
    //MARK: UILabel
    
    @discardableResult
    public func putStackedLabel(assignTo view: inout UILabel?) -> ViewLayout<UILabel> {
        putStackedAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func putStackedLabel() -> ViewLayout<UILabel> {
        putStacked(.init())
    }
    
    //MARK: UIVisualEffectView
    
    @discardableResult
    public func putStackedVisualEffect(assignTo view: inout UIVisualEffectView?) -> ViewLayout<UIVisualEffectView> {
        putStackedAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func putStackedVisualEffect() -> ViewLayout<UIVisualEffectView> {
        putStacked(.init())
    }
    
    //MARK: UINavigationBar
    
    @discardableResult
    public func putStackedNavigation(assignTo view: inout UINavigationBar?) -> ViewLayout<UINavigationBar> {
        putStackedAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func putStackedNavigation() -> ViewLayout<UINavigationBar> {
        putStacked(.init())
    }
    
    //MARK: UITabBar
    
    @discardableResult
    public func putStackedTabBar(assignTo view: inout UITabBar?) -> ViewLayout<UITabBar> {
        putStackedAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func putStackedTabBar() -> ViewLayout<UITabBar> {
        putStacked(.init())
    }
}
