//
//  ChatToolBar.swift
//  GuahaoWithChat
//
//  Created by Jeff Wong on 15/11/5.
//  Copyright © 2015年 Jeff. All rights reserved.
//

import UIKit
import SnapKit

protocol ChatToolbarDelegate: NSObjectProtocol {
    func sendButtonClicked()
}

class ChatToolbar: UIView, UITextFieldDelegate {
    lazy var textField = UITextField()
    lazy var sendBtn = UIButton()
    
    weak var delegate: ChatToolbarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.whiteColor()
        setupSubviews()
        registerKeyboardNotification()
    }
    
    deinit {
        removeKeyboardNotification()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        
        textField.borderStyle = .RoundedRect
        textField.returnKeyType = .Send
        textField.delegate = self
        
        sendBtn.setTitle("发送", forState: .Normal)
        sendBtn.setTitleColor(UIColor.blueColor(), forState: .Normal)
        sendBtn.titleLabel?.font = UIFont.systemFontOfSize(15)
        sendBtn.addTarget(self, action: Selector("sendBtnClicked"), forControlEvents: .TouchUpInside)
        
        addSubview(textField)
        addSubview(sendBtn)
        
        textField.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self).offset(5)
            make.left.equalTo(self).offset(5)
            make.bottom.equalTo(self).offset(-5)
            make.right.equalTo(sendBtn.snp_left)
        }
        sendBtn.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(textField.snp_right)
            make.top.equalTo(self).offset(5)
            make.right.equalTo(self).offset(-5)
            make.bottom.equalTo(self).offset(-5)
            make.width.equalTo(44)
        }
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let ctx = UIGraphicsGetCurrentContext()
        CGContextSaveGState(ctx)
        
        CGContextSetLineWidth(ctx, 0.5)
        UIColor.grayColor().setStroke()
        
        CGContextMoveToPoint(ctx, 0, 0)
        CGContextAddLineToPoint(ctx, rect.width, 0)
        CGContextMoveToPoint(ctx, 0, rect.height)
        CGContextAddLineToPoint(ctx, rect.width, rect.height)
        
        CGContextRestoreGState(ctx)
    }
    // MARK: 注册键盘呼出监听
    func registerKeyboardNotification() {
        NSNotificationCenter.defaultCenter().addObserver(
            self, selector: Selector("keyboardWillShow:"),
            name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(
            self, selector: Selector("keyboardWillHide:"),
            name: UIKeyboardWillHideNotification, object: nil)
    }
    // MARK: 移除监听
    func removeKeyboardNotification() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: KeyboardNotification
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardRect = notification.userInfo?[UIKeyboardFrameEndUserInfoKey]?.CGRectValue {
            let height = keyboardRect.height
            UIView.animateWithDuration(0.2) {
                self.frame.origin.y = UIScreen.mainScreen().bounds.height - ChatToolbar.defaultHeight - height
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        UIView.animateWithDuration(0.2) {
            self.frame.origin.y = UIScreen.mainScreen().bounds.height - ChatToolbar.defaultHeight
        }
    }
    
    // MARK: send button
    func sendBtnClicked() {
        delegate?.sendButtonClicked()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        delegate?.sendButtonClicked()
        return true
    }
    
    class var defaultHeight: CGFloat {
        return 40
    }
}
