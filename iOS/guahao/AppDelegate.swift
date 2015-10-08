//
//  AppDelegate.swift
//  guahao
//
//  Created by Jeff Wong on 15/10/6.
//  Copyright © 2015年 Jeff. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var isAutoLogin = false

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        // MARK: 注册“登陆状态”通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("loginStateChanged:"), name: "loginStateChanged", object: nil)
        let autoLogin = NSUserDefaults.standardUserDefaults().boolForKey("isAutoLogin")
        isAutoLogin = autoLogin
        loginStateChanged(nil)
        
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
    }

    func applicationDidEnterBackground(application: UIApplication) {
    }

    func applicationWillEnterForeground(application: UIApplication) {
    }

    func applicationDidBecomeActive(application: UIApplication) {
    }

    func applicationWillTerminate(application: UIApplication) {
    }

    // MARK: loginStateChanged, 0: 登陆失败, 1: 登陆成功(登陆界面), 2: 密码错误, 3: 登陆成功(挂号界面)
    func loginStateChanged(notification: NSNotification?) {
        let obj = notification?.object as? Int
        print(obj)
        guard let _obj = obj else {
            // MARK: 如果是空的，就是AppDelegate直接调用的
            if isAutoLogin {
                // TODO: 这里应该跳到挂号界面
                let loginVC = LoginVC()
                window?.rootViewController = loginVC
            }else {
                let loginVC = LoginVC()
                window?.rootViewController = loginVC
            }
            return
        }
        var nav: UINavigationController?
        switch _obj {
        case 0:
            // MARK: 登陆失败
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isAutoLogin")
            let loginVC = LoginVC()
            nav = UINavigationController(rootViewController: loginVC)
            // TODO: 登陆失败应该有提示框
        case 1:
            // MARK: 登陆界面，登陆成功
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isAutoLogin")
            // TODO: 这里应该跳到挂号界面
        case 2:
            // MARK: 登陆出错
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isAutoLogin")
            let loginVC = LoginVC()
            window?.rootViewController = loginVC
        case 3:
            // MARK: 挂号界面，登陆成功
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isAutoLogin")
        default:
            break
        }
        if let nav = nav {
            window?.rootViewController = nav
        }
    }
}

