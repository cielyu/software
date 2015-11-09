//
//  BookTimeSelectVC.swift
//  GuahaoWithChat
//
//  Created by Jeff Wong on 15/11/8.
//  Copyright © 2015年 Jeff. All rights reserved.
//

import Foundation

class BookTimeSelectVC: UIViewController, UITableViewDataSource, UITableViewDelegate, GHTimePickerViewDelegate {
    var time: [Float] = []
    var hospital: String = ""
    var department: String = ""
    var doctor: String = ""
    var username = NSUserDefaults.standardUserDefaults().stringForKey("username")
    
    var date: [String] = []
    
    var seletedTime: Float?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "预约时间"
        view.backgroundColor = UIColor.whiteColor()
        
        setupDataSource()
        setupSubviews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupSubviews() {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        view.addSubview(tableView)
        
        tableView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(view)
        }
    }
    
    func setupDataSource() {
        date = time.map{ $0.chineseDateFormat }
    }
    
    // MARK: tableView dataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return date.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "Cell")
        cell.textLabel?.text = date[indexPath.row]
        cell.accessoryType = .DisclosureIndicator
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        pickTime(time[indexPath.row])
    }
    
    // MARK: 选择时间
    func pickTime(timeStamp: Float) {
        let picker = GHTimePickerView(frame: view.bounds, timeStamp: timeStamp)
        picker.delegate = self
        picker.show(view)
    }
    
    // MARK: GHTimePickerViewDelegate
    func pickerDidCancel() {
        
    }
    
    func pickerDidConfirm(date: NSDate) {
        guard let username = username else {
            ZFAlertShow.sharedInstance.showAlert("错误", message: "程序出现异常，预约失败！，请尝试重新登陆!", inViewController: self)
            return
        }
        let loading = ZFLoadingView()
        loading.show(InView: view, withTips: "预约中..")
        
        let dateStr = "\(lround(date.timeIntervalSince1970))"
        let param = [
            "username": username,
            "hospital": hospital,
            "department": department,
            "doctor": doctor,
            "date": dateStr]
        dispatch_async(globalQueue) {
            ZFHttpRequest.postRequest(
                toUrl: "http://192.168.137.1:8000/appointment/",
                withParameter: param,
                success: { (json) -> () in
                    if let status = json["status"] as? String where status == "success" {
                        // TODO: 注册localNotification
                        
                        ZFAlertShow.sharedInstance.showAlert(nil, message: "预约成功！", inViewController: self)
                        runAsyncOnMainThread {
                            // MARK: 增加提醒
                            let notification = UILocalNotification()
                            notification.timeZone = NSTimeZone(forSecondsFromGMT: 28800)
                            notification.fireDate = date
                            notification.alertTitle = "您有一个预约"
                            notification.alertBody = "您预约了\(self.doctor)医生，请准时前往医院！"
                            notification.applicationIconBadgeNumber = 1
                            UIApplication.sharedApplication().scheduleLocalNotification(notification)
                            
                            self.navigationController?.popViewControllerAnimated(true)
                        }
                    }else {
                        ZFAlertShow.sharedInstance.showAlert("失败", message: "预约失败！", inViewController: self)
                    }
                    loading.hide()
                },
                failure: { (error) -> () in
                    ZFAlertShow.sharedInstance.showAlert("失败", message: "预约失败，请重试。\(error)", inViewController: self)
                    loading.hide()
            })
        }
    }
    
    
}