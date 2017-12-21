//
//  ContainerViewController.swift
//  ZSegmentedControl
//
//  Created by mengqingzheng on 2017/12/8.
//  Copyright © 2017年 MQZHot. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!

    var segmentedControl: ZSegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = .init(rawValue: 0)
        view.backgroundColor = UIColor.gray
        
        let width = view.frame.size.width
        /// example - 0
        let frame = CGRect(x: 0, y: 0, width: width, height: 40)
        let titles = ["hello-world","one","two","three-apple","four","five-cats","six","seven","eight"]
        segmentedControl = ZSegmentedControl(frame: frame)
        segmentedControl.backgroundColor = UIColor.lightGray
        segmentedControl.bounces = true
        segmentedControl.setTitles(titles, width: 80)
        segmentedControl.textColor = UIColor.yellow
        segmentedControl.textSelectedColor = UIColor.red
        segmentedControl.sliderColor = UIColor.green
        segmentedControl.delegate = self
        segmentedControl.selectedIndex = 5
        view.addSubview(segmentedControl)
        
        for i in 0..<titles.count {
            let subVC = SubTableViewController()
            subVC.view.frame = CGRect(x: width*CGFloat(i), y: 0, width: width, height: scrollView.frame.size.height)
            scrollView.addSubview(subVC.view)
            addChildViewController(subVC)
        }
        scrollView.contentSize = CGSize(width: CGFloat(titles.count)*width, height:0)
    }
}
extension ContainerViewController: ZSegmentedControlSelectedProtocol {
    func segmentedControlSelectedIndex(_ index: Int, segmentedControl: ZSegmentedControl) {
        let offsetX = CGFloat(index)*scrollView.frame.size.width
        let offsetY = scrollView.contentOffset.y
        let offset = CGPoint(x: offsetX, y: offsetY)
        scrollView.setContentOffset(offset, animated: true)
    }
}

extension ContainerViewController: UIScrollViewDelegate {
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        segmentedControl.selectedIndex = index
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndScrollingAnimation(scrollView)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = scrollView.contentOffset.x / scrollView.frame.size.width
        segmentedControl.scrollOffset = index
    }
}
