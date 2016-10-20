# RKParallaxEffect

[![Travis](https://img.shields.io/travis/RahulKatariya/RKParallaxEffect/master.svg)](https://travis-ci.org/RahulKatariya/RKParallaxEffect/branches)
[![Version](https://img.shields.io/cocoapods/v/RKParallaxEffect.svg?style=flat)](http://cocoadocs.org/docsets/RKParallaxEffect)
[![License](https://img.shields.io/cocoapods/l/RKParallaxEffect.svg?style=flat)](http://cocoadocs.org/docsets/RKParallaxEffect)
[![Platform](https://img.shields.io/cocoapods/p/RKParallaxEffect.svg?style=flat)](http://cocoadocs.org/docsets/RKParallaxEffect)

[![Preview](https://raw.githubusercontent.com/RahulKatariya/RKParallaxEffect/master/RKParallaxEffect.gif)](http://RahulKatariya.github.io/RKParallaxEffect)

## Requirements

* iOS 8.0+
* Xcode 8.0+

## Installation

### CocoaPods

RKParallaxEffect is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

    use_frameworks!
    pod "RKParallaxEffect", ~> '2.0'


### Carthage

    github "RahulKatariya/RKParallaxEffect" ~> 2.0

## Usage
```swift
import RKParallaxEffect

class TableViewController: UITableViewController {

    var parallaxEffect: RKParallaxEffect!

    override func viewDidLoad() {
        super.viewDidLoad()
        parallaxEffect = RKParallaxEffect(tableView: tableView)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        parallaxEffect.isParallaxEffectEnabled = true
        parallaxEffect.isFullScreenTapGestureRecognizerEnabled = true
        parallaxEffect.isFullScreenPanGestureRecognizerEnabled = true
    }

}

```

## Author

Rahul Katariya, rahulkatariya@me.com

## License

RKParallaxEffect is available under the MIT license. See the LICENSE file for more info.
