//
//  GHButton.swift
//  GuahaoWithChat
//
//  Created by Jeff Wong on 15/11/7.
//  Copyright © 2015年 Jeff. All rights reserved.
//

import UIKit

class GHButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setBackgroundImage(UIImage(named: "btnNormal"), forState: .Normal)
        setBackgroundImage(UIImage(named: "btnHighlighted"), forState: .Highlighted)
        
        layer.cornerRadius = 5
        layer.borderWidth = 0.5
        layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).CGColor
        layer.masksToBounds = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
