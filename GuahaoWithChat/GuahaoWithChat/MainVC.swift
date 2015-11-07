//
//  ViewController.swift
//  GuahaoWithChat
//
//  Created by Jeff Wong on 15/11/4.
//  Copyright © 2015年 Jeff. All rights reserved.
//

import UIKit

class MainVC: UITabBarController, IChatManagerDelegate {
    var chatListVC: ChatListVC!
    var contactVC: ContactVC!
    var profileVC: ProfileVC!
    
    var addFriendBtn: UIBarButtonItem?
    var refreshProfileBtn: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        title = "会话"
        setupViewControllers()
        setupTabbarItem()
        EaseMob.sharedInstance().chatManager.addDelegate(self, delegateQueue: globalQueue)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func setupViewControllers() {
        chatListVC = ChatListVC()
        contactVC = ContactVC()
        profileVC = ProfileVC()
        
        viewControllers = [chatListVC, contactVC, profileVC]
    }
    
    func setupTabbarItem() {
        chatListVC.tabBarItem = UITabBarItem(
            title: "首页",
            image: UIImage(named: "chatList"),
            selectedImage: UIImage(named: "chatList"))
        chatListVC.tabBarItem.tag = 0
        
        contactVC.tabBarItem = UITabBarItem(
            title: "通讯录",
            image: UIImage(named: "contact"),
            selectedImage: UIImage(named: "contact"))
        contactVC.tabBarItem.tag = 1
        
        profileVC.tabBarItem = UITabBarItem(
            title: "个人资料",
            image: UIImage(named: "me"),
            selectedImage: UIImage(named: "me"))
        profileVC.tabBarItem.tag = 2
        
        tabBar.tintColor = UIColor(red: 0.529, green: 0.808, blue: 0.922, alpha: 1)
    }
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        switch item.tag {
        case 0:
            title = "会话"
            navigationItem.rightBarButtonItem = nil
        case 1:
            title = "通讯录"
            navigationItem.rightBarButtonItem = addFriendButton
        case 2:
            title = "个人资料"
            navigationItem.rightBarButtonItem = refreshProfileButton
        default:
            break
        }
    }
    
    // MARK: 添加好友、刷新资料按钮
    var addFriendButton: UIBarButtonItem {
        if addFriendBtn == nil {
            addFriendBtn = UIBarButtonItem(title: "添加", style: .Plain, target: self, action: Selector("addFriend"))
        }
        return addFriendBtn!
    }
    
    var refreshProfileButton: UIBarButtonItem {
        if refreshProfileBtn == nil {
            refreshProfileBtn = UIBarButtonItem(title: "刷新", style: .Plain, target: self, action: Selector("refreshProfile"))
        }
        return refreshProfileBtn!
    }
    
    // MARK: 添加好友
    func addFriend() {
        let alertController = UIAlertController(title: "添加好友", message: nil, preferredStyle: .Alert)
        let positiveAction = UIAlertAction(title: "添加", style: .Default) { (alertAction) -> Void in
            guard let name = alertController.textFields?[0].text else {
                MessageToast.toast(self.view, message: "操作失败！", keyBoardHeight: 0, finishBlock: nil)
                return
            }
            guard name != "" else {
                ZFAlertShow.sharedInstance.showAlert("添加失败", message: "未填写好友名字", inViewController: self)
                return
            }
            var error: EMError? = nil
            EaseMob.sharedInstance().chatManager.addBuddy(name, message: " ", error: &error)
            if error != nil {
                MessageToast.toast(self.view, message: "添加好友失败，请重试！", keyBoardHeight: 0, finishBlock: nil)
            }else {
                ZFAlertShow.sharedInstance.showAlert(nil, message: "请求成功！等待对方同意。", inViewController: self)
            }
        }
        let negativeAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "请输入好友的名字"
        }
        
        alertController.addAction(positiveAction)
        alertController.addAction(negativeAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK: 刷新资料
    func refreshProfile() {
        profileVC.refreshProfile()
    }
    // MARK: 异步获取好友列表的回调
    func didFetchedBuddyList(buddyList: [AnyObject]!, error: EMError!) {
        contactVC.refreshDataSource()
    }
    
    // MARK: 会话列表有变化时的回调
    func didUpdateConversationList(conversationList: [AnyObject]!) {
        chatListVC.refreshChatList(nil)
    }
    
    func didUpdateBuddyList(buddyList: [AnyObject]!, changedBuddies: [AnyObject]!, isAdd: Bool) {
        contactVC.refreshDataSource()
    }
    
    // MARK: 好友请求回调
    func didReceiveBuddyRequest(username: String!, var message: String!) {
        if message == nil {
            message = " "
        }
        FriendRequestVC.sharedViewController.appendNewRequest(username, message: message)
        runAsyncOnMainThread {
            self.contactVC.tableView.reloadData()
            self.contactVC.refreshTabbarUnreadCount()
        }
    }
    
    func didReceiveMessage(message: EMMessage!) {
        self.chatListVC.refreshChatList(nil)
    }
}

