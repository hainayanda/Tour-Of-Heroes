//
//  HeroDetailScreen.swift
//  TourOfHeroes
//
//  Created by Nayanda Haberty (ID) on 24/08/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import UIKit
import NamadaLayout

class HeroDetailScreen: UIViewController {
    // MARK: View
    
    lazy var tableView: UITableView = build {
        $0.backgroundColor = .clear
        $0.contentInset = view.safeAreaInsets
        $0.separatorStyle = .none
        $0.allowsSelection = false
        $0.delegate = self
    }
    lazy var translucentBackDrop: UIImageView = build {
        $0.contentMode = .scaleAspectFill
    }
    lazy var statusBarView: UIView = build {
        $0.backgroundColor = .white
        $0.alpha = 0
    }
    lazy var blurEffect = UIBlurEffect(style:  .dark)
    lazy var blurEffectView = UIVisualEffectView(effect: blurEffect)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        layoutView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigation()
        
        view.addSubview(translucentBackDrop)
        view.sendSubviewToBack(translucentBackDrop)
        translucentBackDrop.layer.masksToBounds = true
        translucentBackDrop.frame = .init(
            origin: .zero,
            size: .init(width: view.frame.width, height: view.frame.width)
        )
        blurEffectView.frame = translucentBackDrop.bounds
        blurEffectView.alpha = .almostOpaque
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        translucentBackDrop.addSubview(blurEffectView)
    }
    
    func setNavbar(backgroundColorAlpha alpha: CGFloat) {
        navigationController?.navigationBar.tintColor = alpha > .semiClear ? .black : .lightGray
        let color = UIColor.white.withAlphaComponent(alpha)
        navigationController?.navigationBar.backgroundColor = color
        statusBarView.alpha = alpha
        blurEffectView.alpha = .almostOpaque + (alpha * .almostClear)
    }
    
    private func setupNavigation() {
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = .lightGray
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true

        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        view.addSubview(statusBarView)
        statusBarView.frame = window?.windowScene?.statusBarManager?.statusBarFrame
            ?? .init(origin: .zero, size: .init(width: view.frame.width, height: .statusBarHeight))
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    private func layoutView() {
        layoutContent { content in
            content.put(tableView).edges(.equal, to: .safeArea)
            content.put(translucentBackDrop)
                .at(.fullTop, .equal, to: .parent)
                .height(.equalTo(translucentBackDrop.widthAnchor), multiplyBy: 1, constant: 0)
        }
    }
}

extension HeroDetailScreen: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let denominator: CGFloat = 54
        let offset = scrollView.contentOffset.y
        let alpha = min(1, offset / denominator)
        self.translucentBackDrop.frame.origin.y = min(0, -offset)
        self.setNavbar(backgroundColorAlpha: alpha)
    }
}
