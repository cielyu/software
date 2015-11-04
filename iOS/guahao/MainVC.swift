//
//  MainVC.swift
//  guahao
//
//  Created by Jeff Wong on 15/11/1.
//  Copyright © 2015年 Jeff. All rights reserved.
//

import UIKit

enum MainVCType {
    case Hospital
    case Department
    case Doctor
}

class MainVC: ZFSlideViewController {
    var type: MainVCType = .Hospital
    var paramValue1: String?
    var paramValue2: String?
    
    override func viewDidLoad() {
        defer {
            paramValue1 = nil
            paramValue2 = nil
        }
        
        let left = LeftVC()
        left.rootVC = self
        let middle = MiddleVC(type: type)
        middle.paramValue1 = paramValue1
        middle.paramValue2 = paramValue2
        middle.rootVC = self
        
        leftVC = left
        middleVC = UINavigationController(rootViewController: middle)
        
        leftViewWidth = 200
        
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
