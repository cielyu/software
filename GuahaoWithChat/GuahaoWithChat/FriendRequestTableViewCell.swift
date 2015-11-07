//
//  FriendRequestTableViewCell.swift
//  GuahaoWithChat
//
//  Created by Jeff Wong on 15/11/5.
//  Copyright © 2015年 Jeff. All rights reserved.
//

import UIKit

protocol FriendRequestTableViewCellDelegate: NSObjectProtocol {
    func acceptFriendRequest(row: Int)
    func rejectFriendRequest(row: Int)
}

class FriendRequestTableViewCell: UITableViewCell {
    let headImage = UIImageView()
    let nameLabel = UILabel()
    let decriptionLabel = UILabel()
    let acceptBtn = GHButton()
    let rejectBtn = GHButton()
    // 标识
    var row = 0
    weak var delegate: FriendRequestTableViewCellDelegate?
    
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
        
        decriptionLabel.textColor = UIColor.grayColor()
        decriptionLabel.font = UIFont.systemFontOfSize(15)
        
        acceptBtn.setTitle("接受", forState: .Normal)
        acceptBtn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        acceptBtn.addTarget(self, action: Selector("accept"), forControlEvents: .TouchUpInside)
        
        rejectBtn.setTitle("拒绝", forState: .Normal)
        rejectBtn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        rejectBtn.addTarget(self, action: Selector("reject"), forControlEvents: .TouchUpInside)
        
        contentView.addSubview(headImage)
        contentView.addSubview(nameLabel)
        contentView.addSubview(decriptionLabel)
        contentView.addSubview(acceptBtn)
        contentView.addSubview(rejectBtn)
        
        headImage.snp_makeConstraints { (make) -> Void in
            make.top.left.equalTo(contentView).offset(5)
            make.bottom.equalTo(contentView).offset(-5)
            make.width.height.equalTo(70)
        }
        nameLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(contentView.snp_top).offset(5)
            make.left.equalTo(headImage.snp_right).offset(5)
            make.right.equalTo(acceptBtn.snp_left).offset(-5)
            make.height.equalTo(21)
        }
        decriptionLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(nameLabel.snp_bottom)
            make.left.equalTo(headImage.snp_right).offset(5)
            make.bottom.equalTo(contentView.snp_bottom).offset(-5)
            make.right.equalTo(acceptBtn.snp_left).offset(-5)
        }
        acceptBtn.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(contentView.snp_top).offset(5)
            make.right.equalTo(contentView.snp_right).offset(-5)
            make.width.equalTo(60)
            make.height.equalTo(30)
        }
        rejectBtn.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(contentView.snp_bottom).offset(-5)
            make.right.equalTo(contentView.snp_right).offset(-5)
            make.width.equalTo(acceptBtn.snp_width)
            make.height.equalTo(acceptBtn.snp_height)
        }
    }
    
    // MARK: button response
    func accept() {
        delegate?.acceptFriendRequest(row)
    }
    
    func reject() {
        delegate?.rejectFriendRequest(row)
    }
    
    
    class var cellHeight: CGFloat {
        return 80
    }
}
