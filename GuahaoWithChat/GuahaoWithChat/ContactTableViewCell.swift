//
//  ContactTableViewCell.swift
//  GuahaoWithChat
//
//  Created by Jeff Wong on 15/11/5.
//  Copyright © 2015年 Jeff. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    let headImage = UIImageView()
    let nameLabel = UILabel()
    private let unreadLabel = UILabel()
    private var unreadCount: UInt = 0
    
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
        
        unreadLabel.backgroundColor = UIColor.redColor()
        unreadLabel.textColor = UIColor.whiteColor()
        unreadLabel.textAlignment = .Center
        unreadLabel.font = UIFont.systemFontOfSize(10)
        unreadLabel.layer.cornerRadius = 8
        unreadLabel.layer.masksToBounds = true
        unreadLabel.hidden = true
        
        contentView.addSubview(headImage)
        contentView.addSubview(nameLabel)
        contentView.addSubview(unreadLabel)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        headImage.frame = CGRectMake(8, 8, 44, 44)
        nameLabel.frame = CGRectMake(
            headImage.frame.maxX + 5,
            0,
            contentView.frame.width - headImage.frame.maxY - 10,
            21)
        nameLabel.center.y = contentView.frame.height / 2
        
        setUnreadCountAutoExpand(unreadCount)
    }
    
    /**
     设置未读条数
     
     - Parameter count: 未读数
     */
    func setUnreadCount(count: UInt?) {
        guard let count = count else {
            return
        }
        unreadCount = count
        setNeedsLayout()
    }
    
    private func setUnreadCountAutoExpand(count: UInt) {
        unreadLabel.frame = CGRectMake(headImage.frame.maxX - 8, 2, 0, 16)
        if count == 0 {
            unreadLabel.hidden = true
        }else if count > 0 && count < 10 {
            unreadLabel.frame.size.width = 16
            unreadLabel.text = "\(count)"
            unreadLabel.hidden = false
        }else if count >= 10 && count < 100 {
            unreadLabel.frame.size.width = 21
            unreadLabel.text = "\(count)"
            unreadLabel.hidden = false
        }else if count < 1000 {
            unreadLabel.frame.size.width = 26
            unreadLabel.text = "\(count)"
            unreadLabel.hidden = false
        }else {
            unreadLabel.frame.size.width = 26
            unreadLabel.text = "..."
            unreadLabel.hidden = false
        }
    }
    
    class var cellHeight: CGFloat {
        return 60
    }
}
