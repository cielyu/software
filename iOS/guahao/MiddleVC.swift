//
//  MainVC.swift
//  guahao
//
//  Created by Jeff Wong on 15/10/11.
//  Copyright © 2015年 Jeff. All rights reserved.
//

import UIKit
import SnapKit

struct Hospital {
    var hospital: String
    
    static func serialization(dict: [String: NSObject]) -> Hospital {
        if let fields = dict["fields"] as? [String: String], let honame = fields["honame"] {
            return Hospital(hospital: honame)
        }else {
            return Hospital(hospital: "")
        }
    }
}

class MiddleVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var collectionView: UICollectionView!
    
    var dataSource: [Hospital]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        title = "类别"
        setupSubviews()
        setRightButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if dataSource == nil {
            postRequest()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupSubviews() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let sizeWidth = (view.frame.width - 40) / 3
        layout.itemSize = CGSizeMake(sizeWidth, sizeWidth)
        layout.sectionInset = UIEdgeInsetsMake(5, 10, 5, 10)
        
        collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerClass(GHCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        view.addSubview(collectionView)
        
        collectionView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(UIEdgeInsetsMake(64, 0, 0, 0))
        }
    }
    
    func setRightButtonItem() {
        let rightBtn = UIBarButtonItem(title: "刷新", style: .Plain, target: self, action: Selector("refreshData:"))
        navigationItem.rightBarButtonItem = rightBtn
    }
    
    // MARK: 网络请求
    func postRequest() {
        let loading = ZFLoadingView()
        loading.show(InView: view, withTips: "加载中...")
        dispatch_async(dispatch_queue_create("hospital", DISPATCH_QUEUE_SERIAL)) {
            ZFHttpRequest.postRequest(
                toUrl: "http://192.168.137.1:8000/getlist/",
                withParameter: nil,
                success: { (json) -> () in
                    if let hospitalArr = json as? [[String: NSObject]] {
                            self.dataSource = hospitalArr.map { Hospital.serialization($0) }
                            dispatch_async(dispatch_get_main_queue()) {
                                self.collectionView.reloadData()
                            }
                    }else {
                        MessageToast.toast(self.view, message: "加载失败！", keyBoardHeight: 0, finishBlock: nil)
                    }
                    loading.hide()
                }) { (error) -> () in
                    print(error)
                    MessageToast.toast(self.view, message: "加载失败！", keyBoardHeight: 0, finishBlock: nil)
                    loading.hide()
            }
        }
    }
    
    // MARK: 注销
    func refreshData(button: UIButton) {
        postRequest()
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource == nil ? 0 : dataSource!.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! GHCollectionViewCell
        cell.label.text = dataSource?[indexPath.row].hospital
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        
    }
}
