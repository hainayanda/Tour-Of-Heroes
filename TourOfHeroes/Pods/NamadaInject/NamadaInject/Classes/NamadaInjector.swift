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
        let provider: Provider
        switch rules {
        case .furthestType:
            provider = try getFurthestProviderIfNoMatch(of: anyType)
        default:
            provider = try getNearestProviderIfNoMatch(of: anyType)
        }
        guard let instance: T = provider.getInstance() as? T else {
            throw NamadaInjectionError(description: "Instance from provider is not compatible with \(T.self)")
        }
        return instance
    }
    
    func getNearestProviderIfNoMatch<T>(of anyType: T.Type) throws -> Provider {
        var nearest: Provider?
        for provider in providers where provider.isProvider(of: T.self) {
            if provider.isSameType(of: anyType) {
                return provider
            }
            if let found = nearest, provider.canBeProvided(by: found) {
                nearest = provider
            } else if nearest == nil {
                nearest = provider
            }
        }
        guard let provider = nearest else {
            throw NamadaInjectionError(description: "No compatible provider for \(T.self)")
        }
        return provider
    }
    
    func getFurthestProviderIfNoMatch<T>(of anyType: T.Type) throws -> Provider {
        var furthest: Provider?
        for provider in providers where provider.isProvider(of: T.self) {
            if provider.isSameType(of: anyType) {
                return provider
            }
            if let found = furthest, found.canBeProvided(by: provider) {
                furthest = provider
            } else if furthest == nil {
                furthest = provider
            }
        }
        guard let provider = furthest else {
            throw NamadaInjectionError(description: "No compatible provider for \(T.self)")
        }
        return provider
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
