//
//  Model.swift
//  NamadaInject
//
//  Created by Nayanda Haberty (ID) on 02/09/20.
//

import Foundation

protocol Provider {
    func canBeProvided(by otherProvider: Provider) -> Bool
    func isProvider<TypeToProvide>(of anyType: TypeToProvide.Type) -> Bool
    func isSameType(of anyType: Any.Type) -> Bool
    func getInstance() -> Any
}

class NamadaProvider<T>: Provider {
    var provider: () -> T
    lazy var providedInstance: T = provider()
    var option: NamadaInjectionOption
    init(option: NamadaInjectionOption, _ provider: @escaping () -> T) {
        self.provider = provider
        self.option = option
    }
    
    func canBeProvided(by otherProvider: Provider) -> Bool {
        otherProvider.isProvider(of: T.self)
    }
    
    func isProvider<TypeToProvide>(of anyType: TypeToProvide.Type) -> Bool {
        T.self is TypeToProvide.Type
    }
    
    func isSameType(of anyType: Any.Type) -> Bool {
        anyType == T.self
    }
    
    func getInstance() -> Any {
        switch option {
        case .singleton:
            return providedInstance
        default:
            return provider()
        }
    }
}

public struct NamadaInjectionError: Error {
    
    private var description: String
    public var localizedDescription: String { description }
    
    init(description: String) {
        self.description = description
    }
}

/// Injection option
/// singleton means the instance is only created once
/// alwaysNew means the instance is created everytime needed
public enum NamadaInjectionOption {
    case singleton
    case alwaysNew
}

/// Injection rules
/// nearestType which means return nearest type requested
/// furthestType which means return furthest type requested
public enum InjectionRules {
    case nearestType
    case furthestType
}
