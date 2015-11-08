//
//  GHTimePickerView.swift
//  GuahaoWithChat
//
//  Created by Jeff Wong on 15/11/8.
//  Copyright © 2015年 Jeff. All rights reserved.
//

import UIKit

protocol GHTimePickerViewDelegate: NSObjectProtocol {
    func pickerDidCancel()
    func pickerDidConfirm(date: NSDate)
}

class GHTimePickerView: UIView {
    weak var delegate: GHTimePickerViewDelegate?
    
    private var timeStamp: Double
    
    let datePickerView = UIDatePicker()
    
    init(frame: CGRect, timeStamp: Float) {
        self.timeStamp = Double(timeStamp)
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        let centerView = UIView()
        let titleLabel = UILabel()
        let negativeBtn = UIButton()
        let positiveBtn = UIButton()
        let seperateLine1 = UIView()
        let seperateLine2 = UIView()
        
        centerView.backgroundColor = UIColor.whiteColor()
        centerView.layer.cornerRadius = 5
        centerView.layer.borderWidth = 0.5
        centerView.layer.borderColor = UIColor.grayColor().CGColor
        centerView.layer.shadowColor = UIColor.grayColor().CGColor
        centerView.layer.shadowOffset = CGSizeMake(0, 0)
        centerView.clipsToBounds = true
        
        titleLabel.text = "选择时间"
        titleLabel.textAlignment = .Center
        titleLabel.textColor = UIColor.blackColor()
        
        datePickerView.datePickerMode = .Time
        datePickerView.minimumDate = NSDate(timeIntervalSince1970: timeStamp)
        datePickerView.maximumDate = NSDate(timeIntervalSince1970: timeStamp + 86400)
        
        negativeBtn.setTitle("取消", forState: .Normal)
        negativeBtn.setTitleColor(UIColor.blueColor(), forState: .Normal)
        negativeBtn.addTarget(self, action: Selector("cancel"), forControlEvents: .TouchUpInside)
        
        positiveBtn.setTitle("确定", forState: .Normal)
        positiveBtn.setTitleColor(UIColor.blueColor(), forState: .Normal)
        positiveBtn.addTarget(self, action: Selector("confirm"), forControlEvents: .TouchUpInside)
        
        seperateLine1.backgroundColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
        seperateLine2.backgroundColor = seperateLine1.backgroundColor
        
        centerView.addSubview(titleLabel)
        centerView.addSubview(datePickerView)
        centerView.addSubview(negativeBtn)
        centerView.addSubview(positiveBtn)
        centerView.addSubview(seperateLine1)
        centerView.addSubview(seperateLine2)
        
        addSubview(centerView)
        
        let centerHeight = datePickerView.frame.height + 60
        let centerWidth = datePickerView.frame.width - 60
        
        centerView.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(centerHeight)
            make.width.equalTo(centerWidth)
            make.center.equalTo(self)
        }
        titleLabel.snp_makeConstraints { (make) -> Void in
            make.top.left.right.equalTo(centerView)
            make.height.equalTo(30)
        }
        datePickerView.snp_makeConstraints { (make) -> Void in
            make.left.right.equalTo(centerView)
            make.top.equalTo(titleLabel.snp_bottom)
            make.bottom.equalTo(seperateLine1.snp_top)
        }
        seperateLine1.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(datePickerView.snp_bottom)
            make.left.right.equalTo(centerView)
            make.bottom.equalTo(negativeBtn.snp_top)
            make.width.equalTo(centerView)
            make.height.equalTo(0.5)
        }
        negativeBtn.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(centerView)
            make.top.equalTo(seperateLine1.snp_bottom)
            make.right.equalTo(seperateLine2.snp_left)
            make.bottom.equalTo(centerView)
            make.width.equalTo(positiveBtn)
        }
        seperateLine2.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(seperateLine1.snp_bottom)
            make.left.equalTo(negativeBtn.snp_right)
            make.right.equalTo(positiveBtn.snp_left)
            make.bottom.equalTo(centerView)
            make.width.equalTo(0.5)
        }
        positiveBtn.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(seperateLine2.snp_right)
            make.top.equalTo(negativeBtn.snp_top)
            make.right.bottom.equalTo(centerView)
            make.width.equalTo(negativeBtn)
        }
    }
    
    // MARK: 以动画显示到指定view
    func show(view: UIView) {
        runAsyncOnMainThread {
            self.alpha = 0
            view.addSubview(self)
            UIView.animateWithDuration(0.2) {
                self.alpha = 1
            }
        }
    }
    
    
    // MARK: 隐藏
    func hide() {
        runAsyncOnMainThread {
            UIView.animateWithDuration(
                0.2,
                animations: { () -> Void in
                    self.alpha = 0
                },
                completion: { (_) -> Void in
                    self.removeFromSuperview()
            })
        }
    }
    
    // MARK: 取消按钮
    func cancel() {
        hide()
        delegate?.pickerDidCancel()
    }
    
    // MARK: 确认按钮
    func confirm() {
        hide()
        
        delegate?.pickerDidConfirm(datePickerView.date)
    }
}
