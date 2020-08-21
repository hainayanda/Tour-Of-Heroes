//
//  UIKit+LayoutCompatible.swift
//  FBSnapshotTestCase
//
//  Created by Nayanda Haberty (ID) on 08/07/20.
//

import Foundation
import UIKit

extension UIView: LayoutCompatible { }

extension UIViewController: LayoutCompatible {
    public var layoutViewController: UIViewController? { self }
    public var viewForLayout: UIView { self.view }
}

extension UITableViewCell {
    public var viewForLayout: UIView { self.contentView }
}

extension UICollectionViewCell {
    public var viewForLayout: UIView { self.contentView }
}
