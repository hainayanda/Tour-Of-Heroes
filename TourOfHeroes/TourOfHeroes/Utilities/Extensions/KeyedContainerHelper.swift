//
//  KeyedContainerHelper.swift
//  TourOfHeroes
//
//  Created by Nayanda Haberty (ID) on 24/08/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation

extension KeyedDecodingContainer {
    func safeDecode(_ key: K) -> String {
        (try? decodeIfPresent(String.self, forKey: key)) ?? ""
    }
    func safeDecode(_ key: K) -> [String] {
        (try? decodeIfPresent([String].self, forKey: key)) ?? []
    }
    func safeDecode(_ key: K) -> Int {
        (try? decodeIfPresent(Int.self, forKey: key)) ?? 0
    }
    func safeDecode(_ key: K) -> Float {
        (try? decodeIfPresent(Float.self, forKey: key)) ?? 0
    }
    func safeDecode(_ key: K) -> Bool {
        (try? decodeIfPresent(Bool.self, forKey: key)) ?? false
    }
}
