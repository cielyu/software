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
            return dataSource == nil ? 0 : dataSource!.count
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
    
    
    // MARK: 手动获取好友
    func updateBuddyList(refreshControl: UIRefreshControl) {
        EaseMob.sharedInstance().chatManager.asyncFetchBuddyListWithCompletion({ (buddyList, error) -> Void in
            self.dataSource = self.filterBuddyList(buddyList as? [EMBuddy])
            runAsyncOnMainThread {
                self.tableView.reloadData()
                refreshControl.endRefreshing()
            }
        }, onQueue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
    }
    
    // MARK: 刷新好友列表
    func refreshDataSource() {
        let buddyList = EaseMob.sharedInstance().chatManager.buddyList
        dataSource = filterBuddyList(buddyList as? [EMBuddy])
        runAsyncOnMainThread {
            self.tableView.reloadData()
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
}
