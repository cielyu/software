//
//  BookListVC.swift
//  GuahaoWithChat
//
//  Created by Jeff Wong on 15/11/8.
//  Copyright © 2015年 Jeff. All rights reserved.
//

import UIKit

class BookListVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let tableView = UITableView()
    lazy var dataSource: [BookItem] = []
    let username = NSUserDefaults.standardUserDefaults().stringForKey("username")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "预约列表"
        view.backgroundColor = UIColor.whiteColor()
        setupSubviews()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        refreshDataSource(nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupSubviews() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(
            self, action: Selector("refreshDataSource:"), forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
        
        view.addSubview(tableView)
        
        tableView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(view)
        }
    }
    
    // MARK: tableView dataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Value1, reuseIdentifier: "cell")
        let item = dataSource[indexPath.row]
        cell.textLabel?.text = item.doctor
        cell.detailTextLabel?.text = item.date
        return cell
    }
    
    // MARK: 刷新数据
    func refreshDataSource(refreshControl: UIRefreshControl?) {
        guard let username = username else {
            refreshControl?.endRefreshing()
            return
        }
        refreshControl?.beginRefreshing()
        let param = ["username": username]
        postRequest(param) {
            runAsyncOnMainThread {
                refreshControl?.endRefreshing()
            }
        }
    }
    
    // MARK: 请求预约数据
    func postRequest(param: [String: String], finishHandler: () -> ()) {
        dispatch_async(globalQueue) {
            ZFHttpRequest.postRequest(
                toUrl: "http://192.168.137.1:8000/usercheck/",
                withParameter: param,
                success: { (json) -> () in
                    print(json)
                    if let status = json["status"] as? String where status == "success",
                        let arrStr = json["arr"] as? String,
                        let data = arrStr.dataUsingEncoding(NSUTF8StringEncoding),
                        let arrJson = try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments),
                        let jsonDict = arrJson as? [[String: NSObject]] {
                            self.dataSource = jsonDict.map { BookItem.serialization($0) }
                            runAsyncOnMainThread {
                                self.tableView.reloadData()
                            }
                    }else {
                        ZFAlertShow.sharedInstance.showAlert(
                            nil, message: "预约列表加载失败，请重试", inViewController: self)
                    }
                    finishHandler()
                },
                failure: { (error) -> () in
                    ZFAlertShow.sharedInstance.showAlert(
                        nil, message: "获取列表失败！\(error)", inViewController: self)
                    finishHandler()
            })
        }
    }
}
