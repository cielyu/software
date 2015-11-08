//
//  ProfileVC.swift
//  GuahaoWithChat
//
//  Created by Jeff Wong on 15/11/5.
//  Copyright © 2015年 Jeff. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let tableView = UITableView()
    var dataSource: [Profile] = []
    var username = NSUserDefaults.standardUserDefaults().stringForKey("username")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        
        loadDataSource()
        setupSubviews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupSubviews() {
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(HeadImageCell.self, forCellReuseIdentifier: "HeadCell")
        
        let footerView = UIView(frame: CGRectMake(0, 0, tableView.frame.width, 40))
        
        let logoutBtn = UIButton(frame: CGRectMake(20, 10, footerView.frame.width - 40, 30))
        logoutBtn.backgroundColor = UIColor(red: 0.8, green: 0, blue: 0, alpha: 1)
        logoutBtn.setTitle("注销", forState: .Normal)
        logoutBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        logoutBtn.addTarget(self, action: Selector("logout"), forControlEvents: .TouchUpInside)
        
        footerView.addSubview(logoutBtn)
        tableView.tableFooterView = footerView
        
        view.addSubview(tableView)
    }
    
    // MARK: 加载用户资料
    func loadDataSource() {
        let manager = GHProfileManager.defaultManager
        guard let username = username else {
            ZFAlertShow.sharedInstance.showAlert(nil, message: "获取用户名失败！", inViewController: self)
            return
        }

        let row0 = Profile(key: "用户名", value: manager.getProfile(username, key: "username"))
        let row1 = Profile(key: "手机", value: manager.getProfile(username, key: "tel"))
        let row2 = Profile(key: "地址", value: manager.getProfile(username, key: "addr"))
        let row3 = Profile(key: "邮箱", value: manager.getProfile(username, key: "mail"))
        
        dataSource = [row0, row1, row2, row3]
    }
    
    // MARK: 刷新数据
    func reloadDataSource() {
        loadDataSource()
        tableView.reloadData()
    }
    
    // MARK: tableView dataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : dataSource.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return HeadImageCell.cellHeight
        }else {
            return 40
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if indexPath.section == 0 {
            let headCell = tableView.dequeueReusableCellWithIdentifier("HeadCell") as! HeadImageCell
            headCell.headImage.image = UIImage(named: "ChatListCellPlaceHolder")
            headCell.nameLabel.text = GHProfileManager.defaultManager.getProfile(username, key: "username")
            headCell.telLabel.text =
                "手机号码：" + GHProfileManager.defaultManager.getProfile(username, key: "tel")
            
            cell = headCell
        }else {
            let otherCell = UITableViewCell(style: .Value1, reuseIdentifier: "otherCell")
            let profile = dataSource[indexPath.row]
            otherCell.textLabel?.text = profile.key
            otherCell.detailTextLabel?.text = profile.value
            
            cell = otherCell
        }
        return cell
    }
    
    func refreshProfile() {
        let loading = ZFLoadingView()
        loading.show(InView: view, withTips: "正在刷新..")
        guard let username = username else {
            ZFAlertShow.sharedInstance.showAlert(nil, message: "获取用户名失败！", inViewController: self)
            return
        }
        dispatch_async(globalQueue) {
            let userno = GHProfileManager.defaultManager.getProfile(username, key: "username")
            let param = ["username": userno]
            ZFHttpRequest.postRequest(
                toUrl: "http://192.168.137.1:8000/checkdata/",
                withParameter: param,
                success: { (json) -> () in
                    print(json)
                    var keys: [String] = []
                    var values: [String?] = []
                    
                    if let tel = json["tel"] as? String {
                        keys.append("tel")
                        values.append(tel)
                    }
                    if let address = json["address"] as? String {
                        keys.append("addr")
                        values.append(address)
                    }
                    if let mail = json["mail"] as? String {
                        keys.append("mail")
                        values.append(mail)
                    }
                    
                    GHProfileManager.defaultManager.saveProfile(username, keys: keys, values: values)
                    MessageToast.toast(self.view, message: "刷新成功！", keyBoardHeight: 44, finishBlock: nil)
                    runAsyncOnMainThread {
                        self.reloadDataSource()
                    }
                    loading.hide()
                },
                failure: { (error) -> () in
                    ZFAlertShow.sharedInstance.showAlert(nil, message: "刷新失败！", inViewController: self)
                    loading.hide()
            })
        }
    }
    
    // MARK: 注销
    func logout() {
        let loading = ZFLoadingView()
        loading.show(InView: view, withTips: "正在注销..")
        
        var error: EMError? = nil
        EaseMob.sharedInstance().chatManager.logoffWithUnbindDeviceToken(true, error: &error)
        
        if error == nil {
            runAsyncOnMainThread {
                NSNotificationCenter.defaultCenter().postNotificationName(
                    "loginStateChanged", object: 4)
            }
        }else {
            MessageToast.toast(self.view, message: "注销失败，请重试！", keyBoardHeight: 0, finishBlock: nil)
        }
        
        loading.hide()
    }
}
