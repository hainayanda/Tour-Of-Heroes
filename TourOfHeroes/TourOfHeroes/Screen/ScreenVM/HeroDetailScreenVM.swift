//
//  HeroDetailScreenVM.swift
//  TourOfHeroes
//
//  Created by Nayanda Haberty (ID) on 24/08/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import NamadaLayout
import UIKit

class HeroDetailScreenVM: ViewModel<HeroDetailScreen> {
    
    @ObservableState var backDrop: ImageConvertible?
    @ObservableState var hero: Hero?
    var similarHeroes: [Hero] = []
    
    lazy var heroRouter: HeroRouter = ConcreteHeroRouter.shared
    
    override func bind(with view: HeroDetailScreen) {
        super.bind(with: view)
        $hero.observe(observer: self).didSet { model, changes in
            model.backDrop = changes.new?.imageURL
            model.view?.tableView.sections = model.constructCells(from: changes.new, andSimilar: model.similarHeroes)
        }
        $backDrop.observe(observer: self).didSet { model, changes in
            view.translucentBackDrop.imageConvertible = changes.new
        }
    }
    
    func constructCells(from hero: Hero?, andSimilar similarHeroes: [Hero]) -> [UITableView.Section] {
        guard let hero = hero else {
            view?.showToast(message: "No Hero Data")
            return []
        }
        return TableCellBuilder(section: .init(identifier: "single_section"))
            .next(type: HeroHeaderCell.Model.self, from: [hero]) {
                $0.hero = $1
        }.next(type: HeroStatusCell.Model.self, from: [hero]) {
            $0.hero = $1
        }.next(type: RoleCell.Model.self, from: [hero]) {
            $0.roles = Array($1.roles)
        }.next(type: SimilarHeroCell.Model.self, from: [similarHeroes]) {
            let similarHero: [Hero] = $1
                .prefix(4)
                .filter { $0.id != hero.id }
                .prefix(3)
                .compactMap { $0 }
            $0.hero1 = similarHero[safe: 0]
            $0.hero2 = similarHero[safe: 1]
            $0.hero3 = similarHero[safe: 2]
            $0.didTapHero = { [weak self] hero in
                self?.didTap(hero: hero)
            }
        }.build()
    }
    
    func didTap(hero: Hero) {
        guard let view = view else { return }
        heroRouter.routeToHeroDetail(from: view, for: hero, and: similarHeroes)
    }
}
