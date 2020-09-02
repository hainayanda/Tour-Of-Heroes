# NamadaLayout

NamadaLayout is a DSL framework for Swift to make Auto layout easier. (This is Beta version and have no proper Unit Test, use it at your own risk)

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
pod 'NamadaLayout', '2.0.1-beta'
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
    lazy var imageView: UIImageView = build {
        $0.image = #imageLiteral(resourceName: "anyImage")
        $0.contentMode = .scaleAspectFit
    }
    lazy var stackLayout: UIStackView = build {
        $0.axis = .vertical
        $0.alignment = .center
        $0.distribution = .fill
        $0.spacing = 9
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
        layoutContent { content in
            content.put(searchBar)
                .at(.fullTop, .equal, to: .safeArea)
                .bind(\.text, with: $typedText)
            content.put(topLabel)
                .at(.bottomOfAndParallelWith(searchBar), .equalTo(UIEdgeInsets(horizontal: 0, top: 18, bottom: 0)))
                .horizontal(.moreThanTo(18), to: .parent)
                .bind(\.text, with: $topTitle)
            content.put(stackLayout)
                .center(.equal, to: .parent)
                .inBetween(of: topLabel, and: bottomButton, .vertically(.moreThanTo(18)), priority: .defaultLow)
                .horizontal(.moreThanTo(18), to: .parent)
                .layoutContent { stackContent in
                    stackContent.putStacked(middleLabel)
                        .bind(\.text, with: $middleText)
                    stackContent.putStacked(imageView)
                        .size(.equalTo(.init(width: 90, height: 90)))
            }
            content.put(bottomButton)
                .at(.fullBottom, .equalTo(18), to: .safeArea)
                .height(.equalTo(36))
            
        }
    }
    
    func listen() {
        $topTitle.observe(observer: self).didSet { viewController, changes in
            viewController.middleText = "new: \(changes.new ?? "null"), old: \(changes.old ?? "null")"
        }
        $typedText.observe(observer: self).didSet { viewController, changes in
            guard let _ = changes.trigger.triggeringView else { return }
            viewController.topTitle = "typed: \(changes.new ?? "null")"
        }
    }
}
```
It will automatically put view as closure hierarchy, create all constraints inside the closure and activate it just after the closure finished on the UIThread. It will also bind view keypath into any property with same type with @ViewState attributes.

## Layouting

### Basic

There are two main function to create layout which is:
- `layout(withDelegate delegate: NamadaLayoutDelegate?, _ options: SublayoutingOption, _ layouter: (ViewLayout<Self>) -> Void)`
- `layoutContent(withDelegate delegate: NamadaLayoutDelegate? = nil, _ options: SublayoutingOption, _ layouter: (LayoutContainer<Self>) -> Void)`
all the method can be used in UIViewController and UIView.
The difference between those three is
- `layout` are used to layout the Constraints of the view.
- `layoutContent` are used to layout content of the view ignoring it's own constraints.

both accept SubLayoutingOption enumeration which is:
- `addNew` which will add new constraints ignoring the current constraints of the view, This is the default value
- `editExisting` which will edit existing same constraints relation between views created by NamadaLayout, and added constraints if it's new. Since it's literraly will check the same constraint's relation, it will be slightly slower than `addNew`
- `removeOldAndAddNew` which will remove all current constraints created by NamadaLayout and added new constraints. Since it's literraly will check all the constraint's identifier, it will be slightly slower than `addNew`
- `cleanLayoutAndAddNew` which will remove all subviews from it's parent which in effect will removing all of it's constraints. Since it's literraly will loop all subviews and remove it from superview, it will be slightly slower than `addNew`, but should be faster than `editExisting` and `removeOldAndAddNew`

we will talk about the delegate later.

example:

```swift
class ViewController: UIViewController {
    ...
    ...
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutContent { content in
            content.put(someView)
        }
    }
}
```
The above code will add `someView`  into ViewController view child

```swift
class ViewController: UIViewController {
    ...
    ...
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutContent { content in
        content.put(someView)
            .layoutContent { someViewContent in
                someViewContent.put(someOtherview)
            }
        }
    }
}
```
The above code will add `someView`  into ViewController view child, and then put `someOtherView` into `someView` child.

If you have stackView, you can put your view stacked inside or not too:

```swift
class ViewController: UIViewController {
    ...
    ...
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutContent { content in
        content.put(someStack)
            .layoutContent { someStackContent in
                someStackContent.putStacked(stackedView)
                someStackContent.putStacked(otherStacked)
                someStackContent.put(someOtherview)
            }
        }
    }
}
```
The above code will add `someStack`  into ViewController view child, and then put `stackedView` and `otherStacked` into `stackedView` arranged child and put `someOtherview` inside `someStack` but not stacked.

You can embed `UIViewController` too:
```swift
class ViewController: UIViewController {
    ...
    ...
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutContent { content in
            content.put(someViewController)
        }
    }
}
```


### Position Constraint

All layout have edges and you can create very readable constraints like this: 
```swift
class ViewController: UIViewController {
    ...
    ...
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutContent { content in
            content.put(someView)
                .top(.equal, to: topView.bottomAnchor)
                .left(.moreThan, to: leftView.rightAnchor)
                .right(.lessThan, to: rightView.leftAnchor)
                .bottom(.equalTo(18), to: bottomView.topAnchor)
                .centerY(.moreThanTo(9), to: centerView.centerYAnchor)
                .centerX(.lessThanTo(4.5), to: centerView.centerXAnchor)
        }
    }
}
```
The above code is adding `someView` into ViewController view childs and then creating this constraints:
- `someView` top is equal to `topView` bottom
- `someView` left is greaterThanOrEqual to `leftView` right
- `someView` right is lessThanOrEqual to `rightView` left
- `someView` bottom equal to distance to `bottomView` top by 18
- `someView` centerY greaterThanOrEqual to distance to `bottomView` centerY by 9
- `someView` centerX lessThanOrEqual to distance to `bottomView` centerX by 4.5

If you want to make View Constraints with its parent then just pass `.parent` or `.safeArea` instead:

```swift
class ViewController: UIViewController {
    ...
    ...
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutContent { content in
            content.put(someView)
                .top(.equal, to: .safeArea)
                .left(.moreThan, to: .parent)
                .right(.lessThan, to: parent)
                .bottom(.equalTo(18), to: safeArea)
        }
    }
}
```
The above code is adding `someView` into ViewController view childs and then creating this constraints:
- `someView` top is equal to its parent's top
- `someView` left is greaterThanOrEqual to its parent's left
- `someView` right is lessThanOrEqual to its parent's right
- `someView` bottom equal to distance to its parent's bottom

There are some shortcut to create multiple constraint at once like:

```swift
class ViewController: UIViewController {
    ...
    ...
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutContent { content in
            content.put(someView)
                .center(.equal, to: otherView)
                .vertical(.moreThanTo(18), to: .safeArea)
                .horizontal(.lessThanTo(UIHorizontalInsets(left: 9, right: 18)), to: .parent)
            content.put(tableView)
                .edges(.equalTo(18), to: .parent)
            content.put(imageView)
                .inBetween(of: someView, and: otherView, .horizontally(.equal))
            content.put(logoView)
                .at(.topLeft, equalTo(9), to: .safeArea)
                .at(.topOf(otherView), .equal)
        }
        
    }
}
```
- `center` is shortcut to set `centerX` and `centerY` to other view simultaniously
- `vertical` is shortcut to set `top` and `bottom` to parent or safeArea simultaniously
- `horizontal` is shortcut to set `top` and `bottom` to parent or safeArea simultaniously
- `edges` is shortcut to set `top`, `bottom`, `left` and `right` to parent or safeArea simultaniously
- `inBetween` is shortcut to set `top` and `bottom` or `left` and `right` to two view simultaniously
- `at` is shortcut to set `top`, `bottom`, `left` or `right` to parent or safeArea simultaniously
- `at` can be other shortcut too to set `top`, `bottom`, `left`, `right` and center to other view simultaniously

### Dimension Constraints

To define dimension relation with other you can just do something like this:
```swift
class ViewController: UIViewController {
    ...
    ...
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutContent { content in
            content.put(someView)
                .width(.equalTo(.parent), multiplyBy: 0.75, constant: 18)
                .height(.lessThanTo(90))
                .height(moreThanTo(otherView.heightAnchor))
        }
    }
}
```
The above code is adding `someView` into ViewController view childs and then creating this constraints:
- `someView` width is equal to parent, multiplied by 0.75, added 18.
- `someView` height is lessThanOrEqual to 90
- `someView` height is greaterThanOrEqual to its otherView's height

There are some shortcuts too:

```swift
class ViewController: UIViewController {
    ...
    ...
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutContent { content in
            content.put(someView)
            .size(.lessThan(otherView), multiplyBy: 0.75, constant: 18)
            .size(.moreThan(CGSize(widht: 90, height: 90)))
        }
    }
}
```

which can be described by the code above

### Priority

To define constraint priority, just pass `UILayoutPriority` at any method you want. If you don't pass priority, it will assign the priority using simple rules which is the first constraint will be have more priority than the second, and so on. The start default priority is 999

```swift
class ViewController: UIViewController {
    ...
    ...
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutContent { content in
            content.put(someView)
                .top(.equal, to: .safeArea, priority: UILayoutPriority.required)
                .left(.moreThan, to: .parent, priority: UILayoutPriority.defaultHigh)
                .right(.lessThan, to: parent, priority: UILayoutPriority.defaultLow)
                .bottom(.equalTo(18), to: safeArea, priority: 1000)
        }
    }
}
```

### ViewApplicator

If you want to setup the view during layout. You can just use `ViewApplicator` after layouting

```swift
class ViewController: UIViewController {
    ...
    ...
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutContent { content in
            content.put(someView)
                .top(.equal, to: .safeArea)
                .left(.moreThan, to: .parent)
                .right(.lessThan, to: parent)
                .bottom(.equalTo(18), to: safeArea)
                .apply {
                    $0.backgroundColor = .white
                }
        }
    }
}
```

### Delegate

There's a delegate which can passed when you create layout:

```swift
public protocol NamadaLayoutDelegate: class {
    func namadaLayout(viewHaveNoSuperview view: UIView) -> UIView?
    func namadaLayout(neededViewControllerFor viewController: UIViewController) -> UIViewController?
    func namadaLayout(_ view: UIView, erroWhenLayout error: NamadaError)
}
```

All the method are optional since all the default implementation are already defined in the extensions. The purpose of each methods are:
- `namadaLayout(viewHaveNoSuperview view: UIView) -> UIView?`
will be called when you call relation with parent, but your layout is have no parent (like in top view in UIViewController). The default implementation will be throw LayoutError
- `func namadaLayout(neededViewControllerFor viewController: UIViewController) -> UIViewController?`
will be called when you embed UIViewController, but your layout have no UIViewController (like in UITableViewCell). The default implementation will be throw LayoutError
- `func namadaLayout(_ view: UIView, erroWhenLayout error: NamadaError)`
will be called when you there's any LayoutError when creating constraints.

You can pass the delegate when first call layoutContent or layout like this this: 

```swift
layoutContent(withDelegate: yourDelegate) { content in
    ...
    ...
}
```

## Molecule

You can create molecule using MoleculeView protocol:

```swift
class MoleculeView: UIView, MoleculeView {
    ...
    ...
    ...
    func layoutContent(_ layout: LayoutInsertable) {
        layout.put(someView)
        ...
        ...
        layout.put(someOtherView)
        ...
        ...
    }
    
    func moleculeWillLayout() {
        //will run before layouting
        ...
        ...
    }
    
    func moleculeDidLayout() { 
        //will run after layouting
        ...
        ...
    }
}
```

The layoutContent will be called if the `MoleculeView` is added to superView using `layout`, or `layoutContent`

MoleculeView have optional func which are:

- `moleculeWillLayout()` which will run before layouting
- `moleculeDidLayout()` which will run after layouting

### Cell Molecule

You can create Cell (UITableViewCell or UICollectionViewCell) Molecule. Just extend `CollectionMoleculeCell` for UICollectionViewCell or `TableMoleculeCell` for UITableViewCell.

```swift
class MyTableCell: TableCellLayoutable {
    ...
    ...
    
    override var layoutBehaviour: CellLayoutBehaviour { .layoutOn(.reused) }
    
    override func layoutContent(_ thisLayout: layout) {
        layout.put(someView)
        ...
        ...
        layout.put(someOtherView)
        ...
        ...
    }
}
```

LayoutChild will run when the cell first layout, or depends on CellLayoutBehaviour if you override it. The behaviour are:
- `layoutOnce` wich will ensure layoutChild only run once on the first layout
- `layoutOn(CellLayoutingPhase)` wich will layout on first layout and on phase
- `layoutOnEach([CellLayoutingPhase])` wich will layout on first layout and on each phasses
- `alwaysLayout` wich will layout on every phase

the phase are:
- `firstLoad`
- `setNeedsLayout`
- `setNeedsDisplay`
- `reused`
- `none`

you can implement `func layoutOption(on phase: CellLayoutingPhase) -> SublayoutingOption` to tell which SubLayoutingOption you want for every phase. the default is `.addNew` on firstLoad and `.removeOldAndAddNew` for the rest

```swift
class MoleculeCell: TableCellLayoutable {
    ...
    ...
    
    func layoutOption(on phase: CellLayoutingPhase) -> SublayoutingOption {
        return .removeOldAndAddNew
    }
}
```

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
layoutContent { content in
content.put(searchBar)
    .at(.fullTop, .equal, to: .safeArea)
    .bind(\.text, with: $typedText)
```
or
```swift
layoutContent { content in
content.put(searchBar)
    .at(.fullTop, .equal, to: .safeArea)
    .apply(\.text, with: $typedText)
```
or
```swift
layoutContent { content in
content.put(searchBar)
    .at(.fullTop, .equal, to: .safeArea)
    .map(\.text, with: $typedText)
```

To add binding observer when layouting using `ViewApplicator` is like this:

```swift
content.put(searchBar)
    .at(.fullTop, .equal, to: .safeArea)
    .bind(\.text, with: $searhPhrase, viewDidSet: { searchBar, changes in
        let newValue = changes.newValue
        let oldValue = changes.oldValue
        // do something when view changes
}
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
layoutContent { content in
content.put(searchBar)
    .at(.fullTop, .equal, to: .safeArea)
    .oneWayBind(\.text, with: $typedText)
```

To add binding observer when layouting using `ViewApplicator` is like this:

```swift
content.put(searchBar)
    .at(.fullTop, .equal, to: .safeArea)
    .oneWayBind(\.text, with: $searhPhrase, viewDidSet: { searchBar, changes in
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

To create View Model for cell which will support reusability of cell, you can use `CollectionViewCellModel<Cell: UICollectionViewCell>` for Collection and `TableViewCellModel<Cell: UITableViewCell>` for Table. The rest is same like ViewModel, except the generic parameter.

```swift
class MyCellView: CollectionMoleculeCell {
    ...
    ...
}

class MyCellViewModel: CollectionViewCellModel<MyCellView> {
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

or by using `CollectionCellBuilder` or `TableCellBuilder`

```swift
let cellSections: [UICollectionView.Section] = CollectionCellBuilder(.init(identifier: "first_section"))
    .next(type: MyCellViewModel.self, from: items) { cell, item in
        cell.cellIdentifier = item.itemId
        cell.image = item.image
        cell.text = item.itemName
}
table.sections = cellSections
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

### ObservableView

If you have any view that you want to observe by `ViewModel` by delegate, you can just implement `ObservableView` and provide `Observer`. It will have a variable named `observer`, which is current binded ViewModel and casting it to `Observer` type. So don't forget to implement the ObserverType to your ViewModel. It's better to make the Observer extend `ViewModelObserver` since it have method to notify ViewModel that it finished Layouting and then ViewModel will automatically apply View with ViewModel if the type match:

```swift
protocol MyScreenObserver: ViewModelObserver {
    func myScreen(_ screen: MyScreen, didPullToRefresh refreshControl: UIRefreshControl)
}

class MyScreen: UIViewController, ObservableView {
    typealias Observer = MyScreenObserver
    ...
    ...
    ...
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutView()
        
        // will apply MyScreen with any binded ViewModel if already binded
        // ViewModel class are implement ViewModelObserver
        observer?.viewDidLayouted(self)
    }
    
    @objc func didPullToRefresh() {
        observer?.myScreen(self, didPullToRefresh: refreshControl)
    }
}
```

## Contribute

You know how, just clone and do pull request
