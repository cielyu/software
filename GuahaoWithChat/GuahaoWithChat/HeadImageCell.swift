//
//  HeadImageCell.swift
//  GuahaoWithChat
//
//  Created by Jeff Wong on 15/11/7.
//  Copyright © 2015年 Jeff. All rights reserved.
//

import UIKit

class HeadImageCell: UITableViewCell {
    let headImage = UIImageView()
    let nameLabel = UILabel()
    let telLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        headImage.image = UIImage(named: "ChatListCellPlaceHolder")
        
        nameLabel.textColor = UIColor.blackColor()
        telLabel.textColor = UIColor.grayColor()
        
        contentView.addSubview(headImage)
        contentView.addSubview(nameLabel)
        contentView.addSubview(telLabel)
        
        headImage.snp_makeConstraints { (make) -> Void in
            make.left.top.equalTo(contentView).offset(8)
            make.bottom.equalTo(contentView).offset(-8)
            make.width.equalTo(64)
        }
        nameLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(contentView).offset(8)
            make.left.equalTo(headImage.snp_right).offset(5)
            make.right.equalTo(contentView).offset(-8)
            make.height.equalTo(21)
        }
        telLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(nameLabel.snp_bottom)
            make.left.right.height.equalTo(nameLabel)
        }
    }
    
    static var cellHeight: CGFloat {
        return 80
    }
}
