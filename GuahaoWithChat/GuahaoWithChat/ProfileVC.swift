//
//  ProfileVC.swift
//  GuahaoWithChat
//
//  Created by Jeff Wong on 15/11/5.
//  Copyright © 2015年 Jeff. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        
        setupSubviews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupSubviews() {
        let logoutBtn = UIButton()
        logoutBtn.setTitle("注销", forState: .Normal)
        logoutBtn.setTitleColor(UIColor.blueColor(), forState: .Normal)
        logoutBtn.addTarget(self, action: Selector("logout"), forControlEvents: .TouchUpInside)
        view.addSubview(logoutBtn)
        
        logoutBtn.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(view).offset(-44)
            make.centerX.equalTo(view)
        }
    }
    
    func logout() {
        let loading = ZFLoadingView()
        loading.show(InView: view, withTips: "正在注销..")
        EaseMob.sharedInstance().chatManager.asyncLogoffWithCompletion?({ (userInfo, error) -> Void in
            if error == nil {
                runAsyncOnMainThread {
                    NSNotificationCenter.defaultCenter().postNotificationName(
                        "loginStateChanged", object: 4)
                }
            }else {
                MessageToast.toast(self.view, message: "注销失败，请重试！", keyBoardHeight: 0, finishBlock: nil)
            }
        }, onQueue: nil)
        
    }
}
