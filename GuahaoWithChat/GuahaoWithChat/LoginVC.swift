//
//  ViewController.swift
//  guahao
//
//  Created by Jeff Wong on 15/10/6.
//  Copyright © 2015年 Jeff. All rights reserved.
//

import UIKit
import SnapKit

class LoginVC: UIViewController, GuahaoLoginViewDelegate {
    var guaHaoView: GuahaoLoginView!
    var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        setupSubviews()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardNotification()
        
        let userno = NSUserDefaults.standardUserDefaults().valueForKey("username") as? String
        if let userno = userno {
            guaHaoView.usernoTF.text = userno
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardNotification()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupSubviews() {
        scrollView = UIScrollView(frame: view.bounds)
        view.addSubview(scrollView)
        
        guaHaoView = GuahaoLoginView(frame: view.bounds)
        guaHaoView.delegate = self
        guaHaoView.show(scrollView)
        scrollView.contentSize = CGSizeMake(scrollView.frame.width, guaHaoView.frame.maxY + 20)
        
        //找回密码
        let findPswBtn = UIButton()
        findPswBtn.setTitle("找回密码", forState: .Normal)
        findPswBtn.setTitleColor(UIColor.blueColor(), forState: .Normal)
        findPswBtn.addTarget(self, action: Selector("findPassword"), forControlEvents: .TouchUpInside)
        findPswBtn.titleLabel?.font = UIFont.systemFontOfSize(15)
        view.addSubview(findPswBtn)
        
        findPswBtn.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(30)
            make.width.equalTo(80)
            make.centerX.equalTo(view.snp_centerX)
            make.bottom.equalTo(view.snp_bottom)
        }
    }
    
    func addKeyboardNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardNotification() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func login() {
        guard let userno = guaHaoView.usernoTF.text where userno != "" else {
            ZFAlertShow.sharedInstance.showAlert(nil, message: "请填写用户名！", inViewController: self)
            return
        }
        guard let psw = guaHaoView.passwordTF.text where psw != "" else {
            ZFAlertShow.sharedInstance.showAlert(nil, message: "请填写密码！", inViewController: self)
            return
        }
        
        let loading = ZFLoadingView()
        loading.show(InView: view, withTips: "登录中..")
        
        let param = [
            "name": userno,
            "password": psw]
        // MARK: 先登陆挂号
        dispatch_async(globalQueue) {
            ZFHttpRequest.postRequest(
                toUrl: "http://192.168.137.1:8000/login/",
                withParameter: param,
                success: { (json) -> () in
                    print(json)
                    if let status = json["status"] as? String where status == "success" {
                        if let black = json["black"] as? String where black == "True" {
                            ZFAlertShow.sharedInstance.showAlert(nil, message: "您已被拉入黑名单", inViewController: self)
                        }else {
                            // MARK: 登陆前清除好友请求
                            FriendRequestVC.sharedViewController.clearRequestList()
                            
                            // MARK: 再登陆环信
                            self.easeMobLogin(userno, password: psw) {
                                loading.hide()
                                
                                runAsyncOnMainThread {
                                    NSNotificationCenter.defaultCenter().postNotificationName(
                                        "loginStateChanged", object: 1, userInfo: nil)
                                }
                            }
                        }
                    }else {
                        ZFAlertShow.sharedInstance.showAlert(nil, message: "登陆失败！", inViewController: self)
                        loading.hide()
                    }
                },
                failure: { (error) -> () in
                    print(error)
                    MessageToast.toast(self.view, message: "登陆失败！", keyBoardHeight: 0, finishBlock: nil)
                    loading.hide()
            })
        }
    }
    
    // MARK: 点击注册按钮
    func register() {
        guard let userno = guaHaoView.usernoTF.text where userno != "" else {
            ZFAlertShow.sharedInstance.showAlert(nil, message: "用户名不能为空！", inViewController: self)
            return
        }
        guard let psw = guaHaoView.passwordTF.text, let psw2 = guaHaoView.againTF?.text where psw.characters.count >= 6 else {
            ZFAlertShow.sharedInstance.showAlert(nil, message: "密码至少为6位！", inViewController: self)
            return
        }
        guard psw == psw2 else {
            ZFAlertShow.sharedInstance.showAlert(nil, message: "两次密码输入不相同！", inViewController: self)
            return
        }
        guard let tel = guaHaoView.telTF?.text, let addr = guaHaoView.addrTF?.text where tel != "" && addr != "" else {
            ZFAlertShow.sharedInstance.showAlert(nil, message: "请完整填写资料！", inViewController: self)
            return
        }
        guard tel.characters.count >= 11 else {
            ZFAlertShow.sharedInstance.showAlert(nil, message: "手机号码不正确！", inViewController: self)
            return
        }
        guard let mail = guaHaoView.mailTF?.text where mail != "" else {
            ZFAlertShow.sharedInstance.showAlert(nil, message: "请完整填写资料！", inViewController: self)
            return
        }
        guard Helper.isEmailAddress(mail) else {
            ZFAlertShow.sharedInstance.showAlert(nil, message: "邮箱格式不正确！", inViewController: self)
            return
        }
        
        
        let loading = ZFLoadingView()
        loading.show(InView: view, withTips: "正在注册..")
        
        let param = [
            "name": userno,
            "password": psw,
            "tel": tel,
            "addr": addr,
            "mail": mail]
        // MARK: 首先注册
        dispatch_async(dispatch_queue_create("register", DISPATCH_QUEUE_SERIAL)) {
            ZFHttpRequest.postRequest(
                toUrl: "http://192.168.137.1:8000/register/",
                withParameter: param,
                success: { (json) -> () in
                    print(json)
                    if let status = json["status"] as? String where status == "success" {
                        // MARK: 再注册环信
                        dispatch_async(globalQueue) {
                            var error: EMError?
                            EaseMob.sharedInstance().chatManager.registerNewAccount(userno, password: psw, error: &error)
                            if error == nil {
                                MessageToast.toast(self.view, message: "注册成功！", keyBoardHeight: 0, finishBlock: nil)
                                
                                // MARK: 登陆前清除好友请求
                                FriendRequestVC.sharedViewController.clearRequestList()
                                
                                // MARK: 注册成功后开始登陆
                                self.easeMobLogin(userno, password: psw) {
                                    loading.hide()
                                }
                            }else {
                                ZFAlertShow.sharedInstance.showAlert(nil, message: "注册失败，请重试", inViewController: self)
                                loading.hide()
                            }
                        }
                    }else {
                        ZFAlertShow.sharedInstance.showAlert(nil, message: "注册失败！", inViewController: self)
                    }
                    loading.hide()
                },
                failure: { (error) -> () in
                    loading.hide()
                    ZFAlertShow.sharedInstance.showAlert(nil, message: "注册失败！", inViewController: self)
            })
        }
    }
    
    // MARK: 调用环信的登陆接口
    func easeMobLogin(username: String, password: String, completionHandler: () -> ()) {
        EaseMob.sharedInstance().chatManager.asyncLoginWithUsername(username, password: password, completion: { (loginInfo, error) -> Void in
            EaseMob.sharedInstance().chatManager.enableAutoLogin?()
            if error != nil {
                MessageToast.toast(self.view, message: "登陆出错，请重试！", keyBoardHeight: 0, finishBlock: nil)
            }else {
                runAsyncOnMainThread {
                    NSNotificationCenter.defaultCenter().postNotificationName(
                        "loginStateChanged", object: 1)
                }
            }
            // MARK: 保存用户名
            NSUserDefaults.standardUserDefaults().setValue(username, forKey: "username")
            GHProfileManager.defaultManager.saveProfile(
                username, keys: ["username"], values: [username])
            completionHandler()
        }, onQueue: nil)
    }
    
    // MARK: 找回密码
    func findPassword() {
        guard let username = guaHaoView.usernoTF.text where username != "" else {
            ZFAlertShow.sharedInstance.showAlert(nil, message: "请在上方输入您要找回密码的账号！", inViewController: self)
            return
        }
        let loading = ZFLoadingView()
        loading.show(InView: view, withTips: "正在请求服务器...")
        dispatch_async(globalQueue) {
            ZFHttpRequest.postRequest(
                toUrl: "http://192.168.137.1:8000/getpad/",
                withParameter: ["username": username],
                success: { (json) -> () in
                    if let status = json["status"] as? String where status == "success" {
                        ZFAlertShow.sharedInstance.showAlert(nil, message: "密码已经发送到您的邮箱，请到邮箱中查收！", inViewController: self)
                    }else {
                        MessageToast.toast(self.view, message: "找回密码失败！", keyBoardHeight: 0, finishBlock: nil)
                    }
                    loading.hide()
                },
                failure: { (error) -> () in
                    MessageToast.toast(self.view, message: "网络连接失败！", keyBoardHeight: 0, finishBlock: nil)
                    loading.hide()
            })
        }
    }
    
    // MARK: 键盘监听
    func keyboardWillShow(notification: NSNotification) {
        let userinfo = notification.userInfo
        guard let userInfo = userinfo else {
            return
        }
        let keyboardHight = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.height
        guard let height = keyboardHight else {
            return
        }
        scrollView.contentSize.height = guaHaoView.frame.maxY + 20
        scrollView.frame.size.height = view.bounds.height - height
    }
    
    func keyboardWillHide(notification: NSNotification) {
        scrollView.contentSize.height = guaHaoView.frame.maxY + 20
        scrollView.frame.size.height = view.bounds.height
    }
}

