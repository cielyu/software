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
        EaseMob.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        registerLifeCycleNotification()
    }
    
    func registerLifeCycleNotification() {
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: Selector("applicationDidEnterBackgroundNotification:"),
            name: UIApplicationDidEnterBackgroundNotification,
            object: nil)
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: Selector("applicationWillEnterForegroundNotification:"),
            name: UIApplicationWillEnterForegroundNotification,
            object: nil)
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
    func applicationDidEnterBackgroundNotification(application: UIApplication) {
        EaseMob.sharedInstance().applicationDidEnterBackground(application)
    }
    
    func applicationWillEnterForegroundNotification(application: UIApplication) {
        EaseMob.sharedInstance().applicationWillEnterForeground(application)
    }
    
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
    
    // MARK: 登陆时好友请求回调
    func didReceiveBuddyRequest(username: String!, var message: String!) {
        if message == nil {
            message = " "
        }
        FriendRequestVC.sharedViewController.appendNewRequest(username, message: message)
        runAsyncOnMainThread {
            self.mainVC?.contactVC.tableView.reloadData()
        }
    }
}
