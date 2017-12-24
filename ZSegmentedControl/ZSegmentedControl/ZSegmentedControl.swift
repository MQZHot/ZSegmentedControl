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
    case coverUpDowmSpace(CGFloat)
    case bottomWithHight(CGFloat)
    case topWidthHeight(CGFloat)
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
        var sImages = [UIImage]()
        if selectedImages == nil {
            sImages = images
        } else {
            for i in 0..<images.count {
                let image = (i < selectedImages!.count && selectedImages![i] != nil) ? selectedImages![i]! : images[i]
                sImages.append(image)
            }
        }
        imageSources = (images, sImages)
        totalItemsCount = images.count
        setupItems(fixedWidth: fixedWidth)
    }
    func setHybridResource(_ titles: [String?], images: [UIImage?], selectedImages: [UIImage?]? = nil, style: HybridStyle = .normalWithSpace(0), fixedWidth: CGFloat) {
        resourceType = .hybrid
        totalItemsCount = max(titles.count, images.count)
        var _titles = [String?]()
        var _images = [UIImage?]()
        var _sImages = [UIImage?]()
        let sTempImages = selectedImages == nil ? images : selectedImages!
        for i in 0..<totalItemsCount {
            let title = i<titles.count ? titles[i] : nil
            let image = i<images.count ? images[i] : nil
            let sImage = i<sTempImages.count ? sTempImages[i] : nil
            _titles.append(title)
            _images.append(image)
            _sImages.append(sImage)
        }
        hybridSources = (_titles, _images, _sImages)
        
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
    
    /// cover
    func setCover(color: UIColor, upDowmSpace: CGFloat = 0, cornerRadius: CGFloat = 0) {
        if color == .clear { return }
        coverView.layer.cornerRadius = cornerRadius
        coverView.backgroundColor = color
        coverUpDownSpace = upDowmSpace
        fixCoverFrame(originFrame: coverView.frame, upSpace: upDowmSpace)
    }
    
    
    var tackingScale: CGFloat = 0 {
        didSet { updateTackingOffset() }
    }
    
    var selectedIndex: Int = 0 {
        didSet { updateScrollViewOffset() }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateScrollViewOffset()
    }
    var delegate: ZSegmentedControlSelectedProtocol?
    var moveDivision: Bool = false
    /// private
    fileprivate var scrollView = UIScrollView()
    fileprivate var subScrollView = UIScrollView()
    fileprivate var itemsArray = [UIButton]()
    fileprivate var selectedItemsArray = [UIButton]()
    fileprivate var coverView = UIView()
    fileprivate var coverViewMask = UIView()
    fileprivate var slider = UIView()
    fileprivate var totalItemsCount: Int = 0
    fileprivate var titleSources = [String]()
    fileprivate var imageSources: ([UIImage], [UIImage]) = ([], [])
    fileprivate var hybridSources: ([String?], [UIImage?], [UIImage?]) = ([], [], [])
    fileprivate var resourceType: ResourceType = .text
    fileprivate var isTapItem: Bool = false
    fileprivate var coverUpDownSpace: CGFloat = 0
    
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
        
        subScrollView.addSubview(coverView)
        coverViewMask.backgroundColor = UIColor.white
        subScrollView.layer.mask = coverViewMask.layer
        scrollView.addSubview(slider)
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
            button.tag = i
            button.addTarget(self, action: #selector(selectedButton(sender:)), for: .touchUpInside)
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
                selectedButton.setImage(imageSources.1[i], for: .normal)
            case .hybrid:
                button.setTitleColor(textColor, for: .normal)
                button.titleLabel?.font = textFont
                selectedButton.setTitleColor(textSelectedColor, for: .normal)
                selectedButton.titleLabel?.font = textFont
                button.setTitle(hybridSources.0[i], for: .normal)
                selectedButton.setTitle(hybridSources.0[i], for: .normal)
                button.setImage(hybridSources.1[i], for: .normal)
                selectedButton.setImage(hybridSources.2[i], for: .normal)
            }
            contentSizeWidth += width
        }
        scrollView.contentSize = CGSize(width: contentSizeWidth, height: 0)
        subScrollView.contentSize = CGSize(width: contentSizeWidth, height: 0)
        let index = min(max(selectedIndex, 0), selectedItemsArray.count)
        let button = selectedItemsArray[index]
        fixCoverFrame(originFrame: button.frame, upSpace: coverUpDownSpace)
        subScrollView.contentOffset = getScrollViewCorrectOffset(by: button)
    }
    @objc private func selectedButton(sender: UIButton) {
        isTapItem = true
        selectedIndex = sender.tag
    }
}
extension ZSegmentedControl {
    fileprivate func updateScrollViewOffset() {
        if selectedItemsArray.count == 0 { return }
        subScrollView.isHidden = !moveDivision
        let index = min(max(selectedIndex, 0), selectedItemsArray.count)
        delegate?.segmentedControlSelectedIndex(index, animated: isTapItem, segmentedControl: self)
        let button = selectedItemsArray[index]
        let offset = getScrollViewCorrectOffset(by: button)
        UIView.animate(withDuration: 0.3, animations: {
            self.fixCoverFrame(originFrame: button.frame, upSpace: self.coverUpDownSpace)
        }) { _ in
            if !self.moveDivision {
                for (i, item) in self.itemsArray.enumerated() {
                    item.setTitleColor(self.textColor, for: .normal)
                    if self.resourceType == .image {
                        item.setImage(self.imageSources.0[i], for: .normal)
                    } else if self.resourceType == .hybrid {
                        item.setImage(self.hybridSources.1[i], for: .normal)
                    }
                }
                let currentButton = self.itemsArray[index]
                currentButton.setTitleColor(self.textSelectedColor, for: .normal)
                if self.resourceType == .image {
                    currentButton.setImage(self.imageSources.1[index], for: .normal)
                } else if self.resourceType == .hybrid {
                    currentButton.setImage(self.hybridSources.2[index], for: .normal)
                }
                
            }
            self.subScrollView.setContentOffset(offset, animated: true)
            self.isTapItem = false
        }
    }
    
    fileprivate func getScrollViewCorrectOffset(by item: UIButton) -> CGPoint {
        var offsetx = item.center.x - frame.size.width/2
        let offsetMax = subScrollView.contentSize.width - frame.size.width
        if offsetx < 0 {
            offsetx = 0
        }else if offsetx > offsetMax {
            offsetx = offsetMax
        }
        let offset = CGPoint(x: offsetx, y: 0)
        return offset
    }
    
    fileprivate func updateTackingOffset() {
        if isTapItem { return }
        let percent = tackingScale-CGFloat(selectedIndex)
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
        fixCoverFrame(originFrame: frame, upSpace: coverUpDownSpace)
        coverView.center = center
        coverViewMask.frame = coverView.frame
        var sliderCenter = slider.center
        sliderCenter.x = center.x
        slider.center = sliderCenter
        subScrollView.isHidden = !moveDivision
        if !self.moveDivision {
            let currentColor = averageColor(fromColor: textSelectedColor, toColor: textColor, percent: abs(percent))
            let targetColor = averageColor(fromColor: textColor, toColor: textSelectedColor, percent: abs(percent))
            let currentButton = self.itemsArray[selectedIndex]
            currentButton.setTitleColor(currentColor, for: .normal)
            let targentButton = self.itemsArray[targetIndex]
            targentButton.setTitleColor(targetColor, for: .normal)
        }
    }
    
    fileprivate func fixCoverFrame(originFrame: CGRect, upSpace: CGFloat) {
        var newFrame = originFrame
        newFrame.origin.y = upSpace
        newFrame.size.height -= upSpace*2
        coverView.frame = newFrame
        coverViewMask.frame = coverView.frame
        newFrame.origin.y = originFrame.size.height-2
        newFrame.size.height = 2
        slider.frame = newFrame
        slider.backgroundColor = UIColor.red
    }
}
/// scrollViewDelegate
extension ZSegmentedControl: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.scrollView.contentOffset = scrollView.contentOffset
    }
    fileprivate func averageColor(fromColor: UIColor, toColor: UIColor, percent: CGFloat) -> UIColor {
        var fromRed: CGFloat = 0
        var fromGreen: CGFloat = 0
        var fromBlue: CGFloat = 0
        var fromAlpha: CGFloat = 0
        fromColor.getRed(&fromRed, green: &fromGreen, blue: &fromBlue, alpha: &fromAlpha)
        
        var toRed: CGFloat = 0
        var toGreen: CGFloat = 0
        var toBlue: CGFloat = 0
        var toAlpha: CGFloat = 0
        toColor.getRed(&toRed, green: &toGreen, blue: &toBlue, alpha: &toAlpha)
        
        let nowRed = fromRed + (toRed - fromRed) * percent
        let nowGreen = fromGreen + (toGreen - fromGreen) * percent
        let nowBlue = fromBlue + (toBlue - fromBlue) * percent
        let nowAlpha = fromAlpha + (toAlpha - fromAlpha) * percent
        
        return UIColor(red: nowRed, green: nowGreen, blue: nowBlue, alpha: nowAlpha)
    }
}

