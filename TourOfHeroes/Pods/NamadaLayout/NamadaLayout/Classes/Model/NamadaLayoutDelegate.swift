//
//  NamadaLayoutDelegate.swift
//  NamadaLayout
//
//  Created by Nayanda Haberty (ID) on 27/08/20.
//

import Foundation
import UIKit

public protocol NamadaLayoutDelegate: class {
    func namadaLayout(viewHaveNoSuperview view: UIView) -> UIView?
    func namadaLayout(neededViewControllerFor viewController: UIViewController) -> UIViewController?
    func namadaLayout(_ view: UIView, erroWhenLayout error: NamadaError)
}

public class DefaultNamadaLayoutDelegate: NamadaLayoutDelegate {
    static var shared: NamadaLayoutDelegate = DefaultNamadaLayoutDelegate()
}

public extension NamadaLayoutDelegate {
    func namadaLayout(viewHaveNoSuperview view: UIView) -> UIView? { nil }
    func namadaLayout(_ view: UIView, erroWhenLayout error: NamadaError) { }
    func namadaLayout(neededViewControllerFor viewController: UIViewController) -> UIViewController? {
        self as? UIViewController ?? (self as? UIView)?.parentViewController
    }
}
