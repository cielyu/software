//
//  ViewController.swift
//  guahao
//
//  Created by Jeff Wong on 15/10/6.
//  Copyright © 2015年 Jeff. All rights reserved.
//

import UIKit

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
        
        let userno = NSUserDefaults.standardUserDefaults().valueForKey("userno") as? String
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
        loading.show(InView: self.view, withTips: "正在登陆...")
        let param = [
            "name": userno,
            "password": psw]
        dispatch_async(dispatch_queue_create("login", DISPATCH_QUEUE_SERIAL)) {
            ZFHttpRequest.postRequest(
                toUrl: "http://192.168.137.1:8000/login/",
                withParameter: param,
                success: { (json) -> () in
                    print(json)
                    if let status = json["status"] as? String where status == "success" {
                        if let black = json["black"] as? String where black == "True" {
                            ZFAlertShow.sharedInstance.showAlert(nil, message: "您已被拉入黑名单", inViewController: self)
                        }else {
                            dispatch_async(dispatch_get_main_queue()) {
                                NSNotificationCenter.defaultCenter().postNotificationName(
                                    "loginStateChanged", object: 1, userInfo: nil)
                            }
                            NSUserDefaults.standardUserDefaults().setValue(userno, forKey: "userno")
                        }
                    }else {
                        ZFAlertShow.sharedInstance.showAlert(nil, message: "登陆失败！", inViewController: self)
                    }
                    loading.hide()
                },
                failure: { (error) -> () in
                    print(error)
                    loading.hide()
            })
        }
    }
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
        dispatch_async(dispatch_queue_create("register", DISPATCH_QUEUE_SERIAL)) {
            ZFHttpRequest.postRequest(
                toUrl: "http://192.168.137.1:8000/register/",
                withParameter: param,
                success: { (json) -> () in
                    print(json)
                    if let status = json["status"] as? String where status == "success" {
                        ZFAlertShow.sharedInstance.showAlert(nil, message: "注册成功！", inViewController: self)
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
    
    // MARK: 找回密码
    func findPassword() {
        guard let username = guaHaoView.usernoTF.text where username != "" else {
            ZFAlertShow.sharedInstance.showAlert(nil, message: "请在上方输入您要找回密码的账号！", inViewController: self)
            return
        }
        let loading = ZFLoadingView()
        loading.show(InView: view, withTips: "正在请求服务器...")
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
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

