//
//  ViewController.swift
//  ZSegmentedControl
//
//  Created by mengqingzheng on 2017/12/6.
//  Copyright © 2017年 MQZHot. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = .init(rawValue: 0)
        view.backgroundColor = UIColor.gray
        
        let width = view.frame.size.width
        /// example - 0
        let frame = CGRect(x: 0, y: 0, width: width, height: 40)
        let titles = ["hello-world","one","two","three-apple","four","five-cats","six","seven","eight"]
        
        let segmentedControl = ZSegmentedControl(frame: frame)
        segmentedControl.backgroundColor = UIColor.lightGray
        segmentedControl.bounces = true
        segmentedControl.setTitles(titles, fixedWidth: 80)
        segmentedControl.textColor = UIColor.yellow
        segmentedControl.textSelectedColor = UIColor.red
//        segmentedControl.sliderColor = UIColor.green
        view.addSubview(segmentedControl)
        
    }
    
}
