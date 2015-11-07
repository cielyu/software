//
//  ChatViewTableViewCell.swift
//  GuahaoWithChat
//
//  Created by Jeff Wong on 15/11/4.
//  Copyright © 2015年 Jeff. All rights reserved.
//

import UIKit

class ChatViewTableViewCell: UITableViewCell {
    private let headImage = UIImageView()
    let chatLabel = GHChatLabel()
    private var alignment: GHChatLabelAlignment = .Right
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        headImage.image = UIImage(named: "ChatListCellPlaceHolder")
        contentView.addSubview(headImage)
        contentView.addSubview(chatLabel)
    }
    
    func setText(alignment: GHChatLabelAlignment, text: String?) {
        self.alignment = alignment
        let frameWidth = UIScreen.mainScreen().bounds.width
        let labelSize = GHChatLabel.sizeOfLabel(
            withText: text,
            font: GHChatLabel.defaultFont)
        var chatLabelFrame: CGRect
        switch alignment {
        case .Right:
            headImage.frame = CGRectMake(frameWidth - 35, 5, 30, 30)
            
            chatLabelFrame = CGRectMake(
                frameWidth - 40 - frameWidth * 3/4,
                headImage.frame.minY,
                labelSize.width + 25,
                labelSize.height + 10 < 30 ? 30 : (labelSize.height + 10))
        case .Left:
            headImage.frame = CGRectMake(5, 5, 30, 30)
            
            chatLabelFrame = CGRectMake(
                headImage.frame.maxX + 5,
                headImage.frame.minY,
                labelSize.width + 25,
                labelSize.height + 10 < 30 ? 30 : (labelSize.height + 10))
        }
        chatLabel.setTextAndBGImage(text, alignment: alignment, frame: chatLabelFrame)
    }

    
    class var cellHeight: CGFloat {
        return 40
    }
}
