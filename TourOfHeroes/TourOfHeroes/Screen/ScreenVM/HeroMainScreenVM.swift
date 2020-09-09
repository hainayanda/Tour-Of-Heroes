//
//  HeroMainScreenVM.swift
//  TourOfHeroes
//
//  Created by Nayanda Haberty (ID) on 21/08/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import UIKit
import NamadaLayout
import NamadaInject

class HeroMainScreenVM: ViewModel<HeroCollectionScreen> {
    
    @ObservableState var heroes: [HeroCollection] = []
    @ObservableState var loading: Bool = true
    @ObservableState var error: Error?
    @ObservableState var selectedAttrIndex: Int = 0
    
    var selectedAttribute: String? {
        heroes[safe: selectedAttrIndex]?.primaryAttribute
    }
    var selectedHeroes: [Hero] {
        heroes[safe: selectedAttrIndex]?.heroes ?? []
    }
    
    @Injected var heroRepository: HeroRepositoryManager
    @Injected var heroRouter: HeroRouter
    
    override func didApplying(_ view: HeroCollectionScreen) {
        reloadHeroes()
    }
    
    override func bind(with view: HeroCollectionScreen) {
        super.bind(with: view)
        $heroes.observe(observer: self)
            .didSet { model, changes in
                model.selectedAttrIndex = 0
        }
        $loading.observe(observer: self)
            .didSet { model, changes in
                guard let collection = model.view?.collection else { return }
                guard changes.new else {
                    collection.isScrollEnabled = true
                    collection.alwaysBounceVertical = true
                    collection.isSkeletonable = false
                    return
                }
                collection.isScrollEnabled = false
                collection.alwaysBounceVertical = false
                collection.isSkeletonable = true
                collection.cells = .duplicate(of: CollectionSkeletonCell.Model(), count: 12)
        }
        $error.observe(observer: self)
            .delayMultipleSetTrigger(by: .standard)
            .didSet { model, changes in
                guard let screen = model.view, let error = changes.new else { return }
                screen.showToast(message: error.localizedDescription)
        }
        $selectedAttrIndex.observe(observer: self)
            .didSet { model, changes in
                model.reloadCell()
        }
    }
    
    func reloadHeroes() {
        self.loading = true
        heroRepository.getAllHero().then(
            run: { [weak self] heroes in
                guard let self = self else { return }
                self.loading = false
                self.heroes = self.group(heroes: heroes)
                self.view?.refreshControl.endRefreshing()
            }, whenFailed: { [weak self] error in
                guard let self = self else { return }
                self.loading = false
                self.error = error
                self.view?.refreshControl.endRefreshing()
        })
    }
    
    func reloadCell() {
        guard let screen = self.view else { return }
        screen.collection.collectionViewLayout.invalidateLayout()
        screen.collection.sections = constructCell(from:  self.heroes, selectedAttribute: self.selectedAttribute)
    }
    
    func constructCell(from heroes: [HeroCollection], selectedAttribute: String?) -> [UICollectionView.Section] {
        let builder = CollectionCellBuilder(section: .init(identifier: "hero_attributes"))
            .next(type: HeroAttributeCellVM.self, from: heroes) { cellVM, hero in
                let selected = hero.primaryAttribute == selectedAttribute
                cellVM.cellIdentifier = "\(hero.heroes.first?.primaryAttr ?? .randomString())_\(selected)"
                cellVM.imageConvertible = hero.heroes.first?.imageURL
                cellVM.primaryAttr = hero.primaryAttribute
                cellVM.selected = selected
        }
        guard let selected = selectedAttribute,
            let selectedHeroes = heroes.first(where: { $0.primaryAttribute == selected }) else {
                return builder.build()
        }
        let header: NavigatableTitledHeader.Model = build {
            $0.cellIdentifier = "attribute_header_\(selectedHeroes.primaryAttribute)"
            $0.title = selectedHeroes.primaryAttribute
            $0.desc = selectedHeroes.attributeDescription
            $0.shouldNavigate = { [weak self] _ in
                self?.goToPage(for: selectedHeroes)
            }
        }
        return builder.nextSection(
            UICollectionView.SupplementedSection(
                header: header,
                identifier: "heroes_\(header.cellIdentifier)"
            )
        ).next(type: HeroCellVM.self, from: Array(selectedHeroes.heroes.prefix(16))) { cellVM, hero in
            cellVM.cellIdentifier = hero.id
            cellVM.hero = hero
        }.build()
    }
    
    func group(heroes: [Hero]) -> [HeroCollection] {
        var collections: [HeroCollection] = []
        let sortedHeroes = heroes.sorted {
            $0.primaryAttributes < $1.primaryAttributes
        }
        var currentCollection: HeroCollection?
        for hero in sortedHeroes {
            guard let collection = currentCollection else {
                currentCollection = newCollection(hero, &collections)
                continue
            }
            guard collection.primaryAttribute == hero.primaryAttributes else {
                collection.heroes = collection.heroes.sorted { $0.proPick > $1.proPick }
                currentCollection = newCollection(hero, &collections)
                continue
            }
            collection.heroes.append(hero)
        }
        if let collection = currentCollection {
            collection.heroes = collection.heroes.sorted {
                if collection.primaryAttribute == "Agility" {
                    return $0.moveSpeed > $1.moveSpeed
                } else if collection.primaryAttribute == "Strength" {
                    return $0.baseStr > $1.baseStr
                } else if collection.primaryAttribute == "Inteligence" {
                    return $0.baseInt > $1.baseInt
                } else {
                    return $0.proPick > $1.proPick
                }
            }
        }
        return collections
    }
    
    private func newCollection(_ hero: Hero, _ collections: inout [HeroCollection]) -> HeroCollection {
        let collection: HeroCollection = .init(
            attribute: hero.primaryAttributes,
            description: hero.primaryAttributesDescription
        )
        collection.heroes.append(hero)
        collections.append(collection)
        return collection
    }
    
}

// Mark: Action

extension HeroMainScreenVM: HeroCollectionScreenObserver {
    func heroCollectionScreenWillAppear(_ screen: HeroCollectionScreen) {
        screen.preLayoutNavigation()
        screen.layoutNavigation {
            $0.title = "Heroes"
            $0.rightButtonAction = { [weak screen] _ in
                guard let screen = screen else { return }
                screen.showToast(message: "Not implemented yet")
            }
            $0.rightButtonText = "Search"
        }
    }
    func heroMainScreenLayouted(_ screen: HeroCollectionScreen) {
        apply(to: screen)
    }
    
    func heroCollectionScreen(_ screen: HeroCollectionScreen, didTapCellAt indexPath: IndexPath) {
        guard indexPath.section == 0 else {
            if let selectedHero = selectedHeroes[safe: indexPath.item] {
                goToPage(for: selectedHero)
            }
            return
        }
        selectedAttrIndex = indexPath.item
    }
    
    func heroCollectionScreen(_ screen: HeroCollectionScreen, haveHeaderSectionAt section: Int) -> Bool {
        section == 1
    }
    
    func heroCollectionScreen(_ screen: HeroCollectionScreen, heightOf section: Int) -> CGFloat {
        .x160
    }
    
    func heroCollectionScreen(_ screen: HeroCollectionScreen, didPullToRefresh refreshControl: UIRefreshControl) {
        reloadHeroes()
    }
    
    func goToPage(for hero: Hero) {
        guard let view = view else { return }
        heroRouter.routeToHeroDetail(from: view, for: hero, and: selectedHeroes)
    }
    
    func goToPage(for heroes: HeroCollection) {
        guard let view = view else { return }
        heroRouter.routeToHeroCollection(from: view, for: heroes)
    }
}

public class HeroCollection: Equatable {
    var primaryAttribute: String
    var attributeDescription: String
    var heroes: [Hero] = []
    
    init(attribute: String, description: String) {
        self.primaryAttribute = attribute
        self.attributeDescription = description
    }
    
    public static func == (lhs: HeroCollection, rhs: HeroCollection) -> Bool {
        lhs.primaryAttribute == rhs.primaryAttribute
            && lhs.attributeDescription == rhs.attributeDescription
            && lhs.heroes == rhs.heroes
    }
}
