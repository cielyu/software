//
//  FriendProfileVC.swift
//  GuahaoWithChat
//
//  Created by Jeff Wong on 15/11/8.
//  Copyright © 2015年 Jeff. All rights reserved.
//

import UIKit

class FriendProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var friendName: String?
    var dataSource: [Profile]?
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "好友资料"
        view.backgroundColor = UIColor.whiteColor()
        setupSubviews()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if dataSource == nil {
            refreshFriendProfile()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupSubviews() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.registerClass(HeadImageCell.self, forCellReuseIdentifier: "HeadCell")
        tableView.registerClass(SettingsCell.self, forCellReuseIdentifier: "SettingsCell")
        
        view.addSubview(tableView)
        
        tableView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(view)
        }
    }
    
    // MARK: tableView dataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else if section == 1 {
            return dataSource == nil ? 0 : dataSource!.count
        }else {
            return 2
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return HeadImageCell.cellHeight
        }else {
            return 40
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if indexPath.section == 0 {
            let headCell = tableView.dequeueReusableCellWithIdentifier("HeadCell") as! HeadImageCell
            headCell.headImage.image = UIImage(named: "ChatListCellPlaceHolder")
            headCell.nameLabel.text = friendName
            
            cell = headCell
        }else if indexPath.section == 1 {
            let profileCell = UITableViewCell(style: .Value1, reuseIdentifier: "value1")
            let item = dataSource?[indexPath.row]
            profileCell.textLabel?.text = item?.key
            profileCell.textLabel?.text = item?.value
            
            cell = profileCell
        }else {
            let settingsCell = tableView.dequeueReusableCellWithIdentifier("SettingsCell") as! SettingsCell
            if indexPath.row == 0 {
                settingsCell.label.text = "清除聊天数据"
                settingsCell.label.textColor = UIColor.blackColor()
            }else {
                settingsCell.label.text = "删除好友"
                settingsCell.label.textColor = UIColor.redColor()
            }
            cell = settingsCell
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        guard let name = friendName else {
            return
        }
        if indexPath.section == 2 {
            if indexPath.row == 0 {
                // MARK: 清除聊天记录
                EaseMob.sharedInstance().chatManager.removeConversationByChatter?(name, deleteMessages: true, append2Chat: true)
                MessageToast.toast(view, message: "清除成功！", keyBoardHeight: 0, finishBlock: nil)
            }else {
                // MARK: 删除好友
                let alertController = UIAlertController(title: nil, message: "是否删除该好友？", preferredStyle: .Alert)
                let positiveAction = UIAlertAction(title: "删除", style: .Destructive, handler: { (action) -> Void in
                    
                    var error: EMError? = nil
                    EaseMob.sharedInstance().chatManager.removeBuddy(
                        name, removeFromRemote: true, error: &error)
                    EaseMob.sharedInstance().chatManager.removeConversationByChatter?(name, deleteMessages: true, append2Chat: true)
                    if error == nil {
                        ZFAlertShow.sharedInstance.showAlert("成功", message: "该好友已删除", inViewController: self)
                        runAsyncOnMainThread {
                            self.navigationController?.popToRootViewControllerAnimated(true)
                        }
                    }else {
                        ZFAlertShow.sharedInstance.showAlert("失败", message: "删除好友失败，请重试！", inViewController: self)
                    }
                })
                let negativeAction = UIAlertAction(title: "取消", style: .Default, handler: nil)
                
                alertController.addAction(negativeAction)
                alertController.addAction(positiveAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: 获取好友资料
    func refreshFriendProfile() {
        guard let name = friendName else {
            MessageToast.toast(view, message: "获取资料失败！", keyBoardHeight: 0, finishBlock: nil)
            return
        }
        let loading = ZFLoadingView()
        loading.show(InView: view, withTips: "正在加载..")
        
        dispatch_async(globalQueue) {
            ZFHttpRequest.postRequest(
                toUrl: "http://192.168.137.1:8000/checkdata/",
                withParameter: ["username": name],
                success: { (json) -> () in
                    var profile = [Profile]()
                    
                    let tel = json["tel"] as? String
                    let addr = json["address"] as? String
                    let mail = json["mail"] as? String
                    
                    let _tel = tel == nil ? "" : tel!
                    let _addr = addr == nil ? "" : addr!
                    let _mail = mail == nil ? "" : mail!
                    
                    profile.append(Profile(key: "手机", value: _tel))
                    profile.append(Profile(key: "地址", value: _addr))
                    profile.append(Profile(key: "邮箱", value: _mail))
                    
                    self.dataSource = profile
                    runAsyncOnMainThread {
                        self.tableView.reloadData()
                    }
                    loading.hide()
                },
                failure: { (error) -> () in
                    print(error)
                    loading.hide()
                    MessageToast.toast(self.view, message: "获取资料失败！", keyBoardHeight: 0, finishBlock: nil)
            })
        }
    }
}
