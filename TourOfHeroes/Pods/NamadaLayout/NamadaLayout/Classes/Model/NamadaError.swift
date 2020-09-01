//
//  NamadaError.swift
//  NamadaLayout
//
//  Created by Nayanda Haberty (ID) on 27/08/20.
//

import Foundation

public struct NamadaError: Error {
    
    private var description: String
    public var localizedDescription: String { description }
    
    init(description: String) {
        self.description = description
    }
}
