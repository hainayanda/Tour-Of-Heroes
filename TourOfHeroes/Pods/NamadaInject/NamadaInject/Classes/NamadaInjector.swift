//
//  NamadaInjector.swift
//  NamadaInject
//
//  Created by Nayanda Haberty (ID) on 01/09/20.
//

import Foundation

/// Injector class
public class NamadaInjector {
    
    /// shared instance of NamadaInjector
    public static var shared: NamadaInjector = .init()
    
    var providers: [Provider] = []
    
    /// Static function to provide assosiated dependency for some Type
    /// - Parameters:
    ///   - anyType: Type of instance
    ///   - option: Option of how to provide the dependency
    ///   - provider: The provider
    public static func provide<T>(for anyType: T.Type, option: NamadaInjectionOption = .singleton,_ provider: @escaping @autoclosure () -> T) {
        shared.providers.removeAll { $0.isSameType(of: anyType) }
        shared.providers.append(NamadaProvider(option: option, provider))
    }
    
    /// Function to provide assosiated dependency for some Type
    /// - Parameters:
    ///   - anyType: Type of instance
    ///   - option: Option of how to provide the dependency
    ///   - provider: The provider
    public func provide<T>(for anyType: T.Type, option: NamadaInjectionOption = .singleton,_ provider: @escaping @autoclosure () -> T) {
        providers.removeAll { $0.isSameType(of: anyType) }
        providers.append(NamadaProvider(option: option, provider))
    }
    
    func getInstance<T>(of anyType: T.Type, ifNoMatchUse rules: InjectionRules = .nearestType) throws -> T {
        let providers: [Provider]
        switch rules {
        case .furthestType:
            providers = try getFurthestIfNoMatchOrPotentials(of: anyType)
        default:
            providers = try getNearestIfNoMatchOrPotentials(of: anyType)
        }
        for provider in providers {
            guard let instance: T = provider.getInstance() as? T else {
                continue
            }
            return instance
        }
        throw NamadaInjectionError(description: "No compatible provider for \(T.self)")
    }
    
    func getNearestIfNoMatchOrPotentials<T>(of anyType: T.Type) throws -> [Provider] {
        var potentialProviders: [Provider] = []
        var nearest: Provider?
        for provider in providers {
            guard provider.isProvider(of: T.self) else {
                if provider.isPotentialProvider(of: T.self) {
                    potentialProviders.append(provider)
                }
                continue
            }
            if provider.isSameType(of: anyType) {
                return [provider]
            }
            if let found = nearest, provider.canBeProvided(by: found) {
                nearest = provider
            } else if nearest == nil {
                nearest = provider
            }
        }
        guard let provider = nearest else {
            return potentialProviders.sorted { $1.canBeProvided(by: $0) }
        }
        return [provider]
    }
    
    func getFurthestIfNoMatchOrPotentials<T>(of anyType: T.Type) throws -> [Provider] {
        var potentialProviders: [Provider] = []
        var furthest: Provider?
        for provider in providers {
            guard provider.isProvider(of: T.self) else {
                if provider.isPotentialProvider(of: T.self) {
                    potentialProviders.append(provider)
                }
                continue
            }
            if provider.isSameType(of: anyType) {
                return [provider]
            }
            if let found = furthest, found.canBeProvided(by: provider) {
                furthest = provider
            } else if furthest == nil {
                furthest = provider
            }
        }
        guard let provider = furthest else {
            return potentialProviders.sorted { $0.canBeProvided(by: $1) }
        }
        return [provider]
    }
}

@propertyWrapper
public struct Injected<T> {
    public lazy var wrappedValue: T = inject(ifNoMatchUse: rules)
    let rules: InjectionRules
    public init(ifNoMatchUse rules: InjectionRules = .nearestType) {
        self.rules = rules
    }
}
