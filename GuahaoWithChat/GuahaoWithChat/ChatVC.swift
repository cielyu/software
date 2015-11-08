//
//  ChatVC.swift
//  GuahaoWithChat
//
//  Created by Jeff Wong on 15/11/4.
//  Copyright © 2015年 Jeff. All rights reserved.
//

import UIKit

class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource, EMChatManagerDelegate, ChatToolbarDelegate {
    var chatter: String
    let userno = NSUserDefaults.standardUserDefaults().stringForKey("username")
    
    var tableView: UITableView!
    var chatToolbar: ChatToolbar!
    var tableViewOriginRect: CGRect!
    
    var dataSource: [EMMessage]?
    var isFirstLoad = true
    
    init(chatter: String) {
        self.chatter = chatter
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        title = chatter
        
        setupSubviews()
        setupFriendProfileBtn()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // MARK: 注册接收在线消息的回调
        EaseMob.sharedInstance().chatManager.addDelegate(self, delegateQueue: nil)
        registerKeyboardActionNotification()
        updataChatRecord()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // MARK: 移除回调
        EaseMob.sharedInstance().chatManager.removeDelegate(self)
        removeKeyboardActionNotification()
        
        EaseMob.sharedInstance().chatManager.conversationForChatter?(chatter, conversationType: .eConversationTypeChat).markAllMessagesAsRead(true)
    }
    
    func setupSubviews() {
        tableView = UITableView(frame: CGRectMake(0, 0, view.frame.width, view.frame.height - ChatToolbar.defaultHeight))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .None
        tableView.registerClass(ChatViewTableViewCell.self, forCellReuseIdentifier: "ChatViewCell")
        tableView.allowsSelection = false
        tableViewOriginRect = tableView.frame
        
        chatToolbar = ChatToolbar(frame: CGRectMake(
            0, tableView.frame.maxY, view.frame.width, ChatToolbar.defaultHeight))
        chatToolbar.delegate = self
        
        view.addSubview(tableView)
        view.addSubview(chatToolbar)
    }
    
    // MARK: 查看好友资料按钮
    func setupFriendProfileBtn() {
        let profileBtn = UIBarButtonItem(
            image: UIImage(named: "friendProfile"), style: .Plain,
            target: self, action: Selector("showFriendPofile"))
        navigationItem.rightBarButtonItem = profileBtn
    }
    
    // MARK: 好友资料
    func showFriendPofile() {
        let friendProfileVC = FriendProfileVC()
        friendProfileVC.friendName = title
        navigationController?.pushViewController(friendProfileVC, animated: true)
    }
    
    // MARK: 监听键盘呼出
    func registerKeyboardActionNotification() {
        NSNotificationCenter.defaultCenter().addObserver(
            self, selector: Selector("keyboardWillShow:"),
            name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(
            self, selector: Selector("keyboardWillHide:"),
            name: UIKeyboardWillHideNotification, object: nil)
    }
    // MARK: 移除键盘监听
    func removeKeyboardActionNotification() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: tableView dataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dataSource = dataSource else {
            return 0
        }
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let message = dataSource?[indexPath.row]
        let text = (message?.messageBodies.first as? EMTextMessageBody)?.text
        let labelSize = GHChatLabel.sizeOfLabel(
            withText: text,
            font: GHChatLabel.defaultFont)
        return labelSize.height + 20
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ChatViewCell") as! ChatViewTableViewCell
        let item = dataSource?[indexPath.row]
        let text = (item?.messageBodies.first as? EMTextMessageBody)?.text
        if let from = item?.from where from == userno {
            cell.setText(.Right, text: text)
        }else {
            cell.setText(.Left, text: text)
        }
        return cell
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    // MARK: ChatToolbarDelegate，发送
    func sendButtonClicked() {
        guard let msg = chatToolbar.textField.text where msg != "" else {
            ZFAlertShow.sharedInstance.showAlert(nil, message: "消息不能为空", inViewController: self)
            return
        }
        let chatText = EMChatText(text: msg)
        let message = EMMessage(
            receiver: chatter,
            bodies: [EMTextMessageBody(chatObject: chatText)])
        
        var error: EMError? = nil
        EaseMob.sharedInstance().chatManager.sendMessage(message, progress: nil, error: &error)
        if error == nil {
            chatToolbar.textField.text = ""
            updataChatRecord()
        }else {
            MessageToast.toast(
                (UIApplication.sharedApplication().delegate as? AppDelegate)?.window,
                message: "发送失败！", keyBoardHeight: 0, finishBlock: nil)
        }
    }
    
    // MARK: 从内存中加载该用户的会话
    func updataChatRecord() {
        let conversation = EaseMob.sharedInstance().chatManager.conversationForChatter?(chatter, conversationType: .eConversationTypeChat)
        conversation?.markAllMessagesAsRead(true)
        
        dataSource = conversation?.loadAllMessages() as? [EMMessage]
        tableView.reloadData()
        if isFirstLoad {
            scrollToBottom(tableView.frame.height, animated: false)
            isFirstLoad = false
        }else {
            scrollToBottom(tableView.frame.height, animated: true)
        }
    }
    
    // MARK: 接收来自该用户的消息
    func didReceiveMessage(message: EMMessage!) {
        guard message.from == chatter else {
            return
        }
        if dataSource == nil {
            dataSource = []
        }
        dataSource?.append(message)
        
        let newIndexPath = NSIndexPath(forRow: dataSource!.count - 1, inSection: 0)
        runAsyncOnMainThread {
            self.tableView.beginUpdates()
            self.tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Top)
            self.tableView.endUpdates()
            self.scrollToBottom(self.tableView.frame.height, animated: true)
        }
    }
    
    // MARK: 键盘监听
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardRect = notification.userInfo?[UIKeyboardFrameEndUserInfoKey]?.CGRectValue {
            let height = keyboardRect.height
            let toHeight = self.tableViewOriginRect.height - height
            UIView.animateWithDuration(0.2) {
                self.tableView.frame.size.height = toHeight
            }
            scrollToBottom(toHeight, animated: true)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        UIView.animateWithDuration(0.2) {
            self.tableView.frame.size.height = self.tableViewOriginRect.height
        }
    }
    
    func scrollToBottom(endHeight: CGFloat, animated: Bool) {
        if endHeight < tableView.contentSize.height {
            var endOffsetY: CGFloat
            if isFirstLoad {
                endOffsetY = tableView.contentSize.height - endHeight + 64
            }else {
                endOffsetY = tableView.contentSize.height - endHeight
            }
            if animated {
                UIView.animateWithDuration(0.2) {
                    self.tableView.contentOffset.y = endOffsetY
                }
            }else {
                tableView.contentOffset.y = endOffsetY
            }
        }
    }
}
