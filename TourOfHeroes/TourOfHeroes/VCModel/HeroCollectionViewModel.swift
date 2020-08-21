//
//  HeroCollectionViewModel.swift
//  TourOfHeroes
//
//  Created by Nayanda Haberty (ID) on 21/08/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import UIKit
import NamadaLayout

class HeroCollectionViewModel: ViewModel<CollectionScreen> {
    
    var heroRepository: HeroRepository = .init()
    
    override func bind(with view: CollectionScreen) {
        
    }
}
