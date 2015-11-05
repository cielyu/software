//
//  MessageToast.swift
//  ChatDemo-UI2.0
//
//  Created by Jeff Wong on 15/7/24.
//  Copyright (c) 2015年 Jeff Wong. All rights reserved.
//

import UIKit

class MessageToast: NSObject {
    typealias AnimationFinishBlock = () -> ()
    class func toast(view: UIView?, message: String?, keyBoardHeight: CGFloat, finishBlock: AnimationFinishBlock?) {
        guard let _view = view, msg = message else {
            return
        }
        dispatch_async(dispatch_get_main_queue()) {
            var backView: UIView!
            var label: UILabel!
            
            let font = UIFont(name: "Helvetica-Bold", size: 17)!
            let widthOfString = msg.widthForDisplaying(font)
            let maxWidth = _view.frame.width - 30
            var displayWidth: CGFloat
            if widthOfString > maxWidth {
                displayWidth = maxWidth
            }else {
                displayWidth = widthOfString
            }
            
            backView = UIView(frame: CGRectMake(0, 0, displayWidth + 20, 31))
            backView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
            backView.center = CGPointMake(_view.frame.width / 2, _view.frame.height - keyBoardHeight - 41)
            backView.layer.cornerRadius = 5
            backView.alpha = 0
            
            label = UILabel(frame: CGRectMake(0, 0, displayWidth, 21))
            label.center = CGPointMake(backView.frame.width / 2, backView.frame.height / 2)
            label.font = font
            label.backgroundColor = UIColor.clearColor()
            label.textColor = UIColor.whiteColor()
            label.textAlignment = .Center
            label.text = msg
            
            backView.addSubview(label)
        
            //show
            _view.addSubview(backView)
            UIView.animateWithDuration(
                0.3,
                animations: ({
                    backView.alpha = 1
                }),
                completion: ({(finish) -> Void in
                    UIView.animateWithDuration(
                        0.35,
                        delay: 1.3,
                        options: [],
                        animations: ({
                            backView.alpha = 0
                            backView.transform = CGAffineTransformMakeScale(0.5, 0.5)
                        }),
                        completion: ({(finish) -> Void in
                            backView.removeFromSuperview()
                            finishBlock?()
                        }))
                    }
                )
            )
        }
    }
}
