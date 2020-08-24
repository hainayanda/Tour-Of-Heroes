# NamadaLayout

NamadaLayout is a DSL framework for Swift to make Auto layout easier.

[![CI Status](https://img.shields.io/travis/nayanda/NamadaLayout.svg?style=flat)](https://travis-ci.org/nayanda/NamadaLayout)
[![Version](https://img.shields.io/cocoapods/v/NamadaLayout.svg?style=flat)](https://cocoapods.org/pods/NamadaLayout)
[![License](https://img.shields.io/cocoapods/l/NamadaLayout.svg?style=flat)](https://cocoapods.org/pods/NamadaLayout)
[![Platform](https://img.shields.io/cocoapods/p/NamadaLayout.svg?style=flat)](https://cocoapods.org/pods/NamadaLayout)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

NamadaLayout is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'NamadaLayout', '1.1.2-RC'
```

## Author

Nayanda Haberty, nayanda1@outlook.com

## License

NamadaLayout is available under the MIT license. See the LICENSE file for more info.

## Usage

### Basic Usage

Here's some example of layouting using NamadaLayout which I think simple enough for anyone to understand how to use it.

```swift
class ViewController: UIViewController {
    private var clickCount: Int = 0
    
    lazy var bottomButton: UIButton = build {
        $0.didClicked { [weak self] _ in
            self?.clickCount += 1
            self?.topLabel.text = "click count: \(self?.clickCount ?? 0)"
        }
        $0.setTitle("Bottom Button", for: .normal)
        $0.setTitleColor(.black, for: .normal)
    }
    lazy var topLabel: UILabel = build {
        $0.text = "TOP LABEL"
        $0.textColor = .black
        $0.textAlignment = .center
    }
    lazy var middleLabel: UILabel = build {
        $0.text = "MIDDLE LABEL"
        $0.textColor = .black
        $0.textAlignment = .center
    }
    lazy var searchBar: UISearchBar = build {
        $0.placeholder = "placeholder"
    }
    
    @ViewState var topTitle: String?
    @ViewState var typedText: String?
    @ViewState var middleText: String?
    
    override func viewDidLoad() {
        super .viewDidLoad()
        layoutView()
        listen()
    }
    
    func layoutView() {
        makeLayout { vcLayout in
            vcLayout.put(bottomButton) { buttonLayout in
                buttonLayout.fixToSafeArea(.fullBottom, with: .init(inset: 18)).height.equal(with: 36)
            }
            vcLayout.put(searchBar) { searchLayout in
                searchLayout.fixToSafeArea(.fullTop)
            }.bind(\.text, with: $typedText)
            vcLayout.put(topLabel) { labelLayout in
                labelLayout.atBottom(of: searchBar, spacing: 18)
            }.bind(\.text, with: $topTitle)
            vcLayout.putVerticalStack { stackLayout in
                stackLayout.center.equalWithParent()
                stackLayout.top.distance(to: topLabel.layout.bottom, moreThan: 18, priority: .defaultLow)
                stackLayout.bottom.distance(to: bottomButton.layout.top, moreThan: 18, priority: .defaultLow)
                stackLayout.inSafeArea(.horizontal, moreThan: .init(inset: 18))
                
                stackLayout.putStacked(middleLabel).bind(\.text, with: $middleText)
                stackLayout.putStackedImage { logoLayout in
                    logoLayout.size(equalWith: .init(width: 90, height: 90))
                }.apply {
                    $0.image = #imageLiteral(resourceName: "anyImage")
                    $0.contentMode = .scaleAspectFit
                }
            }.apply {
                $0.alignment = .center
                $0.distribution = .fill
                $0.spacing = 9
            }
        }
    }
    
    func listen() {
        $topTitle.observe(observer: self).didSet { viewController, changes in
            viewController.middleLabel.text = "new: \(changes.new ?? "null"), old: \(changes.old ?? "null")"
        }
        $typedText.observe(observer: self).didSet { viewController, changes in
            guard let _ = changes.trigger.triggeringView else { return }
            viewController.topLabel.text = "typed: \(changes.new ?? "null")"
        }
    }
}
```
It will automatically put view as closure hierarchy, create all constraints inside the closure and activate it just after the closure finished on the UIThread. It will also bind view keypath into any property with same type with @ViewState attributes.

## Layouting

### Basic

There are four main function to create layout which is:
- `makeLayout(_ builder: (ViewLayout) -> Void)`
- `makeAndEditLayout(_ builder: (ViewLayout) -> Void)`
- `remakeLayout(_ builder: (ViewLayout) -> Void)`
- `makeLayoutCleanly(_ builder: (ViewLayout) -> Void)`
all the method are can be used in UIViewController and UIView.
The difference between those three is
- `makeLayout` is the faster one, since its just adding constraints without worrying about existing constraints. Its better when use just once on first load
- `makeAndEditLayout` will search for the duplicated constraints and edit them with new constraints or add new constraint if there's none.
- `remakeLayout` will remove all the constraints created by NamadaLayout and add a new one.
- `makeLayoutCleanly` will remove all existing child view from the layout which in effect will remove all constraints those child have

all the method will accept closure with `ViewLayout` parameter. Its the abstraction of the `UIView` layout in the context.

example:

```swift
```swift
class ViewController: UIViewController {
    ...
    ...
    override func viewDidLoad() {
        super.viewDidLoad()
        makeLayout { layout in
            layout.put(someView) { someLayout in
                ...
                ...
            }
            layout.put(someOtherView) { someOtherLayout in
                ...
                ...
                someOtherLayout.put(childView) {
                    ...
                    ...
                }
            }
        }
    }
}
```
The above code will add `someView` and `someOtheView` to the `UIViewController` view, `childView` to `someOtherView` and apply all created constraints in the closure.

```swift
```swift
class SomeCell: UITableViewCell {
    ...
    ...
    override func layoutSubViews() {
        super.layoutSubViews()
        makeLayout { layout in
            layout.put(someView) { someLayout in
                ...
                ...
            }
            layout.put(someOtherView) { someOtherLayout in
                ...
                ...
                someOtherLayout.put(childView) {
                    ...
                    ...
                }
            }
        }
    }
}
```
The above code will add `someView` and `someOtheView` to the `UITableView` `contentView`, `childView` to `someOtherView` and apply all created constraints in the closure. The same case will happen at `UICollectionViewCell` too

```swift
parentView.makeLayout { layout in
    layout.put(someView) { someLayout in
        ...
        ...
    }
    layout.put(someOtherView) { someOtherLayout in
        ...
        ...
        someOtherLayout.put(childView) {
            ...
            ...
        }
    }
}
```swift

```
The above code will add `someView` and `someOtheView` to the `parentView`, `childView` to `someOtherView` and apply all created constraints in the closure.

You can embed `UIViewController` too:
```swift
parentView.makeLayout { layout in
    layout.put(someViewController) { someVCLayout in
        ...
        ...
    }
}
```


### Position to other

To make constraints between two `UIView`, you can just do something like this:
```swift
makeLayout { layout in
    layout.put(someView) { someLayout in
        someLayout.top.equal(with: otherView.layout.top)
        someLayout.left.distance(to: otherView.layout.right, at: 18)
        someLayout.bottom.equal(with: otherView.layout.bottom, moreThan: 18)
        someLayout.right.distance(to: anyOtherView.layout.left, lessThan: 18)
        someLayout.center.equal(with: centeredView.layout.center)
    }
}
```
The above code is adding `someView` into layout and then creating this constraints:
- `someView` top is equal to `otherView` top
- `someView` left is equal to` otherView` right with spacing equal to 18
- `someView` bottom is have spacing to `otherView` bottom greater than or equal 18
- `someView` right is have spacing to `anyOtherView` left less than or equal 18
- `someView` center is equal to `centeredView` top

If you want to make view to parallel with other view at some position, you can just do this

```swift
makeLayout { layout in
    layout.put(someView) { someLayout in
        someLayout.atBottom(of: topView)
        someLayout.atLeft(of: leftView, spacing: 18)
        someLayout.atRight(of: rightView, moreThan: 18)
        someLayout.atBottom(of: bottomView, lessThan: 18)
    }
}
```
The above code is add `someView` into layout and then creating this constraints:
- `someView` is at the bottom of `topView`, which means, it's center x axis is same as `topView` center x axis
- `someView` is at the left of `leftView` with spacing  at 18, which means, it's center y axis is same as` leftView` center y axis
- `someView` is at the right of `rightView` with spacing greater than or equal 18, which means, it's center y axis is same as `rightView` center y axis
- `someView` is at the bottom of `bottomView` with spacing  less than or equal 18, which means, it's center x axis is same as `bottomView` center x axis

### Position in parent

Let's say you want to add tableView inside the `UIViewController` which fill the view. You can just do this:

```swift
makeLayout { layout in
    layout.put(tableView) { tableLayout in
        tableLayout.top.equalWithParent()
        tableLayout.bottom.equalWithParent()
        tableLayout.left.equalWithParent()
        tableLayout.right.equalWithParent()
    }
}
```

or even simpler:

```swift
makeLayout { layout in
    layout.put(tableView) { tableLayout in
        tableLayout.fillParent()
    }
}
```

or if you prefer constrainted to safe area

```swift
makeLayout { layout in
    layout.put(tableView) { tableLayout in
        tableLayout.top.equalWithSafeArea()
        tableLayout.bottom.equalWithSafeArea()
        tableLayout.left.equalWithSafeArea()
        tableLayout.right.equalWithSafeArea()
    }
}
```

in simpler code:

```swift
makeLayout { layout in
    layout.put(tableView) { tableLayout in
        tableLayout.fillSafeArea()
    }
}
```

if you want to add inset, then you can do this

```swift
makeLayout { layout in
    layout.put(tableView) { tableLayout in
        tableLayout.top.distanceToSafeArea(at: 18)
        tableLayout.bottom.distanceToSafeArea(at: 18)
        tableLayout.left.distanceToSafeArea(at: 18)
        tableLayout.right.distanceToSafeArea(at: 18)
    }
}
```

or in simpler code:

```swift
makeLayout { layout in
    layout.put(tableView) { tableLayout in
        tableLayout.fillSafeArea(with: .init(inset: 18))
    }
}
```

you can use `greater than or equal`  or  `less than or equal` too, like this: 

```swift
makeLayout { layout in
    layout.put(tableView) { tableLayout in
        tableLayout.top.distanceToSafeArea(lessThan: 18)
        tableLayout.bottom.distanceToSafeArea(moreThan: 18)
        tableLayout.left.distanceToParent(lessThan: 18)
        tableLayout.right.distanceToParent(moreThan: 18)
    }
}
```

### Dimension Constraints

To define dimension relation with other you can just do something like this:

```swift
makeLayout { layout in
    layout.put(someView) { someLayout in
        someLayout.height.equal(with: otherView.layout.height)
        someLayout.width.lessThan(otherView.layout.height)
        someLayout.height.moreThan(100)
        someLayout.widht.lessThan(100)
    }
}
```
The above code is add `someView` into layout and then creating this constraints:
- `someView` height is equal to `otherView` height
- `someView` width is less than or equal to` otherView` height
- `someView` height is greater than or equal 100
- `someView` width is less than or equal 100

### Priority

To define constraint priority, just pass `UILayoutPriority` at any method you want. If you don't pass priority, it will assign the priority using simple rules which is the first constraint will be have more priority than the second, and so on.

```swift
makeLayout { layout in
    layout.put(someView) { someLayout in
        someLayout.height.equal(with: otherView.layout.height, priority: .defaultHigh)
        someLayout.width.lessThan(otherView.layout.width, priority: .defaultLow)
        someLayout.height.moreThan(100, priority: .init(1))
        someLayout.widht.lessThan(100)
    }
}
```

### Delegate

There's a delegate which can passed when you create layout:

```swift
public protocol LayoutBuilderDelegate: class {
    func layoutBuilderNeedParent<Layout: LayoutBuilder>(_ layout: Layout) throws -> Layout?
    func layoutBuilderNeedViewController(_ layout: ViewLayout) throws -> UIViewController?
    func layoutBuilder<Layout: LayoutBuilder>(_ layout: Layout, relateWith sameLayout: Layout) throws
    func layoutBuilder<Layout: LayoutBuilder>(_ layout: Layout, onError error: LayoutError)
}
```

All the method are optional since all the default implementation are already defined in the extensions. The purpose of each methods are:
- `layoutBuilderNeedParent<Layout: LayoutBuilder>(_ layout: Layout) throws -> Layout?`
will be called when you call relation with parent, but your layout is have no parent (like in top view in UIViewController). The default implementation will be throw LayoutError
- `layoutBuilderNeedViewController(_ layout: ViewLayout) throws -> UIViewController?`
will be called when you embed UIViewController, but your layout have no UIViewController (like in UITableViewCell). The default implementation will be throw LayoutError
- `layoutBuilder<Layout: LayoutBuilder>(_ layout: Layout, relateWith sameLayout: Layout) throws`
will be called when you assign same anchor to be relate, like when you set view left to equal its own left. The default implementation will be throw LayoutError
- `layoutBuilder<Layout: LayoutBuilder>(_ layout: Layout, onError error: LayoutError)`
will be called when you there's any LayoutError when creating constraints.

You can pass the delegate like this: 

```swift
makeLayout(yourDelegate) { layout in
    layout.put(someView) { someLayout in
        ...
        ...
    }
}
```
`remakeLayout` and `makeAndEditLayout` can be accept delegate too.

## Molecule

You can create molecule using MoleculeLayout protocol:

```swift
class MoleculeView: UIView, MoleculeLayout {
    ...
    ...
    ...
    func layoutChild(_ thisLayout: ViewLayout) {
        thisLayout.put(someView) { someLayout in
            ...
            ...
        }
        thisLayout.put(someOtherView) { someOtherLayout in
            ...
            ...
            someOtherLayout.put(childView) {
                ...
                ...
            }
        }
    }
}
```

The layoutChild will be called if the `MoleculeView` is added to superView using `makeLayout`, `remakeLayout` or `makeAndEditLayout`

### Cell Molecule

You can create Cell (UITableViewCell or UICollectionViewCell) Molecule. Just extend CollectionCellLayoutable for UICollectionViewCell or TableCellLayoutable for UITableViewCell.

```swift
class MoleculeCell: TableCellLayoutable {
    ...
    ...
    
    override var layoutBehaviour: CellLayoutBehaviour { .remakeEveryLayout }
    
    override func layoutChild(_ thisLayout: ViewLayout) {
        thisLayout.put(someView) { someLayout in
            ...
            ...
        }
        thisLayout.put(someOtherView) { someOtherLayout in
            ...
            ...
            someOtherLayout.put(childView) {
                ...
                ...
            }
        }
    }
}
```

LayoutChild will run when the cell first layout, or depends on CellLayoutBehaviour if you override it. The behaviour are:
- `once` wich will ensure layoutChild only run once on the first layout
- `remakeEveryLayout` wich will remake layout every Cell layoutSubviews method is run or when Cell is reused
- `editEveryLayout` wich will make and edit layout every Cell layoutSubviews method is run or when Cell is reused
- `custom` which will automatically invoke shouldLayout(on:) method before layouting

If you're using custom CellBehaviour, you're mandatory should override `shouldLayout(on phase: CellLayouting) -> LayoutingStrategy`, otherwise it will throw fatal errror.

```swift
class MoleculeCell: TableCellLayoutable {
    ...
    ...
    
    override var layoutBehaviour: CellLayoutBehaviour { .custom }
    
    override func layoutChild(_ thisLayout: ViewLayout) {
        thisLayout.put(someView) { someLayout in
            ...
            ...
        }
        thisLayout.put(someOtherView) { someOtherLayout in
            ...
            ...
            someOtherLayout.put(childView) {
                ...
                ...
            }
        }
    }
    
    override func shouldLayout(on phase: CellLayouting) -> LayoutingStrategy {
        switch phase {
        case .reused:
            return .remakeLayout
        default:
            return .none
        }
    }
}
```

The CellLayouting phase are:
- `reused` which triggered when cell is in reuse state
- `needsLayoutSet` which triggered when cell setNeedsLayout is set
- `initial` which triggered on the initial creation of cell
- `none` which is triggered from layoutSubviews but from none of the above phases

and you can return the following LayoutStrategy:
- `makeAndEditLayout` which will layouting using makeAndEditLayout
- `remakeLayout` which will layouting using remakeLayout
- `makeLayout` which will layouting using makeLayout
- `makeLayoutCleanly` which will layouting using makeLayoutCleanly
- `none` which will not do any layout

If your `UITableView` or `UICollectionView` have custom calculated size, you can just override `calculatedCellSize(for collectionContentWidth: CGFloat) -> CGSize` for UICollectionViewCell and `calculatedCellHeight(for cellWidth: CGFloat) -> CGFloat` for UITableViewCell.

```swift
class MyCollectionCell: CollectionCellLayoutable {
    ...
    ...
    //default return value is CGSize.automatic
    override func calculatedCellSize(for collectionContentWidth: CGFloat) -> CGSize {
        let side: CGFloat = collectionContentWidth / 3
        return .init(width: side, height: side)
    }
    ...
    ...
}
```

or for UITableViewCell

```swift
class MyTableCell: TableCellLayoutable {
    ...
    ...
    //default return value is CGFloat.automatic
    override func calculatedCellHeight(for cellWidth: CGFloat) -> CGFloat {
        cellWidth / 3
    }
    ...
    ...
}
```

## Binding

To do binding, you need to create property with same type as View property you want to bind and add `@ViewState` attributes

```swift

@ViewState searchPhrase: String?

```

### Two way binding

Two way binding is binding when the property is changing it will apply the changes into View binded or vice versa. It will not work on read only View property.

Then you can bind it manually like this using projectedValue and keyPath:

```swift
$searchPhrase.bind(with: yourSearchBarToBind, \.text)

// or
$searchPhrase.map(from: yourSearchBarToBind, \.text)

// or
$searchPhrase.apply(into: yourSearchBarToBind, \.text)
```

the only difference between those methods are:
- `bind` which will only bind view with property
- `map` which will bind and get the current value of the view property into binded property
- `apply`  which will bind and apply the current value of the binded property into view property

and you can add binding observer:

```swift
$searchPhrase.bind(with: yourSearchBarToBind, \.text)
    .viewDidSet(then: { searchBar, changes in
        let newValue = changes.newValue
        let oldValue = changes.oldValue
        // do something when view changes
    }
).stateDidSet(then: { searchBar, changes in
        let newValue = changes.newValue
        let oldValue = changes.oldValue
        // do something when state changes
    }
)
```

The viewDidSet will run when view property is changing. The stateDidSet will run when property binded is changing

Or you can bind when layouting using `ViewApplicator`:

```swift
thisLayout.put(yourSearchBarToBind) { yourSearchBarToBindLayout in
    ...
    ...
}.bind(\.text, with: $searchPhrase)
```
or
```swift
thisLayout.put(yourSearchBarToBind) { yourSearchBarToBindLayout in
    ...
    ...
}.apply(\.text, with: $searchPhrase)
```
or
```swift
thisLayout.put(yourSearchBarToBind) { yourSearchBarToBindLayout in
    ...
    ...
}.map(\.text, with: $searchPhrase)
```

To add binding observer when layouting using `ViewApplicator` is like this:

```swift
thisLayout.put(yourSearchBarToBind) { yourSearchBarToBindLayout in
    ...
    ...
}.bind(\.text, with: $searchPhrase, stateDidSet: { searchBar, changes in
    let newValue = changes.newValue
    let oldValue = changes.oldValue
    // do something when state changes
}, viewDidSet: { searchBar, changes in
    let newValue = changes.newValue
    let oldValue = changes.oldValue
    // do something when view changes
})
```

### One way binding

One way binding is binding when the binded property will read changes from View propertry binded, But will not apply changes into View property when the binded property change.

To do one way binding, you need to create property with same type as View property you want to bind and add `@ViewState` attributes

```swift

@ViewState searchPhrase: String?

```

Then you can bind it manually like this using projectedValue and keyPath:

```swift
$searchPhrase.oneWayBind(with: yourSearchBarToBind, \.text)
```

and you can add binding observer:

```swift
$searchPhrase.oneWayBind(with: yourSearchBarToBind, \.text)
    .viewDidSet(then: { searchBar, changes in
        let newValue = changes.newValue
        let oldValue = changes.oldValue
        // do something when view changes
    }
)
```

keep in mind, state didSet will not applicable when doing one way binding.

Or you can bind when layouting using `ViewApplicator`:

```swift
thisLayout.put(yourSearchBarToBind) { yourSearchBarToBindLayout in
    ...
    ...
}.oneWayBind(\.text, with: $searchPhrase)
```

To add binding observer when layouting using `ViewApplicator` is like this:

```swift
thisLayout.put(yourSearchBarToBind) { yourSearchBarToBindLayout in
    ...
    ...
}.bind(\.text, with: $searhPhrase, viewDidSet: { searchBar, changes in
    let newValue = changes.newValue
    let oldValue = changes.oldValue
    // do something when view changes
}
```

### Observing state

If you want to observe the changes of states you can always add observer into property projectedValue

```swift
$searhPhrase.observe(observer: self).willSet { selfObserver, changes in
    let newValue = changes.newValue
    let oldValue = changes.oldValue
    let trigger = changes.trigger
    let viewThatTriggerChanges: UIView? = trigger.triggeringView
    // do something when searchPhrase is will change
}.didSet { selfObserver, changes in
    let newValue = changes.newValue
    let oldValue = changes.oldValue
    let trigger = changes.trigger
    let viewThatTriggerChanges: UIView? = trigger.triggeringView
    // do something when searchPhrase is change
}
```

There is three trigger enumeration: 
- `view(UIView)` which means the closure is triggered from changes in View
- `state` which means the closure is triggered from changes directly into binded property
- `bind` which means the closure is triggered when in binding process

You can delay didSet closure run like this:

```swift
$searhPhrase.observe(observer: self)
    .delayMultipleSetTrigger(by: 1)
    .didSet { selfObserver, changes in
        let newValue = changes.newValue
        let oldValue = changes.oldValue
        let trigger = changes.trigger
        let viewThatTriggerChanges: UIView? = trigger.triggeringView
        // do something when searchPhrase is change
}
```

Which means when multiple set is triggered with interval under one second, it will wait until one second to run next closure with latest changes, and ignore any changes in those interval.

You can always observe get too:

```swift
$searhPhrase.observe(observer: self).willGet { selfObserver, value in
    // do something when searchPhrase property will get
}.didGet { selfObserver, value in
    // do something when searchPhrase property did get
}
```

## View Model

### Basic View Model

You can create View Model by extending ViewModel class:

```swift
class MyViewModel: ViewModel<MyView> {
    @ViewState image: UIImage?
    @ViewState text: String?
    
    override func willApplying(_ view: MyView) { 
        // do something when view model will applying view
    }

    override func didApplying(_ view: MyView) { 
        // do something when view model did applying view
    }

    override func modelWillMapped(from view: MyView) { 
        // do something when view model will mapped view
    }

    override func modelDidMapped(from view: MyView) { 
        // do something when view model did mapped view
    }

    override func willUnbind() { 
        // do something when view model will unbind
    }

    override func didUnbind() { 
        // do something when view model did unbind
    }

    override func bind(with view: MyView) {
        super.bind(with: view)
        $image.bind(with: view.imageView, \.image)
        $text.bind(with: view.textView, \.text)
        $text.observe(observer: self)
            .delayMultipleSetTrigger(by: 1)
            .didSet { model, changes in
            // do something
        }
    }
}
```

ViewModel generic parameter can be anything that extend NSObject, like UIView, or UIViewController. Then you can use the View model like this:

```swift
class MyView: UIViewController {
    override func viewDidLoad() {
        super .viewDidLoad()
        layoutView()
        let viewModel: MyViewModel = .init()
        viewModel.apply(into: self)
    }
}
```

you can apply, map or just bind your view to ViewModel just like usual binding. It will automatically set all the `@ViewState` attributes to run those behaviour when you do binding.

### Cell View Model

To create View Model for cell which will support reusability of cell, you can use `UICollectionViewCell.Model<Cell: UICollectionViewCell>` for Collection and `UITableViewCell.Model<Cell: UITableViewCell>` for Table. The rest is same like ViewModel, except the generic parameter.

```swift
class MyCellView: CollectionCellLayoutable {
    lazy var image: UIImageView = .init()
    lazy var label: UILabel = .init()
    
    override func layoutChild(_ thisLayout: ViewLayout) { 
        thisLayout.put(image) {
            ...
            ...
        }
        thisLayout.put(label) {
            ...
            ...
        }
    }
}

class MyCellViewModel: UICollectionViewCell.ViewModel<MyCellView> {
    @ViewState image: UIImage?
    @ViewState text: String?
    
    override func willApplying(_ view: MyCellView) { 
        // do something when view model will applying view
    }

    override func didApplying(_ view: MyCellView) { 
        // do something when view model did applying view
    }

    override func modelWillMapped(from view: MyCellView) { 
        // do something when view model will mapped view
    }

    override func modelDidMapped(from view: MyCellView) { 
        // do something when view model did mapped view
    }

    override func willUnbind() { 
        // do something when view model will unbind
    }

    override func didUnbind() { 
        // do something when view model did unbind
    }

    override func bind(with view: MyCellView) {
        super.bind(with: view)
        $image.bind(with: view.image, \.image)
        $text.bind(with: view.label, \.text)
    }
}
```

To apply the cell into `UITableView` or `UICollectionView` you just need to set the model into cells property in `UITableView`, or `UICollectionView`

```swift
let cellModels: [CollectionCellModel] = items.compactMap { item in
    let cellModel: MyCellViewModel = build {
        $0.cellIdentifier = item.itemId
        $0.image = item.image
        $0.text = item.itemName
    }
    return cellModel
}
table.cells = cellModels
```

It will automatically reload existing cells with new cells and only reload cell with different cellIdentifier. Cell identifier can be anything as long as it's Hashable

If your table pr collection is sectionable, you can create section with cells and assign it to table sections:

```swift
let firstSection: UICollectionView.Section = .init(
    identifier: "first_section", 
    cells: items.compactMap { item in
        let cellModel: MyCellViewModel = build {
            $0.cellIdentifier = item.itemId
            $0.image = item.image
            $0.text = item.itemName
        }
        return cellModel
    }
)
let secondSection: UICollectionView.Section = .init(
    identifier: "second_section", 
    cells: users.compactMap { user in
        let cellModel: MyOtherCellViewModel = build {
            $0.cellIdentifier = user.userId
            $0.image = user.image
            $0.text = user.itemName
        }
        return cellModel
    }
)
table.sections = [firstSection, secondSection]
```

Section identifier can be anything as long as it's Hashable

There are some default section you can use, which is

- `UITableView.Section` and `UICollectionView.Section` default plain section 
- `UITableView.TitledSection` and `UICollectionView.TitledSection` which is section with title
- `UICollectionView.SupplementedSection` which is UICollectionView Section with custom header or/and footer

If you want to directly get default binded model with UICollectionView or UITableView, just get it from model property. The cells, and section property are actually the property of the UICollectionView or UITableView ViewModel.

```swift
let tableModel: UITableView.Model = table.model
let collectionModel: UICollectionView.Model = table.model
```

## Contribute

Clone and do pull request
