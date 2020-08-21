//
//  LayoutCompatible+Extension.swift
//  FBSnapshotTestCase
//
//  Created by Nayanda Haberty (ID) on 09/07/20.
//

import Foundation
import UIKit

public extension LayoutCompatible where Self: UIView {
    var viewForLayout: UIView { self }
    
    var layoutViewController: UIViewController? { nil }
}

public extension LayoutCompatible {
    
    var layout: ViewLayout {
        let context: LayoutContext = .init()
        context.currentViewController = layoutViewController
        return ViewLayout(context: context, view: viewForLayout, parentLayout: viewForLayout.superview?.layout)
    }
    
    private func prepareLayout(delegate: LayoutBuilderDelegate? = nil, _ builder: (ViewLayout) -> Void) -> ViewLayout {
        self.viewForLayout.translatesAutoresizingMaskIntoConstraints = false
        let layout = viewForLayout.layout
        if let delegate = delegate {
            layout.context.layoutDelegate = delegate
        }
        builder(layout)
        return layout
    }
    
    func makeLayout(_ builder: (ViewLayout) -> Void) {
        let layout = prepareLayout(builder)
        DispatchQueue.main.async {
            layout.apply()
        }
    }
    
    func makeAndEditLayout(_ builder: (ViewLayout) -> Void) {
        let layout = prepareLayout(builder)
        DispatchQueue.main.async {
            layout.editExistingAndApply()
        }
    }
    
    func remakeLayout(_ builder: (ViewLayout) -> Void) {
        let layout = prepareLayout(builder)
        DispatchQueue.main.async {
            layout.remake()
        }
    }
    
    func makeLayoutCleanly(_ builder: (ViewLayout) -> Void) {
        let layout = prepareLayout(builder)
        viewForLayout.cleanSubViews()
        DispatchQueue.main.async {
            layout.apply()
        }
    }
    
    func makeLayout(delegate: LayoutBuilderDelegate, _ builder: (ViewLayout) -> Void) {
        let layout = prepareLayout(delegate: delegate, builder)
        DispatchQueue.main.async {
            layout.apply()
        }
    }
    
    func makeAndEditLayout(delegate: LayoutBuilderDelegate,_ builder: (ViewLayout) -> Void) {
        let layout = prepareLayout(delegate: delegate, builder)
        DispatchQueue.main.async {
            layout.editExistingAndApply()
        }
    }
    
    func remakeLayout(delegate: LayoutBuilderDelegate, _ builder: (ViewLayout) -> Void) {
        let layout = prepareLayout(delegate: delegate, builder)
        DispatchQueue.main.async {
            layout.remake()
        }
    }
    
    func makeLayoutCleanly(delegate: LayoutBuilderDelegate, _ builder: (ViewLayout) -> Void) {
        let layout = prepareLayout(delegate: delegate, builder)
        viewForLayout.cleanSubViews()
        DispatchQueue.main.async {
            layout.apply()
        }
    }
}
