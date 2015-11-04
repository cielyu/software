//
//  ViewController.swift
//  TestSlideView
//
//  Created by Jeff Wong on 15/10/21.
//  Copyright © 2015年 Jeff. All rights reserved.
//

import UIKit

class ZFSlideViewController: UIViewController, UIGestureRecognizerDelegate {
    var leftVC: UIViewController!
    var middleVC: UIViewController!
    
    private var midMaskView: UIView?
    
    private var panGes: UIScreenEdgePanGestureRecognizer?
    private var midTapGes: UITapGestureRecognizer?
    private var midPanGes: UIPanGestureRecognizer?
    
    var leftViewWidth: CGFloat = 200
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        
        setupSubviews()
        setupGesture()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupSubviews() {
        midView.layer.shadowColor = UIColor.blackColor().CGColor
        midView.layer.shadowOpacity = 0.7
        midView.layer.shadowPath = UIBezierPath(rect: midView.bounds).CGPath
        midView.layer.shadowOffset = CGSizeMake(-3, 0)
        
        view.addSubview(leftView)
        view.addSubview(midView)
    }
    
    func setupGesture() {
        if panGes == nil {
            panGes = UIScreenEdgePanGestureRecognizer(target: self, action: Selector("edgePanRespond:"))
            panGes?.edges = UIRectEdge.Left
        }
        view.addGestureRecognizer(panGes!)
        
    }
    
    // MARK: 边缘滑动回调
    func edgePanRespond(gesture: UIScreenEdgePanGestureRecognizer) {
        if gesture.numberOfTouches() > 0 {
            let location = gesture.locationOfTouch(0, inView: gesture.view)
            let x = location.x
            if x <= leftViewWidth {
                midView.frame.origin.x = x
            }
        }else {
            let curX = midView.frame.origin.x
            if curX <= leftViewWidth * 2/3 {
                hideLeftView()
            }else {
                showLeftView()
            }
        }
    }
    // MARK: LeftView显示出来后，MidView滑动增加手势
    func panGestureRespond(gesture: UIPanGestureRecognizer) {
        guard midView.frame.origin.x >= 0 else {
            return
        }
        if gesture.numberOfTouches() > 0 {
            let location = gesture.translationInView(gesture.view)
            let x = location.x
            if x <= 0 && x >= -leftViewWidth {
                midView.frame.origin.x = leftViewWidth + x
            }
        }else {
            let curX = midView.frame.origin.x
            if curX <= leftViewWidth * 2/3 {
                hideLeftView()
            }else {
                showLeftView()
            }
        }
    }
    
    // MARK: LeftView Animation
    func showLeftView() {
        UIView.animateWithDuration(
            0.3,
            animations: { () -> Void in
                self.midView.frame.origin.x = self.leftViewWidth
            },
            completion: { (finish) -> Void in
                self.leftViewDidShow()
        })
    }
    func hideLeftView() {
        UIView.animateWithDuration(
            0.3,
            animations: { () -> Void in
                self.midView.frame.origin.x = 0
            },
            completion: { (finish) -> Void in
                self.leftViewDidHide()
        })
    }
    
    private func leftViewDidShow() {
        panGes?.enabled = false
        addMiddleTapGesture()
    }
    
    private func leftViewDidHide() {
        removeMidViewGesture()
        panGes?.enabled = true
    }
    
    // MARK: 为MidView增加点击、滑动手势
    private func addMiddleTapGesture() {
        if midTapGes == nil {
            midTapGes = UITapGestureRecognizer(target: self, action: Selector("hideLeftView"))
            midTapGes?.enabled = false
        }
        if midPanGes == nil {
            midPanGes = UIPanGestureRecognizer(
                target: self,
                action: Selector("panGestureRespond:"))
            midPanGes?.enabled = false
        }
        if midMaskView == nil {
            midMaskView = UIView(frame: midView.bounds)
            midMaskView?.backgroundColor = UIColor.clearColor()
            midMaskView?.addGestureRecognizer(midTapGes!)
            midMaskView?.addGestureRecognizer(midPanGes!)
        }
        midTapGes?.enabled = true
        midPanGes?.enabled = true
        midView.addSubview(midMaskView!)
    }
    
    // MARK: 移除MidView手势
    private func removeMidViewGesture() {
        midTapGes?.enabled = false
        midPanGes?.enabled = false
        midMaskView?.removeFromSuperview()
    }
    
    
    
    private var midView: UIView {
        return middleVC.view
    }
    private var leftView: UIView {
        return leftVC.view
    }
}

