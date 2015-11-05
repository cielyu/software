//
//  ChatViewTableViewCell.swift
//  GuahaoWithChat
//
//  Created by Jeff Wong on 15/11/4.
//  Copyright © 2015年 Jeff. All rights reserved.
//

import UIKit

class ChatViewTableViewCell: UITableViewCell {
    var chatLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        chatLabel = UILabel()
        chatLabel.textColor = UIColor.blackColor()

        contentView.addSubview(chatLabel)
        
        chatLabel.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(contentView).inset(5)
        }
    }
    
    func setText(aligment: NSTextAlignment, text: String?) {
        chatLabel.textAlignment = aligment
        chatLabel.text = text
    }
    
    class var cellHeight: CGFloat {
        return 40
    }
}
