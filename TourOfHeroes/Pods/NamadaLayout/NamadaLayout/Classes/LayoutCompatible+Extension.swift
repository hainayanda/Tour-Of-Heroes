//
//  LayoutCompatible+Extension.swift
//  FBSnapshotTestCase
//
//  Created by Nayanda Haberty (ID) on 09/07/20.
//

import Foundation
import UIKit

public extension LayoutCompatible {
    
    var layout: ViewLayout {
        let parentLayout = self.parentLayout
        let context: LayoutContext = parentLayout?.context ?? .init()
        context.currentViewController = layoutViewController
        return ViewLayout(context: context, view: viewForLayout, parentLayout: parentLayout)
    }
    
    private var parentLayout: ViewLayout? {
        guard let superview = viewForLayout.superview else { return nil }
        guard !(superview is UITableViewCell || superview is UICollectionViewCell) else {
            return ViewLayout(context: .init(), view: superview, parentLayout: nil)
        }
        return superview.layout
    }
    
    private func prepareLayout(delegate: LayoutBuilderDelegate? = nil, _ builder: (ViewLayout) -> Void) -> ViewLayout {
        if shouldAutoTranslatesAutoresizingMaskIntoConstraints {
            self.viewForLayout.translatesAutoresizingMaskIntoConstraints = false
        }
        let layout = viewForLayout.layout
        if let delegate = delegate {
            layout.context.layoutDelegate = delegate
        }
        builder(layout)
        return layout
    }
    
    func makeLayout(_ builder: (ViewLayout) -> Void) {
        let layout = prepareLayout(builder)
        layout.apply()
    }
    
    func makeAndEditLayout(_ builder: (ViewLayout) -> Void) {
        let layout = prepareLayout(builder)
        layout.editExistingAndApply()
    }
    
    func remakeLayout(_ builder: (ViewLayout) -> Void) {
        let layout = prepareLayout(builder)
        layout.remake()
    }
    
    func makeLayoutCleanly(_ builder: (ViewLayout) -> Void) {
        let layout = prepareLayout(builder)
        viewForLayout.cleanSubViews()
        layout.apply()
    }
    
    func makeLayout(delegate: LayoutBuilderDelegate, _ builder: (ViewLayout) -> Void) {
        let layout = prepareLayout(delegate: delegate, builder)
        layout.apply()
    }
    
    func makeAndEditLayout(delegate: LayoutBuilderDelegate,_ builder: (ViewLayout) -> Void) {
        let layout = prepareLayout(delegate: delegate, builder)
        layout.editExistingAndApply()
    }
    
    func remakeLayout(delegate: LayoutBuilderDelegate, _ builder: (ViewLayout) -> Void) {
        let layout = prepareLayout(delegate: delegate, builder)
        layout.remake()
    }
    
    func makeLayoutCleanly(delegate: LayoutBuilderDelegate, _ builder: (ViewLayout) -> Void) {
        let layout = prepareLayout(delegate: delegate, builder)
        viewForLayout.cleanSubViews()
        layout.apply()
    }
}
