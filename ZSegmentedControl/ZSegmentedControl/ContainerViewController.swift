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
    var titles = ["hello-world","one","two","three","four","five","six","seven","eight"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = .init(rawValue: 0)
        view.backgroundColor = UIColor.gray
        
        let width = view.frame.size.width
        let frame = CGRect(x: 0, y: 0, width: width, height: 40)
        segmentedControl = ZSegmentedControl(frame: frame, titles: titles, widthStyle: .sizeToFitWithEdge(10))
        segmentedControl.textColor = UIColor.white
        segmentedControl.backgroundColor = UIColor.blue
//        segmentedControl.selectedIndex = 1
        segmentedControl.assistColor = UIColor.green
        segmentedControl.assistStyle = .background
        segmentedControl.delegate = self
        view.addSubview(segmentedControl)
        
        for i in 0..<titles.count {
            let subVC = SubTableViewController()
            addChildViewController(subVC)
        }
        scrollView.contentSize = CGSize(width: CGFloat(titles.count)*width, height:0)
        let firstVC = childViewControllers.first!
        firstVC.view.frame = scrollView.bounds
        scrollView.addSubview(firstVC.view)
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
        let subVC = childViewControllers[index]
        if subVC.view.superview != nil { return }
        subVC.view.frame = scrollView.bounds
        scrollView.addSubview(subVC.view)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndScrollingAnimation(scrollView)
    }
//    // 滚动结束后调用
//    - (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
//    // 获得索引
//    NSUInteger index = scrollView.contentOffset.x / self.VCScrollView.frame.size.width;
//    // 滚动标题栏
//    Name_Label *titleLable = (Name_Label *)self.titleScrollView.subviews[index];
//
//    //设置每次的偏移量为label的一半
//    CGFloat offsetx = titleLable.center.x - self.titleScrollView.frame.size.width * 0.5;
//    //索引滚动的最大偏移量
//    CGFloat offsetMax = self.titleScrollView.contentSize.width - self.titleScrollView.frame.size.width;
//
//    if (offsetx < 0) {
//    offsetx = 0;
//    }else if (offsetx > offsetMax){
//    offsetx = offsetMax;
//    }
//
//    CGPoint offset = CGPointMake(offsetx, self.titleScrollView.contentOffset.y);
//    //    self.titleScrollView.contentOffset = offset;
//    [self.titleScrollView setContentOffset:offset animated:YES];
//
//    // 添加控制器
//
//    UIViewController *newsVc = self.childViewControllers[index];
//    //        newsVc.index = index;
//
//    if (newsVc.view.superview){
//    return;
//    }
//    newsVc.view.frame = scrollView.bounds;
//    [self.VCScrollView addSubview:newsVc.view];
//
//    }
    
//    //正在滚动
//    - (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//
//
//    NSUInteger index = scrollView.contentOffset.x / kWidth;
//    Name_Label *nameLabel = self.titleScrollView.subviews[index];
//
//    for (int i = 0; i < self.titleScrollView.subviews.count; i++) {
//    Name_Label *Label = self.titleScrollView.subviews[i];
//    if (![nameLabel isEqual:Label]) {
//    Label.scale = 0.0;
//    }
//    nameLabel.scale = 1.0;
//    }
//
//
//    }
}
