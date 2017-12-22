//
//  ZSegmentedControl.swift
//  ZSegmentedControl
//
//  Created by mengqingzheng on 2017/12/6.
//  Copyright © 2017年 MQZHot. All rights reserved.
//

import UIKit
enum ResourceType {
    case text
    case image
    case hybrid
}
enum HybridStyle {
    case normalWithSpace(CGFloat)
    case imageRightWithSpace(CGFloat)
    case imageTopWithSpace(CGFloat)
    case imageBottomWithSpace(CGFloat)
}
enum SliderStyle {
    case cover
    case bottom(CGFloat)
    case top(CGFloat)
    case none
}
/// 点击
protocol ZSegmentedControlSelectedProtocol {
    func segmentedControlSelectedIndex(_ index: Int, animated: Bool, segmentedControl: ZSegmentedControl)
}
class ZSegmentedControl: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContentView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupContentView()
    }
    func setTitles(_ titles: [String], fixedWidth: CGFloat) {
        resourceType = .text
        titleSources = titles
        totalItemsCount = titles.count
        setupItems(fixedWidth: fixedWidth)
    }
    func setTitles(_ titles: [String], adaptiveLeading: CGFloat) {
        resourceType = .text
        titleSources = titles
        totalItemsCount = titles.count
        setupItems(fixedWidth: 0, leading: adaptiveLeading)
    }
    func setImages(_ images: [UIImage], selectedImages: [UIImage?]? = nil, fixedWidth: CGFloat) {
        resourceType = .image
        imageSources = (images, selectedImages)
        totalItemsCount = images.count
        setupItems(fixedWidth: fixedWidth)
    }
    func setHybridResource(_ titles: [String?], images: [UIImage?], selectedImages: [UIImage?]? = nil, style: HybridStyle = .normalWithSpace(0), fixedWidth: CGFloat) {
        resourceType = .hybrid
        hybridSources = (titles, images, selectedImages)
        totalItemsCount = max(titles.count, images.count)
        setupItems(fixedWidth: fixedWidth)
    }
    
    
    /// public
    var bounces: Bool = false {
        didSet { subScrollView.bounces = bounces }
    }
    var textColor: UIColor = UIColor.gray {
        didSet {
            itemsArray.forEach { $0.setTitleColor(textColor, for: .normal) }
        }
    }
    var textSelectedColor: UIColor = UIColor.blue {
        didSet {
            selectedItemsArray.forEach { $0.setTitleColor(textSelectedColor, for: .normal) }
        }
    }
    var textFont: UIFont = UIFont.systemFont(ofSize: 15) {
        didSet {
            itemsArray.forEach { $0.titleLabel?.font = textFont }
            selectedItemsArray.forEach { $0.titleLabel?.font = textFont }
        }
    }
    var sliderColor: UIColor = UIColor.red {
        didSet { sliderView.backgroundColor = sliderColor }
    }
    var sliderEdge: UIEdgeInsets = .zero {
        didSet {  }
    }
    var sliderCornerRadius: CGFloat = 0 {
        didSet {  }
    }
    
    
    var sliderOffset: CGFloat = 0 {
        didSet { updateSilderOffset() }
    }
    
    var selectedIndex: Int = 0 {
        didSet {
            if selectedIndex<0||selectedIndex>selectedItemsArray.count-1 {
                selectedIndex = 0
                return
            }
            updateOffset()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateOffset()
    }
    var delegate: ZSegmentedControlSelectedProtocol?
    
    /// private
    fileprivate var scrollView = UIScrollView()
    fileprivate var subScrollView = UIScrollView()
    fileprivate var itemsArray = [UIButton]()
    fileprivate var selectedItemsArray = [UIButton]()
    fileprivate var sliderView = UIView()
    fileprivate var sliderViewMask = UIView()
    fileprivate var totalItemsCount: Int = 0
    fileprivate var titleSources = [String]()
    fileprivate var imageSources: ([UIImage], [UIImage?]?) = ([], nil)
    fileprivate var hybridSources: ([String?], [UIImage?], [UIImage?]?) = ([], [], nil)
    fileprivate var resourceType: ResourceType = .text
    fileprivate var isTapItem: Bool = false
    
    fileprivate func setupContentView() {
        backgroundColor = UIColor.white
        
        scrollView.frame = bounds
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        addSubview(scrollView)
        
        subScrollView.frame = bounds
        subScrollView.delegate = self
        subScrollView.showsHorizontalScrollIndicator = false
        subScrollView.bounces = false
        addSubview(subScrollView)
        
        sliderView.backgroundColor = sliderColor
        subScrollView.addSubview(sliderView)
        sliderViewMask.backgroundColor = UIColor.white
        subScrollView.addSubview(sliderViewMask)
        subScrollView.layer.mask = sliderViewMask.layer
    }
    
    fileprivate func setupItems(fixedWidth: CGFloat, leading: CGFloat? = nil) {
        itemsArray.forEach { $0.removeFromSuperview() }
        itemsArray.removeAll()
        selectedItemsArray.forEach { $0.removeFromSuperview() }
        selectedItemsArray.removeAll()
        var contentSizeWidth: CGFloat = 0
        for i in 0..<totalItemsCount {
            var width = fixedWidth
            if let leading = leading {
                let text = titleSources[i] as NSString
                width = text.size(withAttributes: [.font: textFont]).width + leading*2
            }
            let x = contentSizeWidth
            let height = frame.size.height
            let button = UIButton(type: .custom)
            button.frame = CGRect(x: x, y: 0, width: width, height: height)
            button.clipsToBounds = true
            scrollView.addSubview(button)
            itemsArray.append(button)
            
            let selectedButton = UIButton(type: .custom)
            selectedButton.tag = i
            selectedButton.frame = button.frame
            selectedButton.addTarget(self, action: #selector(selectedButton(sender:)), for: .touchUpInside)
            subScrollView.addSubview(selectedButton)
            selectedItemsArray.append(selectedButton)
            
            switch resourceType {
            case .text:
                button.setTitle(titleSources[i], for: .normal)
                button.setTitleColor(textColor, for: .normal)
                button.titleLabel?.font = textFont
                selectedButton.setTitle(titleSources[i], for: .normal)
                selectedButton.setTitleColor(textSelectedColor, for: .normal)
                selectedButton.titleLabel?.font = textFont
            case .image:
                button.setImage(imageSources.0[i], for: .normal)
                let selectedImage = imageSources.1?[i]==nil ? imageSources.0[i] : imageSources.1?[i]
                selectedButton.setImage(selectedImage, for: .normal)
            case .hybrid:
                let titles = hybridSources.0
                let images = hybridSources.1
                let selectedImages = hybridSources.2
                if let title = titles[i] {
                    button.setTitle(title, for: .normal)
                    selectedButton.setTitle(title, for: .normal)
                }
                if let image = images[i] {
                    button.setImage(image, for: .normal)
                }
                if let selectedImage = selectedImages[i] {
                    selectedButton.setImage(selectedImage, for: .normal)
                }
                button.setTitleColor(textColor, for: .normal)
                button.titleLabel?.font = textFont
                
                selectedButton.setTitleColor(textSelectedColor, for: .normal)
                selectedButton.titleLabel?.font = textFont
                
                let selectedImage = hybridSources.2?[i]==nil ? hybridSources.1[i] : hybridSources.2?[i]
                selectedButton.setImage(selectedImage, for: .normal)
            }
            contentSizeWidth += width
        }
        scrollView.contentSize = CGSize(width: contentSizeWidth, height: 0)
        subScrollView.contentSize = CGSize(width: contentSizeWidth, height: 0)
        let currentIndex = selectedIndex>totalItemsCount-1 ? 0:selectedIndex
        let button = selectedItemsArray[currentIndex]
        sliderView.frame = button.frame
        sliderViewMask.frame = sliderView.frame
    }
    @objc func selectedButton(sender: UIButton) {
        isTapItem = true
        selectedIndex = sender.tag
    }
    fileprivate func updateSilderOffset() {
        if isTapItem { return }
        let percent = sliderOffset-CGFloat(selectedIndex)
        var targetIndex = selectedIndex
        if percent < 0 {
            targetIndex = selectedIndex-1
        } else if percent > 0 {
            targetIndex = selectedIndex+1
        }
        if targetIndex < 0 || targetIndex > selectedItemsArray.count-1 { return }
        let button = selectedItemsArray[selectedIndex]
        let targetButton = selectedItemsArray[targetIndex]
        let centerXChange = (targetButton.center.x-button.center.x)*abs(percent)
        let widthChange = (targetButton.frame.size.width-button.frame.size.width)*abs(percent)
        var frame = button.frame
        frame.size.width += widthChange
        var center = button.center
        center.x += centerXChange
        sliderView.frame = frame
        sliderView.center = center
        sliderViewMask.frame = sliderView.frame
    }
    fileprivate func updateOffset() {
        delegate?.segmentedControlSelectedIndex(selectedIndex, animated: isTapItem, segmentedControl: self)
        let button = selectedItemsArray[selectedIndex]
        var offsetx = button.center.x - self.frame.size.width/2
        let offsetMax = self.subScrollView.contentSize.width - self.frame.size.width
        if offsetx < 0 {
            offsetx = 0
        }else if offsetx > offsetMax {
            offsetx = offsetMax
        }
        let offset = CGPoint(x: offsetx, y: 0)
        UIView.animate(withDuration: 0.3, animations: {
            self.sliderView.frame = button.frame
            self.sliderViewMask.frame = button.frame
        }) { _ in
            self.subScrollView.setContentOffset(offset, animated: true)
            self.isTapItem = false
        }
    }
}
extension ZSegmentedControl: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.scrollView.contentOffset = scrollView.contentOffset
    }
}

