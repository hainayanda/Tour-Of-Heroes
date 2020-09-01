//
//  UIViewController+Extensions.swift
//  TourOfHeroes
//
//  Created by Nayanda Haberty (ID) on 22/08/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import UIKit
import NamadaLayout

// MARK: UINavigation Helper
extension UIViewController {
    @objc class BarButtonClosure: NSObject {
        var closure: (UIBarButtonItem) -> Void
        
        init(closure: @escaping (UIBarButtonItem) -> Void) {
            self.closure = closure
        }
        
        @objc func invoke(from button: UIBarButtonItem) {
            closure(button)
        }
    }
    
    class NavigationBarModel {
        public var title: String?
        public var leftButtonAction: ((UIBarButtonItem) -> Void)?
        public var rightButtonAction: ((UIBarButtonItem) -> Void)?
        public var leftButtonIcon: UIImage?
        public var leftButtonText: String?
        public var rightButtonIcon: UIImage?
        public var rightButtonText: String?
        
        public var isHaveRightButton: Bool {
            let haveIconOrText = rightButtonIcon != nil || rightButtonText != nil
            let haveSelector = rightButtonAction != nil
            return haveSelector && haveIconOrText
        }
        public var isHaveLeftButton: Bool {
            let haveIconOrText = leftButtonIcon != nil || leftButtonText != nil
            let haveSelector = leftButtonAction != nil
            return (haveSelector && haveIconOrText) || haveIconOrText
        }
        public var isHaveTitle: Bool {
            return title != nil
        }
    }
    
    func preLayoutNavigation(with style: UIStatusBarStyle? = nil) {
        let statusBarStyle = style ?? preferredStatusBarStyle
        navigationController?.navigationBar.barStyle = statusBarStyle == .default ? .default : .black
        if statusBarStyle == .default {
            navigationController?.navigationBar.barTintColor = .white
            navigationController?.navigationBar.tintColor = .black
        } else {
            navigationController?.navigationBar.isTranslucent = false
            navigationController?.navigationBar.barTintColor = .black
            navigationController?.navigationBar.tintColor = .white
        }
        navigationController?.navigationBar.layer.masksToBounds = false
        navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        navigationController?.navigationBar.layer.shadowOpacity = .tooClear
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: .zero, height: .x2)
        navigationController?.navigationBar.layer.shadowRadius = .x4
    }
    
    func layoutNavigation(with builder: (NavigationBarModel) -> Void) {
        let model = NavigationBarModel()
        builder(model)
        if model.isHaveTitle {
            layoutNavigationTitle(as: model)
        }
        if model.isHaveLeftButton {
            layoutNavigationLeftButton(as: model)
        }
        if model.isHaveRightButton {
            layoutNavigationRightButton(as: model)
        }
    }
    
    private func layoutNavigationTitle(as model: NavigationBarModel) {
        let title: UILabel = build {
            $0.font = .systemFont(ofSize: .x32, weight: .heavy)
            $0.text = model.title
            $0.textColor = .black
            $0.numberOfLines = 1
            $0.textAlignment = .left
        }
        let leftMargin: CGFloat = model.isHaveLeftButton ? .x96 : .x16
        let rightMargin: CGFloat = model.isHaveRightButton ? .x96 : .x16
        let width = view.frame.width - leftMargin - rightMargin
        let offset: CGFloat = (leftMargin - rightMargin) / 2
        let container: UIView = .init(frame: .init(origin: .zero, size: .init(width: .x1024, height: .x24)))
        container.translatesAutoresizingMaskIntoConstraints = false
        container.layoutContent { content in
            content.put(title)
                .vertical(.equal, to: .parent)
                .centerX(.equalTo(offset), to: .parent)
                .width(.equalTo(width))
        }
        navigationItem.titleView = container
    }
    
    private func layoutNavigationLeftButton(as model: NavigationBarModel) {
        let leftItem: UIBarButtonItem = getLeftButtonItem(model)
        navigationItem.setLeftBarButton(leftItem, animated: true)
    }
    
    private func layoutNavigationRightButton(as model: NavigationBarModel) {
        let rightItem: UIBarButtonItem = getRightButtonItem(model)
        navigationItem.setRightBarButton(rightItem, animated: true)
    }
    
    private func getRightButtonItem(_ model: NavigationBarModel) -> UIBarButtonItem {
        guard let buttonClosure = model.rightButtonAction else {
            fatalError("Something must be wrong since it's can run this line of code")
        }
        objc_setAssociatedObject(self, "[\(arc4random())]", buttonClosure, .OBJC_ASSOCIATION_RETAIN)
        if let icon = model.rightButtonIcon {
            return .init(
                image: icon,
                style: .plain,
                target: buttonClosure,
                action: #selector(BarButtonClosure.invoke(from:))
            )
        } else if let text = model.rightButtonText {
            return .init(
                title: text,
                style: .plain,
                target: buttonClosure,
                action: #selector(BarButtonClosure.invoke(from:))
            )
        } else {
            fatalError("Something must be wrong since it's can run this line of code")
        }
    }
    
    private func getLeftButtonItem(_ model: NavigationBarModel) -> UIBarButtonItem {
        let buttonClosure = getLeftButtonClosure(model)
        objc_setAssociatedObject(self, "[\(arc4random())]", buttonClosure, .OBJC_ASSOCIATION_RETAIN)
        if let icon = model.leftButtonIcon {
            return .init(
                image: icon,
                style: .done,
                target: buttonClosure,
                action: #selector(BarButtonClosure.invoke(from:))
            )
        } else if let text = model.leftButtonText {
            return .init(
                title: text,
                style: .done,
                target: buttonClosure,
                action: #selector(BarButtonClosure.invoke(from:))
            )
        } else {
            return .init(
                barButtonSystemItem: .close,
                target: buttonClosure,
                action: #selector(BarButtonClosure.invoke(from:))
            )
        }
    }
    
    private func getLeftButtonClosure(_ model: NavigationBarModel) -> BarButtonClosure {
        if let leftAction = model.leftButtonAction {
            return .init(closure: leftAction)
        }
        else if navigationController?.viewControllers.first == self {
            return .init { [weak self] button in
                self?.dismissVC(button)
            }
        } else {
            return .init { [weak self] button in
                self?.popVC(button)
            }
        }
    }
    
    private func popVC(_ button: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    private func dismissVC(_ button: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: Alert & Options

public extension UIViewController {
    class PopUp {
        public var title: String = ""
        public var message: String = ""
    }
    
    enum AlertStyle {
        case none
        case destructive
    }
    
    class AlertModel: PopUp {
        public var style: AlertStyle = .none
        public var negativeButtonTitle: String = "No"
        public var positiveButtonTitle: String = "Yes"
        public var positiveHandler: ((UIAlertAction) -> Void)?
        public var negativeHandler: ((UIAlertAction) -> Void)?
    }
    
    class OptionsModel: PopUp {
        public var actions: [UIAlertAction] = []
    }
}

public extension UIViewController {
    // MARK: Alert
    
    func showSystemAlert(builder: (AlertModel) -> Void) {
        let model = AlertModel()
        builder(model)
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert
        )
        alert.addAction(
            .init(
                title: model.positiveButtonTitle,
                style: .default,
                handler: model.positiveHandler
            )
        )
        alert.addAction(
            .init(
                title: model.negativeButtonTitle,
                style: model.style == .none ? .cancel : .destructive,
                handler: model.negativeHandler
            )
        )
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: Options
    
    func showOptions(builder: (OptionsModel) -> Void) {
        let model = OptionsModel()
        builder(model)
        let options = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .actionSheet
        )
        for actions in model.actions {
            options.addAction(actions)
        }
        present(options, animated: true, completion: nil)
    }
    
    // MARK: Toast
    
    func showToast(message: String) {
        let toastContainer: UIView = build {
            $0.backgroundColor = UIColor.black.withAlphaComponent(.semiClear)
            $0.alpha = .clear
            $0.layer.cornerRadius = .x24
            $0.clipsToBounds  =  true
        }
        layoutToast(toastContainer, message)
        animateToast(toastContainer)
    }
    
    private func layoutToast(_ toastContainer: UIView, _ message: String) {
        let label: UILabel = build {
            $0.font = .systemFont(ofSize: .x12)
            $0.textColor = .white
            $0.textAlignment = .center
            $0.lineBreakMode = .byTruncatingTail
            $0.numberOfLines = 0
            $0.text = message
        }
        layoutContent { content in
            content.put(toastContainer)
                .horizontal(.equalTo(CGFloat.x64), to: .parent)
                .centerY(.equal, to: .parent)
                .layoutContent { toast in
                    toast.put(label)
                        .edges(.equalTo(CGFloat.x8), to: .parent)
            }
        }
    }
    
    private func animateToast(_ toastContainer: UIView) {
        UIView.animate(withDuration: .fast, delay: .zero, options: .curveEaseIn, animations: {
            toastContainer.alpha = .opaque
        }, completion: { _ in
            UIView.animate(withDuration: .fluid, delay: .slower, options: .curveEaseOut, animations: {
                toastContainer.alpha = .clear
            }, completion: {_ in
                toastContainer.removeFromSuperview()
            })
        })
    }
}
