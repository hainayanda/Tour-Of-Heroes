//
//  UIView+Extension.swift
//  NamadaLayout
//
//  Created by Nayanda Haberty (ID) on 05/07/20.
//

import Foundation
import UIKit

extension NSObject {
    struct AssociatedKey {
        static var model: String = "Namada_View_Model"
    }
    
    public func bindedModel<Model: BindableViewModel>() -> Model? {
        let wrapper = objc_getAssociatedObject(self, &AssociatedKey.model) as? AssociatedWrapper
        return wrapper?.wrapped as? Model
    }
}

extension UIView {
    
    public var uniqueKey: String {
        let address = Int(bitPattern: Unmanaged.passUnretained(self).toOpaque())
        return NSString(format: "%p", address) as String
    }
    
    var mostTopParentForLayout: UIView {
        var currentParent = self
        while let parent = currentParent.superview {
            if let cell = parent as? UITableViewCell {
                currentParent = cell
                break
            } else if let cell = parent as? UICollectionViewCell {
                currentParent = cell
                break
            }
            currentParent = parent
        }
        return currentParent
    }
    
    func removeAllRelatedNamadaConstraints() {
        let relatedIds = getAllSubViews().compactMap {
            $0.layout.identifier
        }
        mostTopParentForLayout.remove(allIdentifiedNamadaConstraints: relatedIds)
    }
    
    func getAllSubViews() -> [UIView] {
        var childrens: [UIView] = subviews
        for view in self.subviews {
            childrens.append(contentsOf: view.getAllSubViews())
        }
        return childrens
    }
    
    func remove(allIdentifiedNamadaConstraints ids: [String]) {
        let relatedConstraints = constraints.filter { constraint in
            ids.contains { id in
                constraint.identifier?.contains(id) ?? false
            }
        }
        removeConstraints(relatedConstraints)
        for subView in self.subviews {
            subView.remove(allIdentifiedNamadaConstraints: ids)
        }
    }
    
    func remove(allIdentified constraints: [NSLayoutConstraint]) {
        var constraints = constraints
        guard !constraints.isEmpty else {
            return
        }
        let sameConstraints = self.constraints.filter { viewConstraint in
            constraints.contains { viewConstraint.identifier == $0.identifier }
        }
        constraints.removeAll { lastConstraint in
            sameConstraints.contains { lastConstraint.identifier == $0.identifier }
        }
        self.removeConstraints(sameConstraints)
        for subView in self.subviews {
            subView.remove(allIdentified: constraints)
        }
    }
    
    func cleanSubViews() {
        let subViews = subviews
        for subView in subViews {
            subView.cleanSubViews()
            subView.removeFromSuperview()
        }
    }
}

extension UISearchBar {
    
    var textField: UITextField {
        if #available(iOS 13, *) {
            return searchTextField
        } else {
            return self.value(forKey: "_searchField") as! UITextField
        }
    }

}
