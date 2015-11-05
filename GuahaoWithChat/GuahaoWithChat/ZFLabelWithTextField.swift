//
//  ZFLabelWithTextField.swift
//  guahao
//
//  Created by Jeff Wong on 15/10/21.
//  Copyright © 2015年 Jeff. All rights reserved.
//

import UIKit

enum ZFSeparateLinePosition {
    case None
    case Top
    case Bottom
}

class ZFLabelWithTextField: UIView {
    private var label: UILabel!
    var textField: UITextField!
    
    init(frame: CGRect, separateLinePosition position: ZFSeparateLinePosition) {
        super.init(frame: frame)
        
        setupSubviews()
        
        switch position {
        case .Top:
            label.frame.origin.y = 12
            textField.frame.origin.y = 12
            
            self.frame.size.height = textField.frame.maxY + 12
            addSubview(separateLine)
        case .Bottom:
            let separate = separateLine
            separate.frame.origin.y = label.frame.maxY + 12
            
            self.frame.size.height = separate.frame.maxY
            addSubview(separate)
        default:
            self.frame.size.height = textField.frame.maxY + 12
            break
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        label = UILabel(frame: CGRectMake(20, 12, 1, 21))
        label.font = UIFont.systemFontOfSize(15)
        label.textColor = UIColor.blackColor()
        label.textAlignment = .Center
        
        textField = UITextField(frame: CGRectMake(label.frame.maxX + 20, 12, frame.width - label.frame.maxX - 50, 21))
        textField.font = UIFont.systemFontOfSize(15)
        
        addSubview(label)
        addSubview(textField)
    }
    
    private var separateLine: UIView {
        let separateLine = UIView(frame: CGRectMake(0, 0, frame.width, 0.5))
        separateLine.backgroundColor = UIColor(red: 197/255, green: 197/255, blue: 197/255, alpha: 1)
        return separateLine
    }
    
    /**
     设置label的文字，例如：账号、密码
     - Parameter text: label的文字，可为空，为空时不做任何操作
     - Returns: void
     */
    func setLabelText(text: String?) {
        guard let text = text else {
            return
        }
        let labelWidth = text.widthForDisplaying(label.font)
        label.frame.size.width = labelWidth
        label.text = text
        
        textField.frame.origin.x = label.frame.maxX + 10
        textField.frame.size.width = frame.width - label.frame.maxX - 20
    }
}
