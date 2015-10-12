//
//  GHCollectionViewCell.swift
//  guahao
//
//  Created by Jeff Wong on 15/10/11.
//  Copyright © 2015年 Jeff. All rights reserved.
//

import UIKit

class GHCollectionViewCell: UICollectionViewCell {
    var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        label = UILabel(frame: CGRectMake(0, 0, 34, 21))
        label.textAlignment = .Center
        label.center = CGPointMake(frame.width / 2, frame.height / 2)
        
        contentView.addSubview(label)
        
        contentView.layer.borderColor = UIColor.blueColor().CGColor
        contentView.layer.borderWidth = 1
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
