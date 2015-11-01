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
    }
    
    func addKeyboardNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardNotification() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func login() {
        print("登陆")
        dispatch_async(dispatch_queue_create("login", DISPATCH_QUEUE_SERIAL)) {
            let loading = ZFLoadingView()
            loading.show(InView: self.view, withTips: "正在登陆...")
            dispatch_async(dispatch_get_main_queue()) {
                NSNotificationCenter.defaultCenter().postNotificationName("loginStateChanged", object: 1)
            }
            loading.hide()
        }
    }
    func register() {
        print("注册")
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

