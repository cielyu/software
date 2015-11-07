//
//  AppDelegate+EaseMob.swift
//  GuahaoWithChat
//
//  Created by Jeff Wong on 15/11/4.
//  Copyright © 2015年 Jeff. All rights reserved.
//

import UIKit

extension AppDelegate: IChatManagerDelegate {
    func easeMobApplication(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) {
        EaseMob.sharedInstance().registerSDKWithAppKey("book-borrow#guahao", apnsCertName: "")
        
        // MARK: 监听一些回调
        EaseMob.sharedInstance().chatManager.addDelegate(self, delegateQueue: nil)
        // MARK: 登陆完成就获取好友列表
        EaseMob.sharedInstance().chatManager.enableAutoFetchBuddyList?()
        
        registerLifeCycleNotification()
        EaseMob.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func registerLifeCycleNotification() {
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: Selector("applicationDidFinishLaunching:"),
            name: UIApplicationDidFinishLaunchingNotification,
            object: nil)
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: Selector("applicationDidBecomeActiveNotification:"),
            name: UIApplicationDidBecomeActiveNotification,
            object: nil)
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: Selector("applicationWillResignActiveNotification:"),
            name: UIApplicationWillResignActiveNotification,
            object: nil)
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: Selector("applicationDidReceiveMemoryWarning:"),
            name: UIApplicationDidReceiveMemoryWarningNotification,
            object: nil)
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: Selector("applicationProtectedDataWillBecomeUnavailable:"),
            name: UIApplicationProtectedDataWillBecomeUnavailable,
            object: nil)
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: Selector("applicationProtectedDataDidBecomeAvailable:"),
            name: UIApplicationProtectedDataDidBecomeAvailable,
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: Selector("applicationWillTerminateNotification:"),
            name: UIApplicationWillTerminateNotification,
            object: nil)
    }
    
    // MARK: 环信生命周期通知
    func applicationDidFinishLaunching(application: UIApplication) {
        EaseMob.sharedInstance().applicationDidFinishLaunching(application)
    }
    
    func applicationDidBecomeActiveNotification(application: UIApplication) {
        EaseMob.sharedInstance().applicationDidBecomeActive(application)
    }
    
    func applicationWillResignActiveNotification(application: UIApplication) {
        EaseMob.sharedInstance().applicationWillResignActive(application)
    }
    
    func applicationDidReceiveMemoryWarning(application: UIApplication) {
        EaseMob.sharedInstance().applicationDidReceiveMemoryWarning(application)
    }
    
    func applicationProtectedDataWillBecomeUnavailable(application: UIApplication) {
        EaseMob.sharedInstance().applicationProtectedDataWillBecomeUnavailable(application)
    }
    
    func applicationProtectedDataDidBecomeAvailable(application: UIApplication) {
        EaseMob.sharedInstance().applicationProtectedDataDidBecomeAvailable(application)
    }
    
    func applicationWillTerminateNotification(application: UIApplication) {
        EaseMob.sharedInstance().applicationWillTerminate(application)
    }
    
    // MARK: 注册远程推送（没有申请推送证书，关闭应用后是没有推送的）
    func registerRemoteNotification(application: UIApplication) {
        application.registerForRemoteNotifications()
        let notificationTypes: UIUserNotificationType = [.Badge, .Sound, .Alert]
        let notificationSettings = UIUserNotificationSettings(forTypes: notificationTypes, categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
    }
    
    // MARK: 远程推送的相关回调
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        EaseMob.sharedInstance().application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }
    // MARK: deviceToken注册失败时（当然会失败）
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("－－－－－－－－－－－－－－－－－－－－\ntoken注册失败！")
        EaseMob.sharedInstance().application(application, didFailToRegisterForRemoteNotificationsWithError: error)
    }
    
    // MARK: 自动登陆回调
    func willAutoLoginWithInfo(loginInfo: [NSObject : AnyObject]!, error: EMError!) {
        if error != nil {
            MessageToast.toast(window, message: "自动登陆失败!", keyBoardHeight: 0, finishBlock: nil)
            runAsyncOnMainThread {
                NSNotificationCenter.defaultCenter().postNotificationName(
                    "loginStateChanged", object: 2)
            }
        }
    }
    
    func didAutoLoginWithInfo(loginInfo: [NSObject : AnyObject]!, error: EMError!) {
        if error != nil {
            MessageToast.toast(window, message: "自动登陆失败!", keyBoardHeight: 0, finishBlock: nil)
            runAsyncOnMainThread {
                NSNotificationCenter.defaultCenter().postNotificationName(
                    "loginStateChanged", object: 2)
            }
        }
    }
    
    // MARK: 账号在其他设备中登陆时
    func didLoginFromOtherDevice() {
        var error: EMError? = nil
        EaseMob.sharedInstance().chatManager.logoffWithUnbindDeviceToken(false, error: &error)
        
        if error != nil {
            let alert = UIAlertView(title: "错误", message: "登出时出现错误！", delegate: nil, cancelButtonTitle: "确定")
            alert.show()
        }else {
            runAsyncOnMainThread {
                NSNotificationCenter.defaultCenter().postNotificationName(
                    "loginStateChanged", object: 2)
            }
        }
        let alert2 = UIAlertView(title: nil, message: "您的账号在其他设备中登陆", delegate: nil, cancelButtonTitle: "确定")
        alert2.show()
    }
}
