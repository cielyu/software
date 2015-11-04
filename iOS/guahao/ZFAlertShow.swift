//
//  ZFAlertShow.swift
//  guahao
//
//  Created by Jeff Wong on 15/10/15.
//  Copyright © 2015年 Jeff. All rights reserved.
//

import UIKit

class ZFAlertShow {
    class var sharedInstance: ZFAlertShow {
        struct shared {
            static let instance = ZFAlertShow()
        }
        return shared.instance
    }
    func showAlert(title: String?, message: String?, inViewController viewController: UIViewController?) {
        guard let vc = viewController, msg = message else {
            return
        }
        if NSThread.isMainThread() {
            show(title, message: msg, vc: vc)
        }else {
            dispatch_async(dispatch_get_main_queue()) {
                self.show(title, message: msg, vc: vc)
            }
        }
    }
    
    private func show(title: String?, message: String, vc: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "确定", style: .Cancel, handler: nil)
        alert.addAction(cancelAction)
        vc.presentViewController(alert, animated: true, completion: nil)
    }
}