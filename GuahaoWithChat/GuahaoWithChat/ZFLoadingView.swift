//
//  ZFLoadingView.swift
//  ChatDemo-UI2.0
//
//  Created by Jeff Wong on 15/8/16.
//  Copyright (c) 2015年 Jeff Wong. All rights reserved.
//

import UIKit

class ZFLoadingView: NSObject {
    private var backView: UIView!
    private var centerView: UIView
    private var indicatorView: UIActivityIndicatorView
    private var tipsLabel: UILabel?
    var isLoading = false
    
    override init() {
        //用来放菊花的放在中间的黑色View
        centerView = UIView(frame: CGRectMake(0, 0, 100, 100))
        centerView.layer.cornerRadius = 8
        centerView.backgroundColor = UIColor.blackColor()
        centerView.clipsToBounds = true
        //菊花
        indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        indicatorView.center = CGPointMake(centerView.frame.width / 2, centerView.frame.height / 2)
        
        centerView.addSubview(indicatorView)
    }
    
    func show(InView view: UIView?, withTips text: String?) {
        guard !isLoading else {
            return
        }
        if let view = view {
            isLoading = true
            if NSThread.isMainThread() {
                showInMainThread(view, text: text)
            }else {
                dispatch_async(dispatch_get_main_queue()) {
                    self.showInMainThread(view, text: text)
                }
            }
        }
    }
    
    private func showInMainThread(view: UIView, text: String?) {
        backView = UIView(frame: view.bounds)
        backView.alpha = 0
        backView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        //提示信息
        if let text = text {
            let font = UIFont.boldSystemFontOfSize(17)
            let textWidth = text.widthForDisplaying(font)
            
            var displayWidth: CGFloat
            let screenWidth = UIScreen.mainScreen().bounds.width
            if textWidth > screenWidth {
                displayWidth = screenWidth - 20
            }else if textWidth > 60 && textWidth < screenWidth {
                displayWidth = textWidth + 30
            }else {
                displayWidth = 100
            }
            //修正centerView的宽度，和菊花的位置
            centerView.frame.size.width = displayWidth
            indicatorView.center = CGPointMake(centerView.frame.width / 2, centerView.frame.height / 2 - 12)
            if tipsLabel == nil {
                tipsLabel = UILabel(frame: CGRectMake(0, 0, 0, 21))
                tipsLabel?.textAlignment = .Center
                tipsLabel?.font = font
                tipsLabel?.textColor = UIColor.whiteColor()
                centerView.addSubview(tipsLabel!)
            }
            tipsLabel?.frame.size.width = displayWidth
            tipsLabel?.center = CGPointMake(
                centerView.frame.width / 2,
                centerView.frame.height - 26)
            tipsLabel?.text = text
            
        }
        centerView.center = CGPointMake(backView.frame.width / 2, backView.frame.height / 2)
        if centerView.superview == nil {
            backView.addSubview(centerView)
        }
        
        indicatorView.startAnimating()
        view.addSubview(backView)
        centerView.transform = CGAffineTransformMakeScale(1.2, 1.2)
        UIView.animateWithDuration(0.2) {
            self.centerView.transform = CGAffineTransformMakeScale(1, 1)
            self.backView.alpha = 1
        }
    }
    
    func hide() {
        guard isLoading else {
            return
        }
        dispatch_async(dispatch_get_main_queue()) {
            if self.backView.superview != nil {
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.centerView.transform = CGAffineTransformMakeScale(0.8, 0.8)
                    self.backView.alpha = 0
                    }, completion: { (finish) -> Void in
                        self.indicatorView.stopAnimating()
                        self.backView.removeFromSuperview()
                        self.centerView.transform = CGAffineTransformMakeScale(1, 1)
                        self.isLoading = false
                })
            }
        }
    }
}
