//
//  ContactVC.swift
//  GuahaoWithChat
//
//  Created by Jeff Wong on 15/11/5.
//  Copyright © 2015年 Jeff. All rights reserved.
//

import UIKit

class ContactVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let tableView = UITableView()
    
    var dataSource: [EMBuddy]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        
        setupSubviews()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        refreshDataSource()
        refreshTabbarUnreadCount()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupSubviews() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.sectionHeaderHeight = 0
        tableView.tableFooterView = UIView()
        tableView.registerClass(ContactTableViewCell.self, forCellReuseIdentifier: "ContactCell")
        view.addSubview(tableView)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("updateBuddyList:"), forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
        
        tableView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(view).inset(0)
        }
    }

    // MARK: tableView dataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else {
            guard let dataSource = dataSource else {
                return 0
            }
            return dataSource.count
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return ContactTableViewCell.cellHeight
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactCell") as! ContactTableViewCell
        cell.headImage.image = UIImage(named: "ChatListCellPlaceHolder")
        if indexPath.section == 0 {
            cell.nameLabel.text = "申请与通知"
            cell.setUnreadCount(FriendRequestVC.sharedViewController.requestCount)
        }else {
            cell.setUnreadCount(0)
            cell.nameLabel.text = dataSource?[indexPath.row].username
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 0 {
            // TODO: 跳转到好友请求页面
            navigationController?.pushViewController(FriendRequestVC.sharedViewController, animated: true)
        }else {
            if let chatter = dataSource?[indexPath.row].username {
                let chatVC = ChatVC(chatter: chatter)
                navigationController?.pushViewController(chatVC, animated: true)
            }
        }
    }
    
    // MARK: tableView删除好友
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.section == 0 {
            return false
        }else {
            return true
        }
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        if indexPath.section == 1 {
            return .Delete
        }else {
            return .None
        }
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        if indexPath.section == 1 {
            let action = UITableViewRowAction(style: .Default, title: "删除") { (action, index) -> Void in
                var name: String
                if let username = self.dataSource?[index.row].username {
                    name = username
                }else {
                    name = ""
                }
                let alertController = UIAlertController(title: nil, message: "确认删除好友“\(name)”？", preferredStyle: .Alert)
                let positiveAction = UIAlertAction(title: "删除", style: .Destructive, handler: { (action) -> Void in
                    self.deleteBuddy(name)
                })
                let negativeAction = UIAlertAction(title: "取消", style: .Default, handler: nil)
                
                alertController.addAction(negativeAction)
                alertController.addAction(positiveAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
            return [action]
        }else {
            return nil
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            MessageToast.toast(view, message: "删除", keyBoardHeight: 0, finishBlock: nil)
        }
    }
    
    
    // MARK: 手动获取好友
    func updateBuddyList(refreshControl: UIRefreshControl) {
        EaseMob.sharedInstance().chatManager.asyncFetchBuddyListWithCompletion({ (buddyList, error) -> Void in
            self.dataSource = self.filterBuddyList(buddyList as? [EMBuddy])
            runAsyncOnMainThread {
                self.tableView.reloadData()
                refreshControl.endRefreshing()
            }
        }, onQueue: globalQueue)
    }
    
    // MARK: 刷新好友列表
    func refreshDataSource() {
        let buddyList = EaseMob.sharedInstance().chatManager.buddyList
        dataSource = filterBuddyList(buddyList as? [EMBuddy])
        runAsyncOnMainThread {
            self.tableView.reloadData()
            self.refreshTabbarUnreadCount()
        }
    }
    
    // MARK: 对好友列表进行过滤，过滤掉没有加我好友的
    func filterBuddyList(buddyList: [EMBuddy]?) -> [EMBuddy]? {
        guard let buddyList = buddyList else {
            return nil
        }
        return buddyList.flatMap({ (buddy) -> EMBuddy? in
            if buddy.followState == .eEMBuddyFollowState_FollowedBoth {
                return buddy
            }else {
                return nil
            }
        })
    }
    
    // MARK: 刷新tabbar上的好友请求条数
    func refreshTabbarUnreadCount() {
        let badge = FriendRequestVC.sharedViewController.requestCount
        if badge == 0 {
            tabBarItem.badgeValue = nil
        }else if badge > 1000 {
            tabBarItem.badgeValue = "999+"
        }else {
            tabBarItem.badgeValue = "\(badge)"
        }
    }
    
    // MARK: 删除好友
    func deleteBuddy(buddyName: String) {
        let loading = ZFLoadingView()
        loading.show(InView: view, withTips: "操作中...")
        
        var error: EMError? = nil
        EaseMob.sharedInstance().chatManager.removeBuddy(buddyName, removeFromRemote: true, error: &error)
        if error != nil {
            ZFAlertShow.sharedInstance.showAlert("出错", message: "删除失败！", inViewController: self)
        }else {
            ZFAlertShow.sharedInstance.showAlert("成功", message: "好友已删除", inViewController: self)
            EaseMob.sharedInstance().chatManager.removeConversationByChatter?(buddyName, deleteMessages: true, append2Chat: true)
        }
        
        loading.hide()
        refreshDataSource()
    }
}
