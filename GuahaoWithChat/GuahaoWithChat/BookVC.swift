//
//  BookVC.swift
//  guahao
//
//  Created by Jeff Wong on 15/11/4.
//  Copyright © 2015年 Jeff. All rights reserved.
//

import UIKit

class BookVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let tableView = UITableView()
    
    var hospital: String?
    var department: String?
    var doctorName: String?
    
    var dataSource: [Profile]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        title = "预约"
        
        setupSubviews()
        setupRefreshButton()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
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
    
    func setupRefreshButton() {
        let rightBtn = UIBarButtonItem(
            title: "刷新", style: .Plain, target: self, action: Selector("refreshDataSource"))
        navigationItem.rightBarButtonItem = rightBtn
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
            return 1
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }else {
            return 10
        }
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
            headCell.nameLabel.text = doctorName
            
            cell = headCell
        }else if indexPath.section == 1 {
            let profileCell = UITableViewCell(style: .Value1, reuseIdentifier: "profileCell")
            let item = dataSource?[indexPath.row]
            profileCell.textLabel?.text = item?.key
            profileCell.detailTextLabel?.text = item?.value
            
            cell = profileCell
        }else {
            let settingsCell = tableView.dequeueReusableCellWithIdentifier("SettingsCell") as! SettingsCell
            settingsCell.label.text = "立即预约"
            
            cell = settingsCell
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.section == 2 && indexPath.row == 0 {
            book()
        }
    }
    
    // MARK: 取得医生资料
    func refreshDataSource() {
//        let loading = ZFLoadingView()
//        loading.show(InView: view, withTips: "正在加载医生资料..")
        
        
    }
    
    // MARK: 预约
    func book() {
        guard let hospital = hospital,
            let department = department,
            let doctorName = doctorName else {
            return
        }
        
        let loading = ZFLoadingView()
        loading.show(InView: view, withTips: "正在加载预约信息..")
        
        dispatch_async(globalQueue) {
            let param = [
                "hospital": hospital,
                "department": department,
                "doctor": doctorName]
            ZFHttpRequest.postRequest(
                toUrl: "http://192.168.137.1:8000/getwant/",
                withParameter: param,
                success: { (json) -> () in
                    if let status = json["status"] as? String where status == "success",
                        let time = json["time"] as? [Float] {
                            print(time)
                            let selectTimeVC = BookTimeSelectVC()
                            selectTimeVC.time = time
                            selectTimeVC.hospital = hospital
                            selectTimeVC.department = department
                            selectTimeVC.doctor = doctorName
                            runAsyncOnMainThread {
                                self.navigationController?.pushViewController(
                                    selectTimeVC, animated: true)
                            }
                    }else {
                        ZFAlertShow.sharedInstance.showAlert(
                            nil, message: "该医生暂时不接受预约", inViewController: self)
                    }
                    loading.hide()
                }) { (error) -> () in
                    loading.hide()
                    MessageToast.toast(self.view, message: "网络连接失败！", keyBoardHeight: 0, finishBlock: nil)
            }
        }
        
    }
}
