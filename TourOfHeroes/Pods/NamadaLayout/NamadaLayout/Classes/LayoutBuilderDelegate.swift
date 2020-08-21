//
//  LayoutBuilderDelegate.swift
//  FBSnapshotTestCase
//
//  Created by Nayanda Haberty (ID) on 09/07/20.
//

import Foundation

public protocol LayoutBuilderDelegate: class {
    func layoutBuilderNeedParent<Layout: LayoutBuilder>(_ layout: Layout) throws -> Layout?
    func layoutBuilderNeedViewController(_ layout: ViewLayout) throws -> UIViewController?
    func layoutBuilder<Layout: LayoutBuilder>(_ layout: Layout, relateWith sameLayout: Layout) throws
    func layoutBuilder<Layout: LayoutBuilder>(_ layout: Layout, onError error: LayoutError)
    func layoutBuilder<Layout: LayoutBuilder>(_ layout: Layout, willActivateConstraints constraints: [NSLayoutConstraint])
    func layoutBuilder<Layout: LayoutBuilder>(_ layout: Layout, didActivateConstraints constraints: [NSLayoutConstraint])
}


public extension LayoutBuilderDelegate {
    func layoutBuilderNeedParent<Layout>(_ layout: Layout) throws -> Layout? where Layout : LayoutBuilder {
        throw LayoutError(description: "No designated parent")
    }
    
    func layoutBuilderNeedViewController(_ layout: ViewLayout) throws -> UIViewController? {
        throw LayoutError(description: "No designated UIViewController")
    }
    
    func layoutBuilder<Layout: LayoutBuilder>(_ layout: Layout, relateWith sameLayout: Layout) throws {
        throw LayoutError(description:"NamadaLayout cannot relating two same layout type : \(layout.identifier) with \(sameLayout.identifier)")
    }
    
    func layoutBuilder<Layout: LayoutBuilder>(_ layout: Layout, onError error: LayoutError) {
        print(error.localizedDescription)
    }
    
    func layoutBuilder<Layout: LayoutBuilder>(_ layout: Layout, willActivateConstraints constraints: [NSLayoutConstraint]) { }
    
    func layoutBuilder<Layout: LayoutBuilder>(_ layout: Layout, didActivateConstraints constraints: [NSLayoutConstraint]) { }
}

class DefaultDelegate: LayoutBuilderDelegate {
    static var shared: LayoutBuilderDelegate = DefaultDelegate()
}
