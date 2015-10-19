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
        UINavigationBar.appearance().barTintColor = UIColor(red: 0.529, green: 0.808, blue: 0.922, alpha: 1)
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1),
            NSFontAttributeName: UIFont(name: "Helvetica-Bold", size: 21)!]
        
        // MARK: 注册“登陆状态”通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("loginStateChanged:"), name: "loginStateChanged", object: nil)
        isAutoLogin = NSUserDefaults.standardUserDefaults().boolForKey("isAutoLogin")
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
        
        guard let _obj = obj else {
            // MARK: 如果是空的，就是AppDelegate直接调用的
            if isAutoLogin {
                // TODO: 这里应该跳到挂号界面
                let mainVC = MainVC()
                window?.rootViewController = UINavigationController(rootViewController: mainVC)
            }else {
                let loginVC = LoginVC()
                window?.rootViewController = loginVC
            }
            return
        }
        
        switch _obj {
        case 0:
            // MARK: 登陆失败
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isAutoLogin")
            let loginVC = LoginVC()
            window?.rootViewController = loginVC
            // TODO: 登陆失败应该有提示框
            
        case 1:
            // MARK: 登陆界面，登陆成功
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isAutoLogin")
            // TODO: 这里应该跳到挂号界面
            let mainVC = MainVC()
            let nav = UINavigationController(rootViewController: mainVC)
            window?.rootViewController = nav
        case 2:
            // MARK: 登陆出错
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isAutoLogin")
            let loginVC = LoginVC()
            window?.rootViewController = loginVC
            
        case 3:
            // MARK: 挂号界面，登陆成功
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isAutoLogin")
        case 4:
            // MARK: 用户注销
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isAutoLogin")
            let loginVC = LoginVC()
            window?.rootViewController = loginVC
        default:
            break
        }
    }
}

