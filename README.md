# ZSegmentedControl

Customizable segmented control, a UISwitch-like segmented control and Segmented pager written in Swift

![image](https://travis-ci.org/MQZHot/ZSegmentedControl.svg?branch=master)   ![](https://img.shields.io/badge/support-swift%204%2B-green.svg)  ![](https://img.shields.io/badge/support-iOS%208%2B-blue.svg)  ![](https://img.shields.io/cocoapods/v/ZSegmentedControl.svg?style=flat)

<img src="https://github.com/MQZHot/ZSegmentedControl/raw/master/picture.gif">

## How To Use

### set image / text
```swift
/// only text
///
/// - Parameters:
///   - titles: text group
///   - style: The width style of the text is an enumeration, fixed width or adaptive
func setTitles(_ titles: [String], style: WidthStyle)

/// only image
///
/// - Parameters:
///   - images: image group
///   - selectedImages: selected image group, Ideally the same number of images, if not, the selected will be the item in images
///   - fixedWidth: The width is fixed
func setImages(_ images: [UIImage], selectedImages: [UIImage?]? = nil, fixedWidth: CGFloat)

/// both text image
///
/// - Parameters:
///   - titles: title group
///   - images: image group
///   - selectedImages: selected image group
///   - style: image potision
///   - fixedWidth: The width is fixed
func setHybridResource(_ titles: [String?], images: [UIImage?], selectedImages: [UIImage?]? = nil, style: HybridStyle = .normalWithSpace(0), fixedWidth: CGFloat)
```

### setup cover
```swift
/// setup cover
///
/// - Parameters:
///   - color: color backgroundColor
///   - upDowmSpace: the distance of cover's up/down from item's up/down
///   - cornerRadius: radius
func setCover(color: UIColor, upDowmSpace: CGFloat = 0, cornerRadius: CGFloat = 0)
```

### setup slider view
```swift
/// set slider
///
/// - Parameters:
///   - backgroundColor: slider backgroundColor
///   - position: Deciding on the slider position up or down, an enumeration
///   - widthStyle: The width of the slider is an enumeration, fixed width or adaptive
func setSilder(backgroundColor: UIColor,position: SliderPositionStyle, widthStyle: WidthStyle)
```

### ***if you use segmented pager-like, use this method in scrollViewDelegate***
```swift
/// use in contentScrollView `scrollViewDidScroll`
func contentScrollViewDidScroll(_ scrollView: UIScrollView)
/// use in contentScroll `scrollViewWillBeginDragging`
func contentScrollViewWillBeginDragging()
```


```swift
/// default `false`. if `true`, bounces past edge of content and back again
var bounces: Bool = false
/// selected index, default `0`
var selectedIndex: Int = 0
/// selectedScale, default `1.0`
var selectedScale: CGFloat = 1.0
```

## Contact

* Email: mqz1228@163.com

## LICENSE

ZSegmentedControl is released under the MIT license. See [LICENSE](https://github.com/MQZHot/ZSegmentedControl/blob/master/LICENSE) for details.
