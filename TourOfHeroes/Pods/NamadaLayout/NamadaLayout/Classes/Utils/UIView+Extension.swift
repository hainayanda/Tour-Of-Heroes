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
    
    public func bindedModel() -> AnyObject? {
        let wrapper = objc_getAssociatedObject(self, &AssociatedKey.model) as? AssociatedWrapper
        return wrapper?.wrapped
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

extension UIResponder {
    public var parentViewController: UIViewController? {
        next as? UIViewController ?? next?.parentViewController
    }
}
