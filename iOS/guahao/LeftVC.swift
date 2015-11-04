//
//  LeftVC.swift
//  guahao
//
//  Created by Jeff Wong on 15/11/1.
//  Copyright © 2015年 Jeff. All rights reserved.
//

import UIKit
import SnapKit

class LeftVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    weak var rootVC: MainVC?
    
    var dataSource = ["姓名", "个人资料", "修改密码", "注销", "设置"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        setupSubviews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupSubviews() {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.clearColor()
        view.addSubview(tableView)
        
        tableView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(view).offset(20)
            make.left.equalTo(view.snp_left)
            make.bottom.equalTo(view.snp_bottom)
            make.width.equalTo(200)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
        cell.textLabel?.text = dataSource[indexPath.row]
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.row == 3 {
            cancelRegister()
        }
    }
    
    func cancelRegister() {
        NSNotificationCenter.defaultCenter().postNotificationName("loginStateChanged", object: 4)
    }
}
