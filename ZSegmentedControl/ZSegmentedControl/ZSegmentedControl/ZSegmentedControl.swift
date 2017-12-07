//
//  ZSegmentedControl.swift
//  ZSegmentedControl
//
//  Created by mengqingzheng on 2017/12/6.
//  Copyright © 2017年 MQZHot. All rights reserved.
//

import UIKit

public enum ZSegmentedControlWidthStyle {
    case sizeToFitWithEdge(CGFloat)
    case customizeWithWidth(CGFloat)
    var sizeToFit: Bool {
        switch self {
        case .sizeToFitWithEdge(_): return true
        case .customizeWithWidth(_): return false
        }
    }
    var width: CGFloat {
        switch self {
        case .customizeWithWidth(let width): return width
        default: return 0
        }
    }
    var edge: CGFloat {
        switch self {
        case .sizeToFitWithEdge(let edge): return edge
        default: return 0
        }
    }
}
enum ZSegmentedControlStyle {
    case text
    case image
    case hybrid
}
enum ZSegmentedControlAssistStyle {
    case background
    case bottom(CGFloat)
    case top(CGFloat)
    case none
}
/// 混合类型
enum ZSegmentedControlHybridType {
    case normalWithSpace(CGFloat)
    case imageRightWithSpace(CGFloat)
    case imageTopWithSpace(CGFloat)
    case imageBottomWithSpace(CGFloat)
}
/// 点击
protocol ZSegmentedControlSelectedProtocol {
    func segmentedControlSelectedIndex(_ index: Int, segmentedControl: ZSegmentedControl)
}
class ZSegmentedControl: UIView {
    
    public init (frame: CGRect, titles: [String], selectedTitles: [String]? = nil, widthStyle: ZSegmentedControlWidthStyle) {
        super.init (frame: frame)
        typeStyle = .text
        self.widthStyle = widthStyle
        titleSources = titles
        itemsCount = titles.count
        setupItems()
    }
    
    public init (frame: CGRect, images: [UIImage], itemWidth: CGFloat) {
        super.init (frame: frame)
        imageStyleWidth = itemWidth
        typeStyle = .image
        imageSources = images
        itemsCount = images.count
        setupItems()
    }
    
    public init (frame: CGRect, hybridSources: ([String?], [UIImage?]), widthStyle: ZSegmentedControlWidthStyle) {
        super.init (frame: frame)
        typeStyle = .hybrid
        self.widthStyle = widthStyle
        self.hybridSources = hybridSources
        itemsCount = max(hybridSources.0.count, hybridSources.1.count)
        setupItems()
    }
    
    /// public
    var delegate: ZSegmentedControlSelectedProtocol?
    var bounces: Bool = false {
        didSet { scrollView.bounces = bounces }
    }
    var selectedIndex: Int = 0 {
        didSet {
            buttonArray.forEach { $0.isSelected = selectedIndex == $0.tag ? true:false }
            updateAssistView()
        }
    }
    var textFont: UIFont = UIFont.systemFont(ofSize: 15)
    var textColor: UIColor = UIColor.black
    var textSelectedColor: UIColor = UIColor.red
    var assistStyle: ZSegmentedControlAssistStyle = .none
    var assistColor: UIColor?
    var hybridType: ZSegmentedControlHybridType = .normalWithSpace(0)
    
    /// private
    fileprivate lazy var scrollView = UIScrollView()
    fileprivate var itemsCount: Int = 0
    fileprivate lazy var titleSources = [String]()
    fileprivate lazy var imageSources = [UIImage]()
    fileprivate lazy var hybridSources: ([String?], [UIImage?]) = ([], [])
    fileprivate lazy var buttonArray = [UIButton]()
    fileprivate lazy var assistView = UIView()
    fileprivate var typeStyle: ZSegmentedControlStyle!
    fileprivate var widthStyle: ZSegmentedControlWidthStyle!
    fileprivate var imageStyleWidth: CGFloat = 0
    fileprivate func setupItems() {
        backgroundColor = UIColor.white
        scrollView.frame = bounds
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        addSubview(scrollView)
        scrollView.addSubview(assistView)
        for i in 0..<itemsCount {
            let button = UIButton(type: .custom)
            button.tag = i
//            button.clipsToBounds = true
            button.addTarget(self, action: #selector(segmentedSelectedIndex), for: .touchUpInside)
            scrollView.addSubview(button)
            buttonArray.append(button)
        }
        selectedIndex = 0
    }
    @objc private func segmentedSelectedIndex(_ sender: UIButton) {
//        updateItems()
//        updateAssistView()
        selectedIndex = sender.tag
        delegate?.segmentedControlSelectedIndex(sender.tag, segmentedControl: self)
    }
    
    fileprivate func updateItems() {
        switch typeStyle {
        case .text:
            var totalWidth: CGFloat = 0
            for (index, button) in buttonArray.enumerated() {
                if !widthStyle.sizeToFit {
                    let width = widthStyle.width
                    button.frame = CGRect(x: CGFloat(index)*width, y: 0, width: width, height: frame.size.height)
                    totalWidth += width
                } else {
                    let edge = widthStyle.edge
                    let text = titleSources[index] as NSString
                    let width = text.size(withAttributes: [.font: textFont]).width + edge*2
                    button.frame = CGRect(x: totalWidth, y: 0, width: width, height: frame.size.height)
                    totalWidth += width
                }
                button.setTitle(titleSources[index], for: .normal)
                button.setTitleColor(textColor, for: .normal)
                button.setTitleColor(textSelectedColor, for: .selected)
                button.titleLabel?.font = textFont
            }
            scrollView.contentSize = CGSize(width: totalWidth, height: 0)
            
        case .image:
            /// image frame
            for (index, button) in buttonArray.enumerated() {
                let image = imageSources[index]
                let maxWidth = imageStyleWidth
                let maxHeight = frame.size.height
                let fixedImage = constraintImageSize(image: image, maxWidth: maxWidth, maxHeight: maxHeight)
                button.setImage(fixedImage, for: .normal)
                button.frame = CGRect(x: CGFloat(index)*imageStyleWidth, y: 0, width: imageStyleWidth, height: maxHeight)
            }
            scrollView.contentSize = CGSize(width: CGFloat(itemsCount)*imageStyleWidth, height: 0)
            
        case .hybrid:
            var totalWidth: CGFloat = 0
            let titles = hybridSources.0
            let images = hybridSources.1
            for (index, button) in buttonArray.enumerated() {
                var text: String? = nil
                var image: UIImage? = nil
                if index < images.count { image = images[index]! }
                if index < titles.count { text = titles[index]! }
                
                
                
                if !widthStyle.sizeToFit {
                    let width = widthStyle.width/// 设定的宽度
                    button.frame = CGRect(x: CGFloat(index)*width, y: 0, width: width, height: frame.size.height)
                    switch hybridType {
                    case .normalWithSpace(let space):
                        var distance = space/2
                        if text == nil || image == nil { distance = 0 }
                        guard image != nil else { break }
                        var maxWidth = image!.size.width
                        if text != nil && text != "" { maxWidth = width/2 }
                        image = constraintImageSize(image: image!, maxWidth: maxWidth, maxHeight: frame.size.height)
                        button.imageEdgeInsets = UIEdgeInsetsMake(0, -distance, 0, distance)
                        button.titleEdgeInsets = UIEdgeInsetsMake(0, distance, 0, -distance)
                    case .imageRightWithSpace(let space):
                        var distance = space/2
                        if text == nil || image == nil { distance = 0 }
                        guard image != nil else { break }
                        var titleWidth = text?.size(withAttributes: [.font: textFont]).width ?? 0
                        titleWidth = min(width, titleWidth)
                        var maxWidth = image!.size.width
                        if text != nil && text != "" { maxWidth = width/2 }
                        image = constraintImageSize(image: image!, maxWidth: maxWidth, maxHeight: frame.size.height)
                        button.imageEdgeInsets = UIEdgeInsetsMake(0, titleWidth+distance, 0, -titleWidth-distance)
                        button.titleEdgeInsets = UIEdgeInsetsMake(0, -image!.size.width-distance, 0, image!.size.width+distance)
                        
                    case .imageBottomWithSpace(let space):
                        var distance = space/2
                        if text == nil || image == nil { distance = 0 }
                        guard image != nil else { break }
                        let titleWidth = button.titleLabel?.frame.size.width ?? 0
                        let titleHeight = button.titleLabel?.frame.size.height ?? 0
                        let maxWidth = width
                        let maxHeight = frame.size.height-space-titleHeight
                        image = constraintImageSize(image: image!, maxWidth: maxWidth, maxHeight: maxHeight)
                        
                        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, -titleHeight-distance, -titleWidth)
                        button.titleEdgeInsets = UIEdgeInsetsMake(-image!.size.height-distance, -image!.size.width, 0, 0)
                        
                    case .imageTopWithSpace(let space):
                        var distance = space/2
                        if text == nil || image == nil { distance = 0 }
                        guard image != nil else { break }
                        let titleWidth = button.titleLabel?.frame.size.width ?? 0
                        let titleHeight = button.titleLabel?.frame.size.height ?? 0
                        let maxWidth = width
                        let maxHeight = frame.size.height-space-titleHeight
                        image = constraintImageSize(image: image!, maxWidth: maxWidth, maxHeight: maxHeight)
                        
                        button.imageEdgeInsets = UIEdgeInsetsMake(-titleHeight-distance, 0, 0, -titleWidth)
                        button.titleEdgeInsets = UIEdgeInsetsMake(0, -image!.size.width, -image!.size.height-distance, 0)
                        button.contentHorizontalAlignment = .center
                        button.contentVerticalAlignment = .center
                    }
                    totalWidth += width
                } else {
                    let edge = widthStyle.edge
                    let text = titleSources[index] as NSString
                    let width = text.size(withAttributes: [.font: textFont]).width + edge*2
                    button.frame = CGRect(x: totalWidth, y: 0, width: width, height: frame.size.height)
                    totalWidth += width
                }
                
                button.setImage(image, for: .normal)
                button.setTitleColor(textColor, for: .normal)
                button.setTitleColor(textSelectedColor, for: .selected)
                button.titleLabel?.font = textFont
                button.setTitle(text, for: .normal)
            }
            scrollView.contentSize = CGSize(width: totalWidth, height: 0)
        default: break
        }
        updateAssistView()
    }
    /// 约束图片尺寸
    func constraintImageSize(image: UIImage, maxWidth: CGFloat, maxHeight: CGFloat) -> UIImage? {
        if image.size.height > maxHeight || image.size.width > maxWidth {
            let scale = image.size.width / image.size.height
            let size: CGSize
            if maxWidth-image.size.width > maxHeight-image.size.height {
                size = CGSize(width: maxHeight*scale, height: maxHeight)
            } else {
                size = CGSize(width: maxWidth, height: maxWidth/scale)
            }
            UIGraphicsBeginImageContextWithOptions(size, false, 0)
            image.draw(in: CGRect(origin: CGPoint.zero, size: size))
            let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return scaledImage
        } else {
            return image
        }
    }
    
    /// 更新高亮view
    func updateAssistView() {
        if selectedIndex < 0 || selectedIndex > itemsCount-1 {
            assistView.frame = .zero
            return
        }
        let button = buttonArray[selectedIndex]
        assistView.backgroundColor = assistColor
        var frame = button.frame
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            switch self.assistStyle {
            case .background:
                self.assistView.frame = frame
            case .bottom(let height):
                frame.origin.y = frame.size.height-height
                frame.size.height = height
                self.assistView.frame = frame
            case .top(let height):
                frame.size.height = height
                self.assistView.frame = frame
            default: break
            }
        }, completion: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateItems()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


