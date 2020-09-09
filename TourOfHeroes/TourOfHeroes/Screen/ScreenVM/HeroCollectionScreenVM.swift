//
//  HeroCollectionScreenVM.swift
//  TourOfHeroes
//
//  Created by Nayanda Haberty (ID) on 09/09/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import UIKit
import NamadaLayout
import NamadaInject

class HeroCollectionScreenVM: ViewModel<HeroCollectionScreen> {
    @ObservableState var navigationTitle: String?
    @ObservableState var heroes: HeroCollection?
    
    @Injected var heroRouter: HeroRouter
    
    override func bind(with view: HeroCollectionScreen) {
        super.bind(with: view)
        $heroes.observe(observer: self).didSet { model, changes in
            guard let screen = model.view, let newValue = changes.new else {
                model.view?.collection.sections = []
                return
            }
            model.navigationTitle = newValue.primaryAttribute
            screen.collection.sections = model.constructCell(from: newValue)
        }
        $navigationTitle.observe(observer: self).didSet { model, changes in
            guard let screen = model.view else { return }
            screen.layoutNavigation {
                $0.leftButtonIcon = UIImage(systemName: "chevron.left")
                $0.title = model.navigationTitle
            }
        }
    }
    
    func constructCell(from heroes: HeroCollection) -> [UICollectionView.Section] {
        CollectionCellBuilder(section: .init(identifier: "heroes"))
            .next(type: HeroCellVM.self, from: heroes.heroes) { cellVM, hero in
                cellVM.cellIdentifier = hero.id
                cellVM.hero = hero
        }.build()
    }
}
extension HeroCollectionScreenVM: HeroCollectionScreenObserver {
    func heroCollectionScreenWillAppear(_ screen: HeroCollectionScreen) {
        screen.preLayoutNavigation()
        screen.layoutNavigation {
            $0.leftButtonIcon = UIImage(systemName: "chevron.left")
            $0.title = navigationTitle
        }
    }
    func heroMainScreenLayouted(_ screen: HeroCollectionScreen) {
        apply(to: screen)
    }
    
    func heroCollectionScreen(_ screen: HeroCollectionScreen, didTapCellAt indexPath: IndexPath) {
        guard let hero = heroes?.heroes[safe: indexPath.item] else { return }
        goToPage(for: hero)
    }
    
    func heroCollectionScreen(_ screen: HeroCollectionScreen, haveHeaderSectionAt section: Int) -> Bool { false }
    
    func heroCollectionScreen(_ screen: HeroCollectionScreen, heightOf section: Int) -> CGFloat { .zero }
    
    func heroCollectionScreen(_ screen: HeroCollectionScreen, didPullToRefresh refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
    }
    
    func goToPage(for hero: Hero) {
        guard let view = view else { return }
        heroRouter.routeToHeroDetail(from: view, for: hero, and: heroes?.heroes ?? [])
    }
}
