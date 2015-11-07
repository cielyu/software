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
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dataSource = dataSource else {
            return 0
        }
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return ChatListTableViewCell.cellHeight
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ChatListCell") as! ChatListTableViewCell
        
        let conversation = dataSource?[indexPath.row]
        cell.headImage.image = UIImage(named: "ChatListCellPlaceHolder")
        cell.nameLabel.text = conversation?.chatter
        cell.setUnreadCount(conversation?.unreadMessagesCount())
        cell.setCellBackgroundColor(indexPath.row % 2)
        cell.setLatestText(conversation?.latestMessage())
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if let chatter = dataSource?[indexPath.row].chatter {
            let chatVC = ChatVC(chatter: chatter)
            navigationController?.pushViewController(chatVC, animated: true)
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
