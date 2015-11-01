//
//  MainVC.swift
//  guahao
//
//  Created by Jeff Wong on 15/11/1.
//  Copyright © 2015年 Jeff. All rights reserved.
//

import UIKit

class MainVC: ZFSlideViewController {
    
    override func viewDidLoad() {
        leftVC = LeftVC()
        middleVC = UINavigationController(rootViewController: MiddleVC())
        leftViewWidth = 200
        
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
