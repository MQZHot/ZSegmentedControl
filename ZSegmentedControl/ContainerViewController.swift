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
        
        let width = view.frame.size.width
        /// example - 0
        let frame = CGRect(x: 0, y: 0, width: width, height: 40)
        let titles = ["hello-world","one","three-apple","four","five-cats","six","seven","eight"]
        segmentedControl = ZSegmentedControl(frame: frame)
        segmentedControl.delegate = self
        segmentedControl.backgroundColor = UIColor.lightGray
        segmentedControl.bounces = true
        segmentedControl.selectedIndex = 2
        
        segmentedControl.textColor = UIColor.black
        segmentedControl.textSelectedColor = UIColor.red

//        segmentedControl.moveDivision = true
        
//        segmentedControl.setCover(color: .green, upDowmSpace: 5, cornerRadius: 17)
        
        
        let images = [#imageLiteral(resourceName: "sp1"), #imageLiteral(resourceName: "sp2"), #imageLiteral(resourceName: "sp3"), #imageLiteral(resourceName: "sp4"), #imageLiteral(resourceName: "sp5"), #imageLiteral(resourceName: "sp6"), #imageLiteral(resourceName: "sp7"), #imageLiteral(resourceName: "sp8")]
        let selectedImages = [#imageLiteral(resourceName: "p1"),nil,#imageLiteral(resourceName: "p3"),#imageLiteral(resourceName: "p4"),#imageLiteral(resourceName: "p5"),#imageLiteral(resourceName: "p6"),#imageLiteral(resourceName: "p7"),#imageLiteral(resourceName: "p8")]
//        segmentedControl.setTitles(titles, adaptiveLeading: 10)
//        segmentedControl.setImages(images, selectedImages: selectedImages, fixedWidth: 80)
        segmentedControl.setHybridResource(titles, images: images, selectedImages: selectedImages, style: .normalWithSpace(0), fixedWidth: 80)
        view.addSubview(segmentedControl)
        
        scrollView.contentSize = CGSize(width: CGFloat(titles.count)*width, height:0)
        for i in 0..<titles.count {
            let subVC = UIViewController()
            subVC.view.backgroundColor = UIColor(red: CGFloat(arc4random()%256)/255, green: CGFloat(arc4random()%256)/255, blue: CGFloat(arc4random()%256)/255, alpha: 1)
            addChildViewController(subVC)
            subVC.view.frame = CGRect(x: width*CGFloat(i), y: 0, width: width, height: scrollView.frame.size.height)
            scrollView.addSubview(subVC.view)
        }
        
    }
}
extension ContainerViewController: ZSegmentedControlSelectedProtocol {
    func segmentedControlSelectedIndex(_ index: Int, animated: Bool, segmentedControl: ZSegmentedControl) {
        let offsetX = CGFloat(index)*scrollView.frame.size.width
        let offsetY = scrollView.contentOffset.y
        let offset = CGPoint(x: offsetX, y: offsetY)
        scrollView.setContentOffset(offset, animated: animated)
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
        segmentedControl.tackingScale = index
    }
}
