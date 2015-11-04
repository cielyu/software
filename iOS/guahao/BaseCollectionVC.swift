//
//  BaseCollectionVC.swift
//  guahao
//
//  Created by Jeff Wong on 15/11/4.
//  Copyright © 2015年 Jeff. All rights reserved.
//

import UIKit

class BaseCollectionVC: UICollectionViewController {
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let sizeWidth = (UIScreen.mainScreen().bounds.width - 40) / 3
        layout.itemSize = CGSizeMake(sizeWidth, sizeWidth)
        layout.sectionInset = UIEdgeInsetsMake(5, 10, 5, 10)
        
        super.init(collectionViewLayout: layout)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        setupSubviews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**
     重写时必须调用父级setupSubviews方法，否则需要设置collectionView的layout
     */
    func setupSubviews() {
        collectionView?.backgroundColor = UIColor.whiteColor()
        collectionView?.alwaysBounceVertical = true
    }
}
