//
//  GHCollectionViewCellBackgroudView.swift
//  guahao
//
//  Created by Jeff Wong on 15/10/12.
//  Copyright © 2015年 Jeff. All rights reserved.
//

import UIKit

class GHCollectionViewCellBackgroudView: UIView {
    private let bgColor: UIColor
    
    init(frame: CGRect, bgColor: UIColor) {
        self.bgColor = bgColor
        super.init(frame: frame)
        backgroundColor = UIColor.whiteColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()
        CGContextSaveGState(ctx)
        let path = UIBezierPath(roundedRect: rect, cornerRadius: 5)
        path.lineWidth = 0
        bgColor.setFill()
        path.fill()
        CGContextRestoreGState(ctx)
    }
}
