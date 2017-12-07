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
        let titles = ["hello-world","one","two","three","four","five","six","seven","eight"]
        let segmentedControl = ZSegmentedControl(frame: frame, titles: titles, widthStyle: .sizeToFitWithEdge(10))
        segmentedControl.textColor = UIColor.white
        segmentedControl.backgroundColor = UIColor.blue
        segmentedControl.selectedIndex = 1
        segmentedControl.assistColor = UIColor.green
        segmentedControl.assistStyle = .background
        segmentedControl.delegate = self
        view.addSubview(segmentedControl)
        
        /// example - 1
        let frame1 = CGRect(x: 0, y: 60, width: width, height: 40)
        let images1 = [#imageLiteral(resourceName: "p1"),#imageLiteral(resourceName: "p2"),#imageLiteral(resourceName: "p3"),#imageLiteral(resourceName: "p4"),#imageLiteral(resourceName: "p5"),#imageLiteral(resourceName: "p6"),#imageLiteral(resourceName: "p7"),#imageLiteral(resourceName: "p8")]
        let segmentedControl1 = ZSegmentedControl(frame: frame1, images: images1, itemWidth: 80)
        segmentedControl1.assistColor = UIColor.blue
        segmentedControl1.assistStyle = .bottom(5)
        segmentedControl1.delegate = self
        view.addSubview(segmentedControl1)
        
        /// example - 2
        let frame2 = CGRect(x: 0, y: 120, width: width, height: 20)
        let titles2 = ["one","two","three","four","five","six","seven","eight","nine","ten"]
        let images2 = [#imageLiteral(resourceName: "p1"),#imageLiteral(resourceName: "p2"),#imageLiteral(resourceName: "p3"),#imageLiteral(resourceName: "p4"),#imageLiteral(resourceName: "p5"),#imageLiteral(resourceName: "p6"),#imageLiteral(resourceName: "p7"),#imageLiteral(resourceName: "p8"),#imageLiteral(resourceName: "p1")]
        let segmentedControl2 = ZSegmentedControl(frame: frame2, hybridSources: (titles2, images2), widthStyle: .customizeWithWidth(80))
        segmentedControl2.backgroundColor = UIColor.purple
        segmentedControl2.assistColor = UIColor.blue
        segmentedControl2.assistStyle = .bottom(5)
        segmentedControl2.delegate = self
        segmentedControl2.hybridType = .normalWithSpace(80)
        view.addSubview(segmentedControl2)
        
        /// example - 3
        let frame3 = CGRect(x: 0, y: 180, width: width, height: 60)
        let titles3 = ["one","two","three","four","five","six","seven","eight","nine","ten"]
        let images3 = [#imageLiteral(resourceName: "p1"),#imageLiteral(resourceName: "p2"),#imageLiteral(resourceName: "p3"),#imageLiteral(resourceName: "p4"),#imageLiteral(resourceName: "p5"),#imageLiteral(resourceName: "p6"),#imageLiteral(resourceName: "p7"),#imageLiteral(resourceName: "p8"),#imageLiteral(resourceName: "p1"),#imageLiteral(resourceName: "p1"),#imageLiteral(resourceName: "p1")]
        let segmentedControl3 = ZSegmentedControl(frame: frame3, hybridSources: (titles3, images3), widthStyle: .customizeWithWidth(80))
        segmentedControl3.backgroundColor = UIColor.purple
        segmentedControl3.assistColor = UIColor.blue
        segmentedControl3.assistStyle = .bottom(5)
        segmentedControl3.delegate = self
        segmentedControl3.hybridType = .imageTopWithSpace(5)
        view.addSubview(segmentedControl3)
    }
    
}

extension ViewController: ZSegmentedControlSelectedProtocol {
    func segmentedControlSelectedIndex(_ index: Int, segmentedControl: ZSegmentedControl) {
        print(index)
    }
}
