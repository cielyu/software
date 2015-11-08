//
//  GuahaoView.swift
//  guahao
//
//  Created by Jeff Wong on 15/10/19.
//  Copyright © 2015年 Jeff. All rights reserved.
//

import UIKit

// MARK: 挂号界面
protocol GuahaoLoginViewDelegate: NSObjectProtocol {
    func login()
    func register()
}

class GuahaoLoginView: UIView, UITextFieldDelegate {
    weak var delegate: GuahaoLoginViewDelegate?
    
    private var middleView: UIView!
    private var loginView: UIView!
    private var usernoView: ZFLabelWithTextField!
    private var passwordView: ZFLabelWithTextField!

    private var loginBtn: UIButton!
    private var registerBtn: UIButton!
    
    private var registerView: UIView?
    private var againView: ZFLabelWithTextField?
    private var telView: ZFLabelWithTextField?
    private var addrView: ZFLabelWithTextField?
    private var mailView: ZFLabelWithTextField?
    
    private var isRegistering = false
    private var isAnimating = false
    
    override init(frame: CGRect) {
        super.init(frame: CGRectMake(0, 0, frame.width * 4/5, 0))
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        let titleLabel = UILabel(frame: CGRectMake(0, 0, 120, 50))
        titleLabel.textAlignment = .Center
        titleLabel.font = UIFont(name: "Helvetica-Bold", size: 24)
        titleLabel.text = "挂号"
        
        // MARK: 帐号
        usernoView = ZFLabelWithTextField(
            frame: CGRectMake(0, 0, frame.width, 0),
            separateLinePosition: .Bottom)
        usernoView.setLabelText("帐号")
        usernoTF.placeholder = "请输入账号"
        usernoTF.returnKeyType = .Next
        usernoTF.delegate = self
        
        // MARK: 密码
        passwordView = ZFLabelWithTextField(
            frame: CGRectMake(0, usernoView.frame.maxY, usernoView.frame.width, 0),
            separateLinePosition: .None)
        passwordView.setLabelText("密码")
        passwordTF.placeholder = "请输入密码"
        passwordTF.secureTextEntry = true
        passwordTF.returnKeyType = .Done
        passwordTF.delegate = self
        
        loginView = UIView(frame: CGRectMake(
            0,
            0,
            frame.width,
            passwordView.frame.maxY))
        loginView.addSubview(usernoView)
        loginView.addSubview(passwordView)
        
        // MARK: RoundRect MiddleView
        middleView = UIView(frame: CGRectMake(0, titleLabel.frame.maxY + 10, frame.width, 0))
        middleView.layer.cornerRadius = 12
        middleView.layer.borderWidth = 1
        middleView.layer.borderColor = UIColor(red: 160/255, green: 160/255, blue: 160/255, alpha: 1).CGColor
        middleView.clipsToBounds = true
        middleView.frame.size.height = loginView.frame.maxY
        middleView.addSubview(loginView)
        
        // MARK: 登陆按钮
        loginBtn = UIButton(frame: CGRectMake(
            0,
            middleView.frame.maxY + 20,
            80,
            25))
        loginBtn.setTitle("登陆", forState: .Normal)
        loginBtn.setTitleColor(UIColor.blueColor(), forState: .Normal)
        loginBtn.setTitleColor(UIColor(red: 0, green: 0, blue: 1, alpha: 0.5), forState: .Highlighted)
        loginBtn.addTarget(self, action: Selector("login"), forControlEvents: .TouchUpInside)
        
        // MARK: 注册按钮
        registerBtn = UIButton(frame: CGRectMake(
            0,
            loginBtn.frame.origin.y,
            80,
            25))
        registerBtn.setTitle("注册", forState: .Normal)
        registerBtn.setTitleColor(UIColor.blueColor(), forState: .Normal)
        registerBtn.setTitleColor(UIColor(red: 0, green: 0, blue: 1, alpha: 0.5), forState: .Highlighted)
        registerBtn.addTarget(self, action: Selector("register"), forControlEvents: .TouchUpInside)
        
        frame = CGRectMake(
            0,
            0,
            middleView.bounds.width,
            loginBtn.frame.maxY)
        
        titleLabel.center.x = frame.width / 2
        loginBtn.center.x = titleLabel.center.x
        registerBtn.frame = CGRectMake(
            loginBtn.frame.maxX,
            loginBtn.frame.origin.y,
            80,
            25)
        
        addSubview(titleLabel)
        addSubview(middleView)
        addSubview(loginBtn)
        addSubview(registerBtn)
    }
    
    func show(view: UIView) {
        center = CGPointMake(view.frame.width / 2, view.frame.height / 2)
        view.addSubview(self)
    }
    
    private func addKeyboardNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    private func removeKeyboardNotification() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: 登陆
    func login() {
        endEditing(true)
        if isAnimating {
            return
        }
        
        if isRegistering {
            hideRegisterView()
        }else {
            delegate?.login()
        }
    }
    
    // MARK: 注册
    func register() {
        endEditing(true)
        if isAnimating {
            return
        }
        if isRegistering == true {
            delegate?.register()
            return
        }
        isRegistering = true
        isAnimating = true
        
        setupRegisterView()
        showRegisterView()
    }
    
    private func setupRegisterView() {
        if registerView == nil {
            againView = ZFLabelWithTextField(
                frame: CGRectMake(0, 0, middleView.frame.width, 0),
                separateLinePosition: .Top)
            againView?.setLabelText("确认密码")
            againTF?.placeholder = "请再次输入密码"
            againTF?.secureTextEntry = true
            againTF?.returnKeyType = .Next
            againTF?.delegate = self
            
            telView = ZFLabelWithTextField(
                frame: CGRectMake(0, againView!.frame.maxY, middleView.frame.width, 0),
                separateLinePosition: .Top)
            telView?.setLabelText("手机")
            telTF?.placeholder = "请输入手机号码"
            telTF?.keyboardType = UIKeyboardType.NumberPad
            telTF?.returnKeyType = .Next
            telTF?.delegate = self
            // MARK: 工具条
            let toolBar = UIToolbar(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 35))
            let spaceBtn = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
            let nextBtn = UIBarButtonItem(title: "下一项", style: .Plain, target: self, action: Selector("next:"))
            toolBar.translucent = true
            toolBar.setItems([spaceBtn, nextBtn], animated: true)
            telTF?.inputAccessoryView = toolBar
            
            addrView = ZFLabelWithTextField(
                frame: CGRectMake(0, telView!.frame.maxY, telView!.frame.width, 0),
                separateLinePosition: .Top)
            addrView?.setLabelText("住址")
            addrTF?.placeholder = "请输入你的住址"
            addrTF?.returnKeyType = .Next
            addrTF?.delegate = self
            
            mailView = ZFLabelWithTextField(
                frame: CGRectMake(0, addrView!.frame.maxY, addrView!.frame.width, 0),
                separateLinePosition: .Top)
            mailView?.setLabelText("邮箱")
            mailTF?.placeholder = "请输入邮箱"
            mailTF?.returnKeyType = .Done
            mailTF?.delegate = self
            
            // MARK: register view
            registerView = UIView(frame: CGRectMake(0, loginView.frame.maxY, loginView.frame.width, mailView!.frame.maxY))
            registerView?.alpha = 0
            
            registerView?.addSubview(againView!)
            registerView?.addSubview(telView!)
            registerView?.addSubview(addrView!)
            registerView?.addSubview(mailView!)
        }
    }
    
    private func showRegisterView() {
        loginBtn.enabled = false
        registerBtn.enabled = false
        UIView.animateWithDuration(
            0.2,
            animations: { () -> Void in
                self.loginBtn.alpha = 0
                self.registerBtn.alpha = 0
            }) { (finish) -> Void in
                self.middleView.addSubview(self.registerView!)
                self.loginBtn.frame.origin.y = self.middleView.frame.minY + self.registerView!.frame.maxY + 20
                self.registerBtn.frame.origin.y = self.loginBtn.frame.origin.y
                self.frame.size.height = self.loginBtn.frame.maxY
                // MARK: centerView高度变高，以动画显示“确认密码”，完成后显示“登陆”、“注册”按钮
                UIView.animateWithDuration(
                    0.2,
                    animations: { () -> Void in
                        if let superView = self.superview {
                            self.center.y = superView.bounds.height / 2
                        }
                    }, completion: { (finish) -> Void in
                        UIView.animateWithDuration(
                            0.3,
                            animations: { () -> Void in
                                self.middleView.frame.size.height = self.registerView!.frame.maxY
                            }, completion: { (finish) -> Void in
                                UIView.animateWithDuration(
                                    0.2,
                                    animations: { () -> Void in
                                        self.registerView?.alpha = 1
                                        self.loginBtn.alpha = 1
                                        self.registerBtn.alpha = 1
                                    },
                                    completion: { (finish) -> Void in
                                        self.passwordTF.returnKeyType = .Next
                                        self.loginBtn.enabled = true
                                        self.registerBtn.enabled = true
                                        self.isAnimating = false
                                })
                        })
                })
        }
    }
    
    private func hideRegisterView() {
        isAnimating = true
        loginBtn.enabled = false
        registerBtn.enabled = false
        UIView.animateWithDuration(
            0.2,
            animations: { () -> Void in
                self.loginBtn.alpha = 0
                self.registerBtn.alpha = 0
                self.registerView?.alpha = 0
            }) { (finish) -> Void in
                self.registerView?.removeFromSuperview()
                self.registerView = nil
                UIView.animateWithDuration(
                    0.2,
                    animations: { () -> Void in
                        self.middleView.frame.size.height = self.loginView.frame.maxY
                    },
                    completion: { (finish) -> Void in
                        self.loginBtn.frame.origin.y = self.middleView.frame.maxY + 20
                        self.registerBtn.frame.origin.y = self.loginBtn.frame.origin.y
                        self.frame.size.height = self.loginBtn.frame.maxY
                        UIView.animateWithDuration(
                            0.3,
                            animations: { () -> Void in
                                self.loginBtn.alpha = 1
                                self.registerBtn.alpha = 1
                                if let superView = self.superview {
                                    self.center.y = superView.bounds.height / 2
                                }
                            },
                            completion: { (fnish) -> Void in
                                self.passwordView.textField.returnKeyType = .Done
                                self.loginBtn.enabled = true
                                self.registerBtn.enabled = true
                                self.isRegistering = false
                                self.isAnimating = false
                        })
                })
        }
    }
    
    func next(button: UIButton) {
        addrTF?.becomeFirstResponder()
    }
    
    // MARK: textField delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == usernoTF {
            passwordTF.becomeFirstResponder()
        }else if textField == passwordTF {
            if isRegistering {
                againTF?.becomeFirstResponder()
            }else {
                passwordTF.resignFirstResponder()
            }
        }else if textField == againTF {
            telTF?.becomeFirstResponder()
        }else if textField == telTF {
            addrTF?.becomeFirstResponder()
        }else if textField == addrTF {
            mailTF?.becomeFirstResponder()
        }else if textField == mailTF {
            mailTF?.resignFirstResponder()
        }
        
        return true
    }
    
    // MARK: TextField
    var usernoTF: UITextField {
        return usernoView.textField
    }
    var passwordTF: UITextField {
        return passwordView.textField
    }
    var againTF: UITextField? {
        return againView?.textField
    }
    var telTF: UITextField? {
        return telView?.textField
    }
    var addrTF: UITextField? {
        return addrView?.textField
    }
    var mailTF: UITextField? {
        return mailView?.textField
    }
}
