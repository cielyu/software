//
//  ChatListTableViewCell.swift
//  GuahaoWithChat
//
//  Created by Jeff Wong on 15/11/4.
//  Copyright © 2015年 Jeff. All rights reserved.
//

import UIKit

class ChatListTableViewCell: UITableViewCell {
    let headImage = UIImageView()
    let nameLabel = UILabel()
    let unreadLabel = UILabel()
    var unreadCount: UInt = 0
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
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
        
        headImage.frame = CGRectMake(8, 8, 64, 64)
        nameLabel.frame = CGRectMake(
            headImage.frame.maxX + 10,
            headImage.frame.minY,
            contentView.frame.width - headImage.frame.maxY - 15,
            21)
        
        setUnreadCountAutoExpand(unreadCount)
    }
    
    /**
     背景交替变色
     
     - Parameter highlighted: 是否高亮（白色）
     */
    func setCellBackgroundColor(highlighted: Bool) {
        if highlighted {
            contentView.backgroundColor = UIColor.whiteColor()
        }else {
            contentView.backgroundColor = UIColor(red: 0.964, green: 0.964, blue: 0.964, alpha: 1)
        }
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
        return 80
    }
}
