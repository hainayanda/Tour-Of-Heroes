//
//  HeroCollectionScreen.swift
//  TourOfHeroes
//
//  Created by Nayanda Haberty (ID) on 23/08/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import UIKit
import NamadaLayout

protocol HeroCollectionScreenObserver: ViewModelObserver {
    func heroCollectionScreenWillAppear(_ screen: HeroCollectionScreen)
    func heroCollectionScreen(_ screen: HeroCollectionScreen, didTapCellAt indexPath: IndexPath)
    func heroCollectionScreen(_ screen: HeroCollectionScreen, haveHeaderSectionAt section: Int) -> Bool
    func heroCollectionScreen(_ screen: HeroCollectionScreen, heightOf section: Int) -> CGFloat
    func heroCollectionScreen(_ screen: HeroCollectionScreen, didPullToRefresh refreshControl: UIRefreshControl)
}

class HeroCollectionScreen: UIViewController, ObservableView {
    typealias Observer = HeroCollectionScreenObserver
    
    // MARK: View
    lazy var collectionLayout: UICollectionViewFlowLayout = .init()
    lazy var collection: UICollectionView = .init(frame: .zero, collectionViewLayout: collectionLayout)
    lazy var refreshControl: UIRefreshControl = .init()
    
    @objc func didPullToRefresh() {
        observer?.heroCollectionScreen(self, didPullToRefresh: refreshControl)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollection()
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        view.backgroundColor = .white
        layoutView()
        observer?.viewDidLayouted(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        observer?.heroCollectionScreenWillAppear(self)
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

extension HeroCollectionScreen: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard let observer = self.observer else { return .zero }
        return !observer.heroCollectionScreen(self, haveHeaderSectionAt: section) ?
            .zero
            : .init(
                width: collectionView.frame.width,
                height: observer.heroCollectionScreen(self, heightOf: section)
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        observer?.heroCollectionScreen(self, didTapCellAt: indexPath)
    }
}
