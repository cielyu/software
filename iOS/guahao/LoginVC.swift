//
//  ViewController.swift
//  guahao
//
//  Created by Jeff Wong on 15/10/6.
//  Copyright © 2015年 Jeff. All rights reserved.
//

import UIKit

class LoginVC: UIViewController, UITextFieldDelegate {
    var centerView: UIView!
    var usernoAndPasswordView: UIView!
    var usernoTF: UITextField!
    var passwordTF: UITextField!
    var loginBtn: UIButton!
    var registerBtn: UIButton!
    
    var againView: UIView?
    var againTF: UITextField?
    
    var isRegistering = false
    var isAnimating = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        setupSubviews()
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let userno = NSUserDefaults.standardUserDefaults().valueForKey("userno") as? String
        if let userno = userno {
            usernoTF.text = userno
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func setupSubviews() {
        centerView = UIView(frame: CGRectMake(0, 0, 0, 0))
        
        let titleLabel = UILabel(frame: CGRectMake(0, 0, 120, 50))
        titleLabel.textAlignment = .Center
        titleLabel.font = UIFont(name: "Helvetica-Bold", size: 22)
        titleLabel.text = "挂号"
        
        usernoAndPasswordView = UIView(frame: CGRectMake(0, 0, 0, 0))
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
            usernoLabel.frame.origin.y,
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
        loginBtn = UIButton(frame: CGRectMake(
            0,
            usernoAndPasswordView.frame.maxY + 20,
            80,
            25))
        loginBtn.setTitle("登陆", forState: .Normal)
        loginBtn.setTitleColor(UIColor.blueColor(), forState: .Normal)
        loginBtn.setTitleColor(UIColor(red: 0, green: 0, blue: 1, alpha: 0.5), forState: .Highlighted)
        loginBtn.addTarget(self, action: Selector("login:"), forControlEvents: .TouchUpInside)
        
        // MARK: 注册按钮
        registerBtn = UIButton(frame: CGRectMake(
            0,
            loginBtn.frame.origin.y,
            80,
            25))
        registerBtn.setTitle("注册", forState: .Normal)
        registerBtn.setTitleColor(UIColor.blueColor(), forState: .Normal)
        registerBtn.setTitleColor(UIColor(red: 0, green: 0, blue: 1, alpha: 0.5), forState: .Highlighted)
        registerBtn.addTarget(self, action: Selector("register:"), forControlEvents: .TouchUpInside)
        
        centerView.frame = CGRectMake(
            0,
            0,
            usernoAndPasswordView.bounds.width,
            loginBtn.frame.maxY)
        centerView.center = CGPointMake(view.bounds.width / 2, view.bounds.height / 2)
        
        titleLabel.center.x = centerView.frame.width / 2
        loginBtn.center.x = titleLabel.center.x
        registerBtn.frame = CGRectMake(
            loginBtn.frame.maxX,
            loginBtn.frame.origin.y,
            80,
            25)
        
        centerView.addSubview(titleLabel)
        centerView.addSubview(usernoAndPasswordView)
        centerView.addSubview(loginBtn)
        centerView.addSubview(registerBtn)
        
        view.addSubview(centerView)
    }
    
    func login(button: UIButton) {
        if isAnimating {
            return
        }
        
        if isRegistering {
            endRegister()
        }else {
            if let userno = usernoTF.text, psw = passwordTF.text {
                dispatch_async(dispatch_queue_create("queue", DISPATCH_QUEUE_SERIAL)) {
                    let loadingView = ZFLoadingView()
                    loadingView.show(InView: self.view, withTips: "正在登陆..")
                    
                    //保存用户数据
                    let standUD = NSUserDefaults.standardUserDefaults()
                    standUD.setValue(userno, forKey: "userno")
                    
                    // TODO: 登陆post
                    let url = "http://192.168.137.1:8000/login/"
                    let param = ["name": userno, "password": psw]
                    ZFHttpRequest.postRequest(
                        toUrl: url,
                        withParameter: param,
                        success: { (json) -> () in
                            
                            let encryptedPsw = NSString(string: psw).RC4_crypt("phoenix")
                            standUD.setValue(encryptedPsw, forKey: "psw")
                            loadingView.hide()
                            print(json)
                        },
                        failure: { (error) -> () in
                            
                            loadingView.hide()
                    })
                    
                    
//                    dispatch_async(dispatch_get_main_queue()) {
//                        NSNotificationCenter.defaultCenter().postNotificationName("loginStateChanged", object: 1)
//                    }
                }
            }else {
                
            }
        }
    }
    
    func register(button: UIButton) {
        if isAnimating {
            return
        }
        
        if isRegistering {
            // TODO: 注册
            let param = ["name": "apple", "password": "123456", "tel": "13610162838", "addr": "广东广州"]
            ZFHttpRequest.postRequest(
                toUrl: "http://192.168.137.1:8000/register/",
                withParameter: param,
                success: { (json) -> () in
                    print(json)
                },
                failure: { (error) -> () in
                    MessageToast.toast(self.view, message: "failed", keyBoardHeight: 0, finishBlock: nil)
            })
        }else {
            beginRegister()
        }
    }
    
    // MARK: 注册状态
    func beginRegister() {
        if isAnimating {
            return
        }
        if isRegistering == true {
            // TODO: 服务器请求注册
            
            return
        }
        isRegistering = true
        isAnimating = true
        
        againView = UIView(frame: CGRectMake(
            0,
            passwordTF.frame.maxY,
            centerView.frame.width,
            39.5))
        againView?.alpha = 0
        
        let separateLine = UIView(frame: CGRectMake(
            0,
            9,
            againView!.frame.width,
            0.5))
        separateLine.backgroundColor = UIColor(red: 197/255, green: 197/255, blue: 197/255, alpha: 1)
        
        let againLabel = UILabel(frame: CGRectMake(
            10,
            separateLine.frame.maxY + 9,
            34,
            usernoTF.frame.height))
        againLabel.text = "确认"
        
        againTF = UITextField(frame: CGRectMake(
            againLabel.frame.maxX + 10,
            againLabel.frame.origin.y,
            usernoTF.frame.width,
            usernoTF.frame.height))
        againTF?.placeholder = "请再次输入密码"
        againTF?.secureTextEntry = true
        againTF?.returnKeyType = .Done
        againTF?.delegate = self
        
        againView?.addSubview(separateLine)
        againView?.addSubview(againLabel)
        againView?.addSubview(againTF!)
        
        centerView.frame.size.height = centerView.frame.size.height + 39.5
        
        UIView.animateWithDuration(
            0.2,
            animations: { () -> Void in
                self.loginBtn.alpha = 0
                self.registerBtn.alpha = 0
            }) { (finish) -> Void in
                self.usernoAndPasswordView.addSubview(self.againView!)
                // MARK: centerView高度变高，以动画显示“确认密码”，完成后显示“登陆”、“注册”按钮
                UIView.animateWithDuration(
                    0.2,
                    animations: { () -> Void in
                        self.usernoAndPasswordView.frame.size.height = self.againView!.frame.maxY + 10
                    }, completion: { (finish) -> Void in
                        self.loginBtn.frame.origin.y = self.usernoAndPasswordView.frame.maxY + 20
                        self.registerBtn.frame.origin.y = self.loginBtn.frame.origin.y
                        UIView.animateWithDuration(
                            0.3,
                            animations: { () -> Void in
                                self.againView?.alpha = 1
                                self.loginBtn.alpha = 1
                                self.registerBtn.alpha = 1
                            }, completion: { (finish) -> Void in
                                self.passwordTF.returnKeyType = .Next
                                self.isAnimating = false
                        })
                })
        }
    }
    
    func endRegister() {
        isAnimating = true
        UIView.animateWithDuration(
            0.2,
            animations: { () -> Void in
                self.loginBtn.alpha = 0
                self.registerBtn.alpha = 0
                self.againView?.alpha = 0
            }) { (finish) -> Void in
                self.againView?.removeFromSuperview()
                self.againView = nil
                UIView.animateWithDuration(
                    0.2,
                    animations: { () -> Void in
                        self.usernoAndPasswordView.frame.size.height = self.passwordTF.frame.maxY + 10
                    },
                    completion: { (finish) -> Void in
                        self.loginBtn.frame.origin.y = self.usernoAndPasswordView.frame.maxY + 20
                        self.registerBtn.frame.origin.y = self.loginBtn.frame.origin.y
                        self.centerView.frame.size.height = self.loginBtn.frame.maxY
                        UIView.animateWithDuration(
                            0.3,
                            animations: { () -> Void in
                                self.loginBtn.alpha = 1
                                self.registerBtn.alpha = 1
                            },
                            completion: { (fnish) -> Void in
                                self.passwordTF.returnKeyType = .Done
                                self.isRegistering = false
                                self.isAnimating = false
                        })
                })
        }
    }
    
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
            againTF?.resignFirstResponder()
        }
        return true
    }
}

