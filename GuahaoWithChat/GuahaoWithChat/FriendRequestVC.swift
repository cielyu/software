//
//  FriendRequestVC.swift
//  GuahaoWithChat
//
//  Created by Jeff Wong on 15/11/5.
//  Copyright © 2015年 Jeff. All rights reserved.
//

import UIKit

class FriendRequestVC: UIViewController, UITableViewDataSource, UITableViewDelegate, FriendRequestTableViewCellDelegate {
    private let tableView = UITableView()
    private var dataSource: [RequestInfo] = []
    
    class var sharedViewController: FriendRequestVC {
        struct shared {
            static let controller = FriendRequestVC()
        }
        return shared.controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        title = "申请与通知"
        setupSubviews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setupSubviews() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.registerClass(FriendRequestTableViewCell.self, forCellReuseIdentifier: "RequestCell")
        view.addSubview(tableView)
        
        tableView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(view)
        }
    }
    
    // MARK: tableView dataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return FriendRequestTableViewCell.cellHeight
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RequestCell") as! FriendRequestTableViewCell
        let item = dataSource[indexPath.row]
        cell.nameLabel.text = item.username
        cell.decriptionLabel.text = item.message
        cell.row = indexPath.row
        cell.delegate = self
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    // MARK: 接受、拒绝回调
    func acceptFriendRequest(row: Int) {
        var error: EMError? = nil
        EaseMob.sharedInstance().chatManager.acceptBuddyRequest(dataSource[row].username, error: &error)
        finishAcceptOrReject(error, forRow: row)
    }
    func rejectFriendRequest(row: Int) {
        var error: EMError? = nil
        EaseMob.sharedInstance().chatManager.rejectBuddyRequest(dataSource[row].username, reason: "", error: &error)
        finishAcceptOrReject(error, forRow: row)
    }
    
    func finishAcceptOrReject(error: EMError?, forRow row: Int) {
        if error != nil {
            ZFAlertShow.sharedInstance.showAlert(nil, message: "操作失败，请重试", inViewController: self)
        }else {
            MessageToast.toast(view, message: "操作成功", keyBoardHeight: 0, finishBlock: nil)
            dataSource.removeAtIndex(row)
            tableView.reloadData()
        }
    }
    
    /**
     将新的请求加到列表中
    
     - Parameter username: 请求者名字
     - Parameter message: 请求原因
     */
    func appendNewRequest(username: String, message: String) {
        dataSource.append(RequestInfo(username: username, message: message))
        runAsyncOnMainThread {
            self.tableView.reloadData()
        }
    }
    
    var requestCount: UInt {
        return UInt(dataSource.count)
    }
}
