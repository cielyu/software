//
//  MainVC.swift
//  guahao
//
//  Created by Jeff Wong on 15/10/11.
//  Copyright © 2015年 Jeff. All rights reserved.
//

import UIKit

class MiddleVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        title = "类别"
        setupSubviews()
        setRightButtonItem()
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
        
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
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
        let rightBtn = UIBarButtonItem(title: "注销", style: .Plain, target: self, action: Selector("cancelLogin:"))
        navigationItem.rightBarButtonItem = rightBtn
    }
    
    // MARK: 注销
    func cancelLogin(button: UIButton) {
        NSNotificationCenter.defaultCenter().postNotificationName("loginStateChanged", object: 4, userInfo: nil)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! GHCollectionViewCell
        cell.label.text = "挂号\(indexPath.row)"
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
    }
}
