//
//  GHChatLabel.swift
//  GuahaoWithChat
//
//  Created by Jeff Wong on 15/11/6.
//  Copyright © 2015年 Jeff. All rights reserved.
//

import UIKit

enum GHChatLabelAlignment {
    case Left
    case Right
}

class GHChatLabel: UIView {
    let backgroundImageView = UIImageView()
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clearColor()
        setupSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        label.textColor = UIColor.blackColor()
        label.numberOfLines = 0
        label.font = GHChatLabel.defaultFont
        
        addSubview(backgroundImageView)
        addSubview(label)
    }
    
    func setTextAndBGImage(text: String?, alignment: GHChatLabelAlignment, frame: CGRect) {
        if frame.width != GHChatLabel.labelMaxWidth && alignment == .Right {
            self.frame = CGRectMake(
                frame.origin.x + (GHChatLabel.labelMaxWidth + 25 - frame.width),
                frame.origin.y,
                frame.width,
                frame.height)
        }else {
            self.frame = frame
        }
        label.text = text
        
        switch alignment {
        case .Left:
            backgroundImageView.image = UIImage(named: "chatLeft")
            
            label.frame = CGRectMake(14, 5, GHChatLabel.labelMaxWidth, 0)
        case .Right:
            backgroundImageView.image = UIImage(named: "chatRight")
            
            label.frame = CGRectMake(10, 5, GHChatLabel.labelMaxWidth, 0)
        }
        label.frame.size.height = frame.height - 10
        backgroundImageView.frame = CGRectMake(0, 0, frame.width, frame.height)
    }
    
    // 得到label的高度
    static func sizeOfLabel(withText text: String?, font: UIFont) -> CGSize {
        guard let text = text else {
            return CGSizeMake(21, 8)
        }
        let size = text.sizeForTextInLabel(
            font,
            maxSize: CGSizeMake(GHChatLabel.labelMaxWidth, CGFloat.max))
        return size
    }
    
    static var defaultFont: UIFont {
        return UIFont.systemFontOfSize(17)
    }
    
    static var labelMaxWidth: CGFloat {
        return UIScreen.mainScreen().bounds.width * 3/4 - 25
    }
}
