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
        label = UILabel()
        label.textAlignment = .Center
        label.numberOfLines = 2
        contentView.addSubview(label)
        
        label.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(contentView).inset(8)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundView = GHCollectionViewCellBackgroudView(
            frame: frame,
            bgColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.3))
        selectedBackgroundView = GHCollectionViewCellBackgroudView(
            frame: frame,
            bgColor: UIColor(red: 0.529, green: 0.808, blue: 0.922, alpha: 1))
    }
}
