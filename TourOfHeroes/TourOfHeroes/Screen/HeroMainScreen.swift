//
//  CollectionScreen.swift
//  TourOfHeroes
//
//  Created by Nayanda Haberty (ID) on 23/08/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import UIKit
import NamadaLayout

protocol HeroMainScreenObserver {
    func heroMainScreenDidTapSearch(_ screen: HeroMainScreen)
    func heroMainScreen(_ screen: HeroMainScreen, didTapCellAt indexPath: IndexPath)
    func heroMainScreen(_ screen: HeroMainScreen, haveSectionAt section: Int) -> Bool
    func heroMainScreen(_ screen: HeroMainScreen, heightOf section: Int) -> CGFloat
    func heroMainScreen(_ screen: HeroMainScreen, didPullToRefresh refreshControl: UIRefreshControl)
}

class HeroMainScreen: UIViewController, ObservableView {
    typealias Observer = HeroMainScreenObserver
    
    // MARK: View
    lazy var collectionLayout: UICollectionViewFlowLayout = .init()
    lazy var collection: UICollectionView = .init(frame: .zero, collectionViewLayout: collectionLayout)
    lazy var refreshControl: UIRefreshControl = .init()
    
    @objc func didPullToRefresh() {
        observer?.heroMainScreen(self, didPullToRefresh: refreshControl)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollection()
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        view.backgroundColor = .white
        layoutView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        preLayoutNavigation()
        layoutNavigation {
            $0.title = "Heroes"
            $0.rightButtonAction = { [weak self] _ in
                guard let self = self else { return }
                self.observer?.heroMainScreenDidTapSearch(self)
            }
            $0.rightButtonText = "Search"
        }
    }
    
    func layoutView() {
        layoutContent { content in
            content.put(collection)
                .edges(.equal, to: .safeArea)
        }
    }
    
    func setupCollection() {
        collection.alwaysBounceVertical = true
        collection.isPrefetchingEnabled = true
        collection.isScrollEnabled = true
        collection.allowsSelection = true
        collection.backgroundColor = .white
        collection.contentInset = .init(vertical: .x4, horizontal: .x8)
        collection.delegate = self
        collection.refreshControl = refreshControl
        collection.model.reloadStrategy = .reloadArangementDifferences
        collectionLayout.minimumInteritemSpacing = .zero
        collectionLayout.minimumLineSpacing = .zero
        collectionLayout.scrollDirection = .vertical
        collectionLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        collectionLayout.sectionHeadersPinToVisibleBounds = true
    }
}

extension HeroMainScreen: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard let observer = self.observer else { return .zero }
        return !observer.heroMainScreen(self, haveSectionAt: section) ?
            .zero
            : .init(
                width: collectionView.frame.width,
                height: observer.heroMainScreen(self, heightOf: section)
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        observer?.heroMainScreen(self, didTapCellAt: indexPath)
    }
}
