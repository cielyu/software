//
//  ChatListVC.swift
//  GuahaoWithChat
//
//  Created by Jeff Wong on 15/11/4.
//  Copyright © 2015年 Jeff. All rights reserved.
//

import UIKit

class ChatListVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var tableView: UITableView!
    
    var dataSource: [EMConversation]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        title = "会话"
        
        setupSubviews()
        EaseMob.sharedInstance().chatManager.loadAllConversationsFromDatabaseWithAppend2Chat?(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        refreshChatList(nil)
    }
    func setupSubviews() {
        tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.registerClass(ChatListTableViewCell.self, forCellReuseIdentifier: "ChatListCell")
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("refreshChatList:"), forControlEvents: .ValueChanged)
        
        tableView.addSubview(refreshControl)
        view.addSubview(tableView)
        
        tableView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(view)
        }
    }
    
    // MARK: tableView DataSource
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
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }else {
            return 20
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return ChatListTableViewCell.cellHeight
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ChatListCell") as! ChatListTableViewCell
        if indexPath.section == 0 {
            cell.nameLabel.text = "挂号"
            cell.setUnreadCount(0)
            cell.setCellBackgroundColor(0)
            cell.setLatestText(nil)
        }else {
            let conversation = dataSource?[indexPath.row]
            cell.headImage.image = UIImage(named: "ChatListCellPlaceHolder")
            cell.nameLabel.text = conversation?.chatter
            cell.setUnreadCount(conversation?.unreadMessagesCount())
            cell.setCellBackgroundColor(indexPath.row % 2)
            cell.setLatestText(conversation?.latestMessage())
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 0 {
            let guahaoVC = GuahaoVC(type: .Hospital)
            navigationController?.pushViewController(guahaoVC, animated: true)
        }else {
            if let chatter = dataSource?[indexPath.row].chatter {
                let chatVC = ChatVC(chatter: chatter)
                navigationController?.pushViewController(chatVC, animated: true)
            }
        }
    }
    
    // MARK: 刷新好友列表
    func refreshChatList(refreshControl: UIRefreshControl?) {
        refreshControl?.beginRefreshing()
        dataSource = EaseMob.sharedInstance().chatManager.conversations as? [EMConversation]
        runAsyncOnMainThread {
            self.tableView.reloadData()
            refreshControl?.endRefreshing()
            self.refreshTabbarUnreadCount()
        }
    }
    
    // MARK: 刷新tabbar上的未读条数
    func refreshTabbarUnreadCount() {
        guard let conversations = dataSource else {
            tabBarItem.badgeValue = "0"
            return
        }
        var badge: UInt = 0
        for conversation in conversations {
            badge += conversation.unreadMessagesCount()
        }
        if badge == 0 {
            tabBarItem.badgeValue = nil
        }else if badge > 1000 {
            tabBarItem.badgeValue = "999+"
        }else {
            tabBarItem.badgeValue = "\(badge)"
        }
    }
    
}
