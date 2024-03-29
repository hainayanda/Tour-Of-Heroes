# NamadaInject

NamadaInject is a simple dependency injection library for Swift

[![CI Status](https://img.shields.io/travis/nayanda/NamadaInject.svg?style=flat)](https://travis-ci.org/nayanda/NamadaInject)
[![Version](https://img.shields.io/cocoapods/v/NamadaInject.svg?style=flat)](https://cocoapods.org/pods/NamadaInject)
[![License](https://img.shields.io/cocoapods/l/NamadaInject.svg?style=flat)](https://cocoapods.org/pods/NamadaInject)
[![Platform](https://img.shields.io/cocoapods/p/NamadaInject.svg?style=flat)](https://cocoapods.org/pods/NamadaInject)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

NamadaInject is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'NamadaInject'
```

## Author

nayanda, nayanda1@outlook.com

## License

NamadaInject is available under the MIT license. See the LICENSE file for more info.

## Basic Usage

NamadaInject is very easy to use and straightforward, all you need to do is provide some provider for dependency:

```swift
NamadaInjector.provide(for: Dependency.self, SomeDependency())
```

and then use it in some of your class using property wrapper or using global function

```swift
class InjectedByPropertyWrapper {
    @Injected var dependency: Dependency
    
    ...
    ...
}

class InjectedByInit {
    var dependency: Dependency
    
    init(dependency: Dependency = inject()) {
        self.dependency = dependency
    }
}
```

the provider is autoClosure type, so you can do something like this:

```swift
NamadaInjector.provide(for: Dependency.self) {
    dependency: SomeDependency = .init()
    dependency.doSomeSetup()
    return dependency
}
```

the provider automatically just create one instance only. If you want the provider to create new instance for every injection, you can just pass option:

```swift
NamadaInjector.provide(for: Dependency.self, option: .alwaysNew, SomeDependency())
```

or if you want to set it to singleton explicitly:

```swift
NamadaInjector.provide(for: Dependency.self, option: .singleton, SomeDependency())
```

Don't forget that it will throw uncatchable Error if the provider is not registered yet. If you want to catch the error manually, just use `tryInject` instead:

```swift
class InjectedByInit {
    var dependency: Dependency
    
    init(dependency: Dependency? = nil) {
        do {
            self.dependency = dependency ?? try tryInject()
        } catch {
            self.dependency = DefaultDependency()
        }
    }
}
```

## No Match Rules

If the NamadaInjector did not found exact type registered but multiple compatible type, it will use the nearest one to the requested type.

```swift
protocol Dependency {
    ...
    ...
}

class MyDependency: Dependency {
    ...
    ...
}

class YourDependency: MyDependency {
    ...
    ...
}

class OurDependency: YourDependency {
    ...
    ...
}
```

and you register your dependency like this:

```swift
NamadaInjector.provide(for: Dependency.self, MyDependency())
NamadaInjector.provide(for: YourDependency.self, YourDependency())
NamadaInjector.provide(for: OurDependency.self, OurDependency())
```
then the result will be:

```swift
class InjectedByPropertyWrapper {
    @Injected var thisWillBeMyDependency: Dependency
    @Injected var thisWillBeYourDependency: MyDependency
    @Injected var thisWillBeYourDependencyToo: YourDependency
    @Injected var thisWillBeOurDependency: OurDependency
    
    ...
    ...
}


class InjectedByInit {
    var thisWillBeMyDependency: Dependency
    var thisWillBeYourDependency: MyDependency
    var thisWillBeYourDependencyToo: YourDependency
    var thisWillBeOurDependency: OurDependency
    
    init(thisWillBeMyDependency: Dependency = inject(),
         thisWillBeYourDependency: MyDependency = inject(),
         thisWillBeYourDependencyToo: YourDependency = inject(),
         thisWillBeOurDependency: OurDependency = inject()) {
        self.thisWillBeMyDependency = thisWillBeMyDependency
        self.thisWillBeYourDependency = thisWillBeYourDependency
        self.thisWillBeYourDependencyToo = thisWillBeYourDependencyToo
        self.thisWillBeOurDependency = thisWillBeOurDependency
    }
}
```

If you prefer the furthest type registered, then you can pass rules into propertyWrapper or inject function like this:

```swift
class InjectedByPropertyWrapper {
    @Injected(ifNoMatchUse: .furthestType) 
    var thisWillBeMyDependency: Dependency
    
    @Injected(ifNoMatchUse: .furthestType) 
    var thisWillBeOurDependency: MyDependency
    
    @Injected(ifNoMatchUse: .furthestType) 
    var thisWillBeYourDependency: YourDependency
    
    @Injected(ifNoMatchUse: .furthestType) 
    var thisWillBeOurDependencyToo: OurDependency
    
    ...
    ...
}


class InjectedByInit {
    var thisWillBeMyDependency: Dependency
    var thisWillBeOurDependency: MyDependency
    var thisWillBeYourDependency: YourDependency
    var thisWillBeOurDependencyToo: OurDependency
    
    init(thisWillBeMyDependency: Dependency = inject(ifNoMatchUse: .furthestType),
         thisWillBeOurDependency: MyDependency = inject(ifNoMatchUse: .furthestType),
         thisWillBeYourDependency: YourDependency = inject(ifNoMatchUse: .furthestType),
         thisWillBeOurDependencyToo: OurDependency = inject(ifNoMatchUse: .furthestType)) {
        self.thisWillBeMyDependency = thisWillBeMyDependency
        self.thisWillBeOurDependency = thisWillBeOurDependency
        self.thisWillBeYourDependency = thisWillBeYourDependency
        self.thisWillBeOurDependencyToo = thisWillBeOurDependencyToo
    }
}
```

## Contribute

You know how, just clone and do pull request
