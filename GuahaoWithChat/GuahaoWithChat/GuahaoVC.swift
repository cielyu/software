//
//  Middle2VC.swift
//  guahao
//
//  Created by Jeff Wong on 15/11/4.
//  Copyright © 2015年 Jeff. All rights reserved.
//

import UIKit

enum GuahaoVCType {
    case Hospital
    case Department
    case Doctor
}

class GuahaoVC: BaseCollectionVC {
    var dataSource: [Category]?
    
    var type: GuahaoVCType
    var paramValue1: String?
    var paramValue2: String?
    
    init(type: GuahaoVCType) {
        self.type = type
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch type {
        case .Hospital:
            title = "选择医院"
        case .Department:
            title = "选择类别"
            setupLeftBackButtonItem()
        case .Doctor:
            title = "预约医生"
            setupLeftBackButtonItem()
        }
        
        setRightButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if dataSource == nil {
            postRequest()
        }
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        
        collectionView?.registerClass(GHCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    func setRightButtonItem() {
        let rightBtn = UIBarButtonItem(title: "刷新", style: .Plain, target: self, action: Selector("postRequest"))
        navigationItem.rightBarButtonItem = rightBtn
    }
    
    func setupLeftBackButtonItem() {
        let leftBtn = UIBarButtonItem(title: "返回", style: .Plain, target: self, action: Selector("back"))
        navigationItem.leftBarButtonItem = leftBtn
    }
    
    func back() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: 网络请求
    func postRequest() {
        let loading = ZFLoadingView()
        loading.show(InView: view, withTips: "加载中...")
        
        let url = GHRequestHelper.sharedInstance.getPostURL(type)
        let (param, success) = GHRequestHelper.sharedInstance.getPostParam(type, hospital: paramValue1, department: paramValue2)
        guard success else {
            ZFAlertShow.sharedInstance.showAlert("错误", message: "缺少参数！", inViewController: self)
            return
        }
        
        dispatch_async(dispatch_queue_create("hospital", DISPATCH_QUEUE_SERIAL)) {
            ZFHttpRequest.postRequest(
                toUrl: url,
                withParameter: param,
                success: { (json) -> () in
                    if let list = json as? [String] {
                        self.dataSource = list.map { Category.serialization($0) }
                        dispatch_async(dispatch_get_main_queue()) {
                            self.collectionView?.reloadData()
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
    
    // MARK: collectionView Delegate & DataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource == nil ? 0 : dataSource!.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! GHCollectionViewCell
        cell.label.text = dataSource?[indexPath.row].name
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        switch type {
        case .Hospital:
            let vcToPresent = GuahaoVC(type: .Department)
            vcToPresent.paramValue1 = dataSource?[indexPath.row].name
        case .Department:
            let vcToPresent = GuahaoVC(type: .Doctor)
            vcToPresent.paramValue1 = paramValue1
            vcToPresent.paramValue2 = dataSource?[indexPath.row].name
        case .Doctor:
            navigationController?.pushViewController(BookVC(), animated: true)
            break
        }
        
    }
}
