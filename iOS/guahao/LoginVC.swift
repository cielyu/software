//
//  ViewController.swift
//  guahao
//
//  Created by Jeff Wong on 15/10/6.
//  Copyright © 2015年 Jeff. All rights reserved.
//

import UIKit

class LoginVC: UIViewController, UITextFieldDelegate {
    var usernoTF: UITextField!
    var passwordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        setupSubviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func setupSubviews() {
        let centerView = UIView(frame: CGRectMake(0, 0, 0, 0))
        
        let titleLabel = UILabel(frame: CGRectMake(0, 0, 120, 50))
        titleLabel.textAlignment = .Center
        titleLabel.font = UIFont(name: "Helvetica-Bold", size: 22)
        titleLabel.text = "挂号"
        
        let usernoAndPasswordView = UIView(frame: CGRectMake(0, 0, 0, 0))
        usernoAndPasswordView.layer.cornerRadius = 8
        usernoAndPasswordView.layer.borderWidth = 1
        usernoAndPasswordView.layer.borderColor = UIColor(red: 160/255, green: 160/255, blue: 160/255, alpha: 1).CGColor
        usernoAndPasswordView.clipsToBounds = true
        
        // MARK: 帐号
        let usernoLabel = UILabel(frame: CGRectMake(10, 10, 34, 21))
        usernoLabel.text = "帐号"
        usernoLabel.textAlignment = .Center
        
        usernoTF = UITextField(frame: CGRectMake(
            usernoLabel.frame.maxX + 10,
            usernoLabel.frame.minY,
            180,
            usernoLabel.bounds.height))
        usernoTF.placeholder = "请输入帐号"
        usernoTF.returnKeyType = .Next
        usernoTF.delegate = self
        
        // MARK: 分割线
        let separateLine = UIView(frame: CGRectMake(
            0, usernoLabel.frame.maxY + 9, usernoTF.frame.maxX + 20, 0.5))
        separateLine.backgroundColor = UIColor(red: 197/255, green: 197/255, blue: 197/255, alpha: 1)
        
        // MARK: 密码
        let passwordLabel = UILabel(frame: CGRectMake(
            10,
            separateLine.frame.maxY + 9,
            34,
            usernoLabel.bounds.height))
        passwordLabel.text = "密码"
        passwordLabel.textAlignment = .Center
        
        passwordTF = UITextField(frame: CGRectMake(
            usernoTF.frame.minX,
            passwordLabel.frame.minY,
            200,
            usernoLabel.bounds.height))
        passwordTF.placeholder = "请输入密码"
        passwordTF.secureTextEntry = true
        passwordTF.returnKeyType = .Done
        passwordTF.delegate = self
        
        usernoAndPasswordView.frame = CGRectMake(
            0,
            titleLabel.frame.maxY + 10,
            passwordTF.frame.maxX,
            passwordTF.frame.maxY + 10)
        usernoAndPasswordView.addSubview(usernoLabel)
        usernoAndPasswordView.addSubview(usernoTF)
        usernoAndPasswordView.addSubview(separateLine)
        usernoAndPasswordView.addSubview(passwordLabel)
        usernoAndPasswordView.addSubview(passwordTF)
        
        // MARK: 登陆按钮
        let loginBtn = UIButton(frame: CGRectMake(
            0,
            usernoAndPasswordView.frame.maxY + 20,
            80,
            25))
        loginBtn.setTitle("登陆", forState: .Normal)
        loginBtn.setTitleColor(UIColor.blueColor(), forState: .Normal)
        loginBtn.setTitleColor(UIColor(red: 0, green: 0, blue: 1, alpha: 0.5), forState: .Highlighted)
        loginBtn.addTarget(self, action: Selector("login:"), forControlEvents: .TouchUpInside)
        
        centerView.frame = CGRectMake(
            0,
            0,
            usernoAndPasswordView.bounds.width,
            loginBtn.frame.maxY)
        centerView.center = CGPointMake(view.bounds.width / 2, view.bounds.height / 2)
        titleLabel.center.x = centerView.frame.width / 2
        loginBtn.center.x = titleLabel.center.x
        centerView.addSubview(titleLabel)
        centerView.addSubview(usernoAndPasswordView)
        centerView.addSubview(loginBtn)
        
        view.addSubview(centerView)
    }
    
    func login(button: UIButton) {
        print("login")
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == usernoTF {
            passwordTF.becomeFirstResponder()
        }else {
            passwordTF.resignFirstResponder()
        }
        return true
    }
}

