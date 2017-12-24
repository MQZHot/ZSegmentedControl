//
//  ViewController.swift
//  ZSegmentedControl
//
//  Created by mengqingzheng on 2017/12/6.
//  Copyright © 2017年 MQZHot. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var button: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = .init(rawValue: 0)
        view.backgroundColor = UIColor.gray
        
        button.setImage(#imageLiteral(resourceName: "p1"), for: .normal)
        button.setImage(UIImage(), for: .selected)
    }
    
    @IBAction func button(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        sender.layoutSubviews()
    }
}
