//
//  ViewController.swift
//  TourOfHeroes
//
//  Created by Nayanda Haberty (ID) on 21/08/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import UIKit

import NamadaLayout

class CollectionScreen: UIViewController {
    
    lazy var collectionLayout: UICollectionViewFlowLayout = .init()
    lazy var collectionView: UICollectionView = .init(
        frame: .zero,
        collectionViewLayout: collectionLayout
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutView()
    }
    
    func layoutView() {
        makeLayout { vcLayout in
            vcLayout.put(collectionView) { collectionLayout in
                collectionLayout.fillParent()
            }
        }
    }
}
