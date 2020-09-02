//
//  ObservableView.swift
//  NamadaLayout
//
//  Created by Nayanda Haberty (ID) on 03/09/20.
//

import Foundation

extension ObservableView where Self: NSObject {
    public var observer: Observer? {
        bindedModel() as? Observer
    }
}

extension ViewModel: ViewModelObserver {
    public func viewDidLayouted(_ view: Any) {
        guard let view = view as? View else { return }
        apply(to: view)
    }
}
