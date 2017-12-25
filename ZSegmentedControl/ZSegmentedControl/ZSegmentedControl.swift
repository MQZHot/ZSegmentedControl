//
//  ZSegmentedControl.swift
//  ZSegmentedControl
//
//  Created by mengqingzheng on 2017/12/6.
//  Copyright © 2017年 MQZHot. All rights reserved.
//

import UIKit

enum HybridStyle {
    case normalWithSpace(CGFloat)
    case imageRightWithSpace(CGFloat)
    case imageTopWithSpace(CGFloat)
    case imageBottomWithSpace(CGFloat)
}
enum SliderPositionStyle {
    case bottomWithHight(CGFloat)
    case topWidthHeight(CGFloat)
}

/// only text style,
public enum WidthStyle {
    case fixedWidth(CGFloat)
    case adaptiveSpace(CGFloat)
}
/// 点击
protocol ZSegmentedControlSelectedProtocol {
    func segmentedControlSelectedIndex(_ index: Int, animated: Bool, segmentedControl: ZSegmentedControl)
}

class ZSegmentedControl: UIView {
    enum ResourceType {
        case text
        case image
        case hybrid
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContentView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupContentView()
    }
    func setTitles(_ titles: [String], style: WidthStyle) {
        resourceType = .text
        titleSources = titles
        totalItemsCount = titles.count
        switch style {
        case .fixedWidth(let width):
            setupItems(fixedWidth: width)
        case .adaptiveSpace(let space):
            setupItems(fixedWidth: 0, leading: space)
        }
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
            let image = i<images.count && images[i] != nil ? images[i] : UIImage()
            let sImage = i<sTempImages.count && sTempImages[i] != nil ? sTempImages[i] : UIImage()
            _titles.append(title)
            _images.append(image)
            _sImages.append(sImage)
        }
        hybridSources = (_titles, _images, _sImages)
        setupItems(fixedWidth: fixedWidth)
    }
    
    /// public
    var bounces: Bool = false {
        didSet { scrollView.bounces = bounces }
    }
    /// text
    var textColor: UIColor = UIColor.gray {
        didSet {
            itemsArray.forEach { $0.setTitleColor(textColor, for: .normal) }
        }
    }
    var textSelectedColor: UIColor = UIColor.blue {
        didSet {
            itemsArray.forEach { $0.setTitleColor(textSelectedColor, for: .normal) }
        }
    }
    var textFont: UIFont = UIFont.systemFont(ofSize: 15) {
        didSet {
            itemsArray.forEach { $0.titleLabel?.font = textFont }
        }
    }
    
    var selectedScale: CGFloat = 1.0
    
    /// cover
    func setCover(color: UIColor, upDowmSpace: CGFloat = 0, cornerRadius: CGFloat = 0) {
        coverView.isHidden = false
        coverView.layer.cornerRadius = cornerRadius
        coverView.backgroundColor = color
        coverUpDownSpace = upDowmSpace
        fixCoverAndSliderFrame(originFrame: coverView.frame, upSpace: upDowmSpace)
    }
    /// silder
    var sliderTackingScale: CGFloat = 0 {
        didSet { updateTackingOffset() }
    }
    var sliderAnimated: Bool = true
    
    func setSilder(backgroundColor: UIColor,position: SliderPositionStyle, widthStyle: WidthStyle) {
        slider.isHidden = false
        slider.backgroundColor = backgroundColor
        sliderConfig = (position, widthStyle)
    }
    
    var selectedIndex: Int = 0 {
        didSet { updateScrollViewOffset() }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateScrollViewOffset()
    }
    var delegate: ZSegmentedControlSelectedProtocol?
    
    /// private
    fileprivate var scrollView = UIScrollView()
    fileprivate var itemsArray = [UIButton]()
    fileprivate var coverView = UIView()
    fileprivate var totalItemsCount: Int = 0
    fileprivate var titleSources = [String]()
    fileprivate var imageSources: ([UIImage], [UIImage]) = ([], [])
    fileprivate var hybridSources: ([String?], [UIImage?], [UIImage?]) = ([], [], [])
    fileprivate var resourceType: ResourceType = .text
    fileprivate var isTapItem: Bool = false
    fileprivate var coverUpDownSpace: CGFloat = 0
    fileprivate var slider = UIView()
    fileprivate var sliderConfig: (SliderPositionStyle, WidthStyle)?
    
    fileprivate func setupContentView() {
        backgroundColor = UIColor.white
        scrollView.frame = bounds
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        addSubview(scrollView)
        scrollView.addSubview(coverView)
        scrollView.addSubview(slider)
        slider.isHidden = true
        coverView.isHidden = true
    }
    
    fileprivate func setupItems(fixedWidth: CGFloat, leading: CGFloat? = nil) {
        itemsArray.forEach { $0.removeFromSuperview() }
        itemsArray.removeAll()
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
            
            switch resourceType {
            case .text:
                button.setTitle(titleSources[i], for: .normal)
                button.setTitleColor(textColor, for: .normal)
                button.titleLabel?.font = textFont
            case .image:
                button.setImage(imageSources.0[i], for: .normal)
                button.setImage(imageSources.1[i], for: .selected)
            case .hybrid:
                button.setTitleColor(textColor, for: .normal)
                button.titleLabel?.font = textFont
                button.setTitle(hybridSources.0[i], for: .normal)
                button.setImage(hybridSources.1[i], for: .normal)
                button.setImage(hybridSources.2[i], for: .selected)
            }
            contentSizeWidth += width
        }
        scrollView.contentSize = CGSize(width: contentSizeWidth, height: 0)
        let index = min(max(selectedIndex, 0), itemsArray.count-1)
        let selectedButton = itemsArray[index]
        selectedButton.isSelected = true
        fixCoverAndSliderFrame(originFrame: selectedButton.frame, upSpace: coverUpDownSpace)
    }
    @objc private func selectedButton(sender: UIButton) {
        isTapItem = true
        selectedIndex = sender.tag
        scrollView.isUserInteractionEnabled = false
    }
}
extension ZSegmentedControl {
    fileprivate func updateScrollViewOffset() {
        if itemsArray.count == 0 { return }
        let index = min(max(selectedIndex, 0), itemsArray.count)
        delegate?.segmentedControlSelectedIndex(index, animated: isTapItem, segmentedControl: self)
        let currentButton = self.itemsArray[index]
        let offset = getScrollViewCorrectOffset(by: currentButton)
        let duration = sliderAnimated ? 0.3 : 0
        UIView.animate(withDuration: duration, animations: {
            self.fixCoverAndSliderFrame(originFrame: currentButton.frame, upSpace: self.coverUpDownSpace)
            self.itemsArray.forEach({ (button) in
                button.setTitleColor(self.textColor, for: .normal)
                button.isSelected = false
                button.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
            currentButton.setTitleColor(self.textSelectedColor, for: .normal)
            currentButton.isSelected = true
            let scale = self.selectedScale
            currentButton.transform = CGAffineTransform(scaleX: scale, y: scale)
            self.scrollView.setContentOffset(offset, animated: true)
        }) { _ in
            self.isTapItem = false
            self.scrollView.isUserInteractionEnabled = true
        }
    }
    
    fileprivate func getScrollViewCorrectOffset(by item: UIButton) -> CGPoint {
        var offsetx = item.center.x - frame.size.width/2
        let offsetMax = scrollView.contentSize.width - frame.size.width
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
        if !sliderAnimated { return }
        
        let percent = sliderTackingScale-floor(sliderTackingScale)
        let currentIndex = Int(sliderTackingScale)
        var targetIndex = currentIndex
        if percent < 0 {
            targetIndex = currentIndex-1
        } else if percent > 0 {
            targetIndex = currentIndex+1
        }
        print(currentIndex, targetIndex)
        if targetIndex < 0 || targetIndex > itemsArray.count-1 { return }
        let currentButton = itemsArray[currentIndex]
        let targentButton = itemsArray[targetIndex]
        let centerXChange = (targentButton.center.x-currentButton.center.x)*abs(percent)
        let widthChange = (targentButton.frame.size.width-currentButton.frame.size.width)*abs(percent)
        var frame = currentButton.frame
        frame.size.width += widthChange
        fixCoverAndSliderFrame(originFrame: frame, upSpace: coverUpDownSpace)
        var center = currentButton.center
        center.x += centerXChange
        coverView.center = center
        
        
        var sliderCenter = slider.center
        sliderCenter.x = coverView.center.x
        slider.center = sliderCenter
        
        /// scale
        let scale = (selectedScale-1)*abs(percent)
        let targetTx = 1 + scale
        let currentTx = selectedScale - scale
        currentButton.transform = CGAffineTransform(scaleX: currentTx, y: currentTx)
        targentButton.transform = CGAffineTransform(scaleX: targetTx, y: targetTx)
        
        let currentColor = averageColor(fromColor: textSelectedColor, toColor: textColor, percent: abs(percent))
        let targetColor = averageColor(fromColor: textColor, toColor: textSelectedColor, percent: abs(percent))
        currentButton.setTitleColor(currentColor, for: .normal)
        targentButton.setTitleColor(targetColor, for: .normal)
    }
    
    fileprivate func fixCoverAndSliderFrame(originFrame: CGRect, upSpace: CGFloat) {
        var newFrame = originFrame
        newFrame.origin.y = upSpace
        newFrame.size.height -= upSpace*2
        coverView.frame = newFrame
        
        guard let config = sliderConfig else { return }
        switch config.0 {
        case .topWidthHeight(let height):
            newFrame.origin.y = 0
            newFrame.size.height = height
        case .bottomWithHight(let height):
            newFrame.origin.y = originFrame.size.height-height
            newFrame.size.height = height
        }
        switch config.1 {
        case .fixedWidth(let width):
            newFrame.size.width = width
        case .adaptiveSpace(let space):
            newFrame.size.width = originFrame.size.width-2*space
        }
        slider.frame = newFrame
        
        var sliderCenter = slider.center
        sliderCenter.x = coverView.center.x
        slider.center = sliderCenter
    }
}
/// scrollViewDelegate
extension ZSegmentedControl {
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

