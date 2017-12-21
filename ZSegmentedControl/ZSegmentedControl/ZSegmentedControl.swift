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
}
/// 点击
protocol ZSegmentedControlSelectedProtocol {
    func segmentedControlSelectedIndex(_ index: Int, segmentedControl: ZSegmentedControl)
}
class ZSegmentedControl: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContentView()
    }
    func setTitles(_ titles: [String], width: CGFloat) {
        resourceType = .text
        titleSources = titles
        totalItemsCount = titles.count
        setupItems(width: width)
    }
    
    func setImages(_ images: [UIImage], width: CGFloat) {
        resourceType = .image
        imageSources = images
        totalItemsCount = images.count
        setupItems(width: width)
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
        didSet {
            sliderView.backgroundColor = sliderColor
        }
    }
    var scrollOffset: CGFloat = 0 {
        didSet {
            let percent = scrollOffset-CGFloat(selectedIndex)
            var targetIndex = selectedIndex
            if percent < 0 {
                targetIndex = selectedIndex-1
            } else if percent > 0 {
                targetIndex = selectedIndex+1
            }
            if targetIndex < 0 || targetIndex > selectedItemsArray.count-1 { return }
            let button = selectedItemsArray[selectedIndex]
            let targetButton = selectedItemsArray[targetIndex]
            
            let widthChange = (button.frame.size.width-targetButton.frame.size.width)*percent
            let xChange = button.frame.size.width*percent
            var frame = button.frame
            frame.origin.x += xChange
            frame.size.width += widthChange
            sliderView.frame = frame
            sliderViewMask.frame = sliderView.frame
        }
    }
    
    var selectedIndex: Int = 0 {
        didSet {
            if selectedIndex<0||selectedIndex>selectedItemsArray.count-1 { return }
            self.delegate?.segmentedControlSelectedIndex(self.selectedIndex, segmentedControl: self)
            let button = selectedItemsArray[selectedIndex]
            UIView.animate(withDuration: 0.3, animations: {
                self.sliderView.frame = button.frame
                self.sliderViewMask.frame = button.frame
            }) { (completion) in
                var offsetx = button.center.x - self.frame.size.width/2
                let offsetMax = self.subScrollView.contentSize.width - self.frame.size.width
                if offsetx < 0 {
                    offsetx = 0
                }else if offsetx > offsetMax {
                    offsetx = offsetMax
                }
                let offset = CGPoint(x: offsetx, y: 0)
                self.subScrollView.setContentOffset(offset, animated: true)
            }
        }
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
    fileprivate var imageSources = [UIImage]()
    fileprivate var resourceType: ResourceType = .text
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
    
    fileprivate func setupItems(width: CGFloat) {
        itemsArray.forEach { $0.removeFromSuperview() }
        itemsArray.removeAll()
        selectedItemsArray.forEach { $0.removeFromSuperview() }
        selectedItemsArray.removeAll()
        for i in 0..<totalItemsCount {
            let x = CGFloat(i)*width
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
                button.setImage(imageSources[i], for: .normal)
            }
            
            
        }
        scrollView.contentSize = CGSize(width: CGFloat(titleSources.count)*width, height: 0)
        subScrollView.contentSize = CGSize(width: CGFloat(titleSources.count)*width, height: 0)
        let button = selectedItemsArray[selectedIndex]
        sliderView.frame = button.frame
        sliderViewMask.frame = sliderView.frame
    }
    @objc func selectedButton(sender: UIButton) {
        selectedIndex = sender.tag
//        delegate?.segmentedControlSelectedIndex(selectedIndex, segmentedControl: self)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension ZSegmentedControl: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.scrollView.contentOffset = scrollView.contentOffset
    }
}

