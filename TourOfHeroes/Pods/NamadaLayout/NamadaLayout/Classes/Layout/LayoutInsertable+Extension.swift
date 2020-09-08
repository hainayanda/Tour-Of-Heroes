//
//  LayoutInsertable+Extension.swift
//  NamadaLayout
//
//  Created by Nayanda Haberty (ID) on 03/09/20.
//

import Foundation
import UIKit
import WebKit

extension LayoutInsertable {
    func putAndCreateView<View: UIView>(thenAssignTo view: inout View?) -> ViewLayout<View> {
        let viewToPut = view ?? .init()
        defer {
            view = viewToPut
        }
        return put(viewToPut)
    }
    
    //MARK: UIView
    @discardableResult
    public func putView(assignTo view: inout UIView?) -> ViewLayout<UIView> {
        putAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func putView() -> ViewLayout<UIView> {
        put(.init())
    }
    
    //MARK: UIActivityIndicatorView
    
    @discardableResult
    public func putActivityIndicator(assignTo view: inout UIActivityIndicatorView?) -> ViewLayout<UIActivityIndicatorView> {
        putAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func putActivityIndicator() -> ViewLayout<UIActivityIndicatorView> {
        put(.init())
    }
    
    //MARK: UIButton
    
    @discardableResult
    public func putButton(assignTo view: inout UIButton?) -> ViewLayout<UIButton> {
        putAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func putButton() -> ViewLayout<UIButton> {
        put(.init())
    }
    
    //MARK: UIDatePicker
    
    @discardableResult
    public func putDatePicker(assignTo view: inout UIDatePicker?) -> ViewLayout<UIDatePicker> {
        putAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func putDatePicker() -> ViewLayout<UIDatePicker> {
        put(.init())
    }
    
    //MARK: UIPickerView
    
    @discardableResult
    public func putPicker(assignTo view: inout UIPickerView?) -> ViewLayout<UIPickerView> {
        putAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func putPicker() -> ViewLayout<UIPickerView> {
        put(.init())
    }
    
    //MARK: UIImageView
    
    @discardableResult
    public func putImageView(assignTo view: inout UIImageView?) -> ViewLayout<UIImageView> {
        putAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func putImageView() -> ViewLayout<UIImageView> {
        put(.init())
    }
    
    //MARK: UIPageControl
    
    @discardableResult
    public func putPageControl(assignTo view: inout UIPageControl?) -> ViewLayout<UIPageControl> {
        putAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func putPageControl() -> ViewLayout<UIPageControl> {
        put(.init())
    }
    
    //MARK: UIProgressView
    
    @discardableResult
    public func putProgress(assignTo view: inout UIProgressView?) -> ViewLayout<UIProgressView> {
        putAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func putProgress() -> ViewLayout<UIProgressView> {
        put(.init())
    }
    
    //MARK: UISearchBar
    
    @discardableResult
    public func putSearchBar(assignTo view: inout UISearchBar?) -> ViewLayout<UISearchBar> {
        putAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func putSearchBar() -> ViewLayout<UISearchBar> {
        put(.init())
    }
    
    @available(iOS 13.0, *)
    @discardableResult
    public func putSearchField(assignTo view: inout UISearchTextField?) -> ViewLayout<UISearchTextField> {
        putAndCreateView(thenAssignTo: &view)
    }
    
    @available(iOS 13.0, *)
    @discardableResult
    public func putSearchField() -> ViewLayout<UISearchTextField> {
        put(.init())
    }
    
    //MARK: UISegmentedControl
    
    @discardableResult
    public func putSegmentedControl(assignTo view: inout UISegmentedControl?) -> ViewLayout<UISegmentedControl> {
        putAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func putSegmentedControl() -> ViewLayout<UISegmentedControl> {
        put(.init())
    }
    
    //MARK: UISlider
    
    @discardableResult
    public func putSlider(assignTo view: inout UISlider?) -> ViewLayout<UISlider> {
        putAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func putSlider() -> ViewLayout<UISlider> {
        put(.init())
    }
    
    //MARK: UIStackView
    
    @discardableResult
    public func putStack(assignTo view: inout UIStackView?) -> ViewLayout<UIStackView> {
        putAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func putStack() -> ViewLayout<UIStackView> {
        put(.init())
    }
    
    @discardableResult
    public func putVStack(assignTo view: inout UIStackView?) -> ViewLayout<UIStackView> {
        let layout = putAndCreateView(thenAssignTo: &view)
        view?.axis = .vertical
        return layout
    }
    
    @discardableResult
    public func putVStack() -> ViewLayout<UIStackView> {
        let stack: UIStackView = .init()
        stack.axis = .vertical
        return put(stack)
    }
    
    @discardableResult
    public func putHStack(assignTo view: inout UIStackView?) -> ViewLayout<UIStackView> {
        let layout = putAndCreateView(thenAssignTo: &view)
        view?.axis = .horizontal
        return layout
    }
    
    @discardableResult
    public func putHStack() -> ViewLayout<UIStackView> {
        let stack: UIStackView = .init()
        stack.axis = .horizontal
        return put(stack)
    }
    
    //MARK: UIStepper
    
    @discardableResult
    public func putStepper(assignTo view: inout UIStepper?) -> ViewLayout<UIStepper> {
        putAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func putStepper() -> ViewLayout<UIStepper> {
        put(.init())
    }
    
    //MARK: UISwitch
    
    @discardableResult
    public func putSwitch(assignTo view: inout UISwitch?) -> ViewLayout<UISwitch> {
        putAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func putSwitch() -> ViewLayout<UISwitch> {
        put(.init())
    }
    
    //MARK: UITextField
    
    @discardableResult
    public func putTextField(assignTo view: inout UITextField?) -> ViewLayout<UITextField> {
        putAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func putTextField() -> ViewLayout<UITextField> {
        put(.init())
    }
    
    //MARK: UITextView
    
    @discardableResult
    public func putTextView(assignTo view: inout UITextView?) -> ViewLayout<UITextView> {
        putAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func putTextView() -> ViewLayout<UITextView> {
        put(.init())
    }
    
    //MARK: UIToolbar
    
    @discardableResult
    public func putToolbar(assignTo view: inout UIToolbar?) -> ViewLayout<UIToolbar> {
        putAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func putToolbar() -> ViewLayout<UIToolbar> {
        put(.init())
    }
    
    //MARK: WKWebView
    
    @discardableResult
    public func putWebView(assignTo view: inout WKWebView?) -> ViewLayout<WKWebView> {
        putAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func putWebView() -> ViewLayout<WKWebView> {
        put(.init())
    }
    
    //MARK: UIScrollView
    
    @discardableResult
    public func putScroll(assignTo view: inout UIScrollView?) -> ViewLayout<UIScrollView> {
        putAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func putScroll() -> ViewLayout<UIScrollView> {
        put(.init())
    }
    
    //MARK: UITableView
    
    @discardableResult
    public func putTable(assignTo view: inout UITableView?) -> ViewLayout<UITableView> {
        putAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func putTable() -> ViewLayout<UITableView> {
        put(.init())
    }
    
    //MARK: UICollectionView
    
    @discardableResult
    public func putCollection(assignTo view: inout UICollectionView?) -> ViewLayout<UICollectionView> {
        let collectionToPut = view ?? .init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        defer {
            view = collectionToPut
        }
        return put(collectionToPut)
    }
    
    @discardableResult
    public func putCollection() -> ViewLayout<UICollectionView> {
        put(.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()))
    }
    
    //MARK: UILabel
    
    @discardableResult
    public func putLabel(assignTo view: inout UILabel?) -> ViewLayout<UILabel> {
        putAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func putLabel() -> ViewLayout<UILabel> {
        put(.init())
    }
    
    //MARK: UIVisualEffectView
    
    @discardableResult
    public func putVisualEffect(assignTo view: inout UIVisualEffectView?) -> ViewLayout<UIVisualEffectView> {
        putAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func putVisualEffect() -> ViewLayout<UIVisualEffectView> {
        put(.init())
    }
    
    //MARK: UINavigationBar
    
    @discardableResult
    public func putNavigation(assignTo view: inout UINavigationBar?) -> ViewLayout<UINavigationBar> {
        putAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func putNavigation() -> ViewLayout<UINavigationBar> {
        put(.init())
    }
    
    //MARK: UITabBar
    
    @discardableResult
    public func putTabBar(assignTo view: inout UITabBar?) -> ViewLayout<UITabBar> {
        putAndCreateView(thenAssignTo: &view)
    }
    
    @discardableResult
    public func putTabBar() -> ViewLayout<UITabBar> {
        put(.init())
    }
}
