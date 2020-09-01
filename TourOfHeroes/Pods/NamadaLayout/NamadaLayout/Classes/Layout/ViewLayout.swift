//
//  ViewLayout.swift
//  NamadaLayout
//
//  Created by Nayanda Haberty (ID) on 27/08/20.
//

import Foundation

public class ViewLayout<View: UIView>: NamadaLayoutable {
    
    public var constructedConstraints: [NSLayoutConstraint] = []
    public var view: View
    public var context: LayoutContext
    
    init(view: View, context: LayoutContext) {
        self.view = view
        self.context = context
    }
    
    @discardableResult
    public func layoutContent(_ containerBuilder: (LayoutContainer<View>) -> Void) -> Self {
        let container = LayoutContainer(view: self.view, context: context)
        containerBuilder(container)
        for layoutable in container.subLayoutables {
            constructedConstraints.append(contentsOf: layoutable.constructedConstraints)
        }
        return self
    }
}
