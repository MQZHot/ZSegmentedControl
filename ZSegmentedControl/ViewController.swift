//
//  ViewController.swift
//  ZSegmentedControl
//
//  Created by mengqingzheng on 2017/12/6.
//  Copyright © 2017年 MQZHot. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var segmentedControl6: ZSegmentedControl!
    var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = .init(rawValue: 0)
        view.backgroundColor = .lightGray
        
        let width = UIScreen.main.bounds.size.width
        
        /// example - 00
        let segmentedControl = ZSegmentedControl(frame: CGRect(x: 0, y: 0, width: 160, height: 30))
        segmentedControl.backgroundColor = UIColor.red
        segmentedControl.textColor = UIColor.white
        segmentedControl.textSelectedColor = UIColor.red
        segmentedControl.setCover(color: .white, cornerRadius: 15)
        segmentedControl.setTitles(["评论我的","通知"], style: .fixedWidth(80))
        segmentedControl.layer.cornerRadius = 15
        navigationItem.titleView = segmentedControl
        
        /// example - 01
        let segmentedControl1 = ZSegmentedControl(frame: CGRect(x: 0, y: 0, width: width, height: 40))
        segmentedControl1.textFont = UIFont.systemFont(ofSize: 17)
        segmentedControl1.backgroundColor = UIColor.white
        segmentedControl1.textSelectedColor = .red
        segmentedControl1.setTitles(["one","two","hellow world","three"], style: .adaptiveSpace(10))
        segmentedControl1.setSilder(backgroundColor: .red, position: .bottomWithHight(4), widthStyle: .adaptiveSpace(0))
        view.addSubview(segmentedControl1)
        
        /// example - 02
        let selectedImages = [#imageLiteral(resourceName: "p1"), #imageLiteral(resourceName: "p2"), #imageLiteral(resourceName: "p3"), #imageLiteral(resourceName: "p4"), #imageLiteral(resourceName: "p5"), #imageLiteral(resourceName: "p6"), #imageLiteral(resourceName: "p7"), #imageLiteral(resourceName: "p8")]
        let images = [#imageLiteral(resourceName: "sp1"), #imageLiteral(resourceName: "sp2"), #imageLiteral(resourceName: "sp3"), #imageLiteral(resourceName: "sp4"), #imageLiteral(resourceName: "sp5"), #imageLiteral(resourceName: "sp6"), #imageLiteral(resourceName: "sp7"), #imageLiteral(resourceName: "sp8")]
        let segmentedControl2 = ZSegmentedControl(frame: CGRect(x: 0, y: 50, width: width, height: 40))
        segmentedControl2.selectedIndex = 2
        segmentedControl2.textFont = UIFont.systemFont(ofSize: 17)
        segmentedControl2.backgroundColor = UIColor.cyan
        segmentedControl2.setCover(color: .orange)
        segmentedControl2.setImages(images, selectedImages: selectedImages, fixedWidth: 80)
        segmentedControl2.setSilder(backgroundColor: .purple, position: .topWidthHeight(4), widthStyle: .adaptiveSpace(0))
        view.addSubview(segmentedControl2)
        
        /// example - 03
        let frame = CGRect(x: 0, y: 100, width: width, height: 40)
        let titles = ["头条","中国足球","国际足球","要闻","新时代","财经","科技","热点"]
        let segmentedControl3 = ZSegmentedControl(frame: frame)
        segmentedControl3.backgroundColor = UIColor.white
        segmentedControl3.bounces = true
        segmentedControl3.textColor = UIColor.black
        segmentedControl3.textSelectedColor = UIColor.red
        segmentedControl3.selectedScale = 1.3
        segmentedControl3.setTitles(titles, style: .adaptiveSpace(10))
        view.addSubview(segmentedControl3)
        
        /// example - 04
        let frame4 = CGRect(x: 0, y: 150, width: width, height: 40)
        let titles4 = ["正在热映","即将上映","小视频","排行榜"]
        let images4 = [nil, nil, #imageLiteral(resourceName: "video"), nil]
        
        let segmentedControl4 = ZSegmentedControl(frame: frame4)
        segmentedControl4.backgroundColor = UIColor.white
        segmentedControl4.bounces = true
        segmentedControl4.textColor = UIColor.gray
        segmentedControl4.textSelectedColor = UIColor.red
        segmentedControl4.setHybridResource(titles4, images: images4, fixedWidth: width/4)
        segmentedControl4.setSilder(backgroundColor: .red, position: .bottomWithHight(3), widthStyle: .fixedWidth(25))
        view.addSubview(segmentedControl4)
        
        /// example - 05
        let frame5 = CGRect(x: 0, y: 200, width: width, height: 60)
        let titles5 = ["chicken","Donuts","cup","tea","fruit juice","teapot","ice cream","ice cream"]
        let images5 = [#imageLiteral(resourceName: "p1"), #imageLiteral(resourceName: "p2"), #imageLiteral(resourceName: "p3"), #imageLiteral(resourceName: "p4"), #imageLiteral(resourceName: "p5"), #imageLiteral(resourceName: "p6"), #imageLiteral(resourceName: "p7"), #imageLiteral(resourceName: "p8")]
        let segmentedControl5 = ZSegmentedControl(frame: frame5)
        segmentedControl5.backgroundColor = UIColor.purple
        segmentedControl5.bounces = true
        segmentedControl5.textColor = UIColor.green
        segmentedControl5.textSelectedColor = UIColor.blue
        segmentedControl5.setHybridResource(titles5, images: images5, selectedImages: nil, style: .imageTopWithSpace(10), fixedWidth: 80)
        segmentedControl5.setSilder(backgroundColor: .cyan, position: .bottomWithHight(3), widthStyle: .adaptiveSpace(0))
        view.addSubview(segmentedControl5)
        
        /// example - 06
        let frame6 = CGRect(x: 0, y: 270, width: width, height: 40)
        let titles6 = ["微头条","股票","国际足球","传媒","中国好表演","语录","星座","美图","三农","宠物","养生","美食"]
        segmentedControl6 = ZSegmentedControl(frame: frame6)
        segmentedControl6.delegate = self
        segmentedControl6.backgroundColor = UIColor.white
        segmentedControl6.bounces = true
        segmentedControl6.textColor = UIColor.black
        segmentedControl6.textSelectedColor = UIColor.white
        segmentedControl6.selectedScale = 1.2
        segmentedControl6.setCover(color: .red, upDowmSpace: 6, cornerRadius: 14)
        segmentedControl6.setTitles(titles6, style: .adaptiveSpace(10))
        view.addSubview(segmentedControl6)
        
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 310, width: width, height: view.frame.size.height-310))
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize(width: CGFloat(titles6.count)*width, height:0)
        for i in 0..<titles6.count {
            let label = UILabel()
            label.text = "-----\(i)----"
            label.textAlignment = .center
            label.backgroundColor = UIColor(red: CGFloat(arc4random()%256)/255, green: CGFloat(arc4random()%256)/255, blue: CGFloat(arc4random()%256)/255, alpha: 1)
            label.frame = CGRect(x: width*CGFloat(i), y: 0, width: width, height: scrollView.frame.size.height)
            scrollView.addSubview(label)
        }
        view.addSubview(scrollView)
    }
}

extension ViewController: ZSegmentedControlSelectedProtocol {
    func segmentedControlSelectedIndex(_ index: Int, animated: Bool, segmentedControl: ZSegmentedControl) {
        let offsetX = CGFloat(index)*scrollView.frame.size.width
        let offsetY = scrollView.contentOffset.y
        let offset = CGPoint(x: offsetX, y: offsetY)
        scrollView.setContentOffset(offset, animated: animated)
    }
}
extension ViewController: UIScrollViewDelegate {
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        segmentedControl6.selectedIndex = index
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndScrollingAnimation(scrollView)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        segmentedControl6.contentScrollViewDidScroll(scrollView)
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        segmentedControl6.contentScrollViewWillBeginDragging()
    }
}
