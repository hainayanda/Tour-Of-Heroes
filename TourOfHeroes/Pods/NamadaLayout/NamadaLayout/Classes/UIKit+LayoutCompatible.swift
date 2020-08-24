//
//  UIKit+LayoutCompatible.swift
//  FBSnapshotTestCase
//
//  Created by Nayanda Haberty (ID) on 08/07/20.
//

import Foundation
import UIKit

extension UIView: LayoutCompatible {
    @objc public var shouldAutoTranslatesAutoresizingMaskIntoConstraints: Bool { true }
    @objc public var viewForLayout: UIView { self }
    public var layoutViewController: UIViewController? { nil }
}

extension UIViewController: LayoutCompatible {
    public var shouldAutoTranslatesAutoresizingMaskIntoConstraints: Bool { false }
    public var layoutViewController: UIViewController? { self }
    public var viewForLayout: UIView { self.view }
}

extension UITableViewCell {
    public override var shouldAutoTranslatesAutoresizingMaskIntoConstraints: Bool { false }
    public override var viewForLayout: UIView { self.contentView }
}

extension UICollectionViewCell {
    public override var shouldAutoTranslatesAutoresizingMaskIntoConstraints: Bool { false }
    public override var viewForLayout: UIView { self.contentView }
}
