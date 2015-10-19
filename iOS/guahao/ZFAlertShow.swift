//
//  ZFAlertShow.swift
//  guahao
//
//  Created by Jeff Wong on 15/10/15.
//  Copyright © 2015年 Jeff. All rights reserved.
//

import UIKit

private let shared = ZFAlertShow()

class ZFAlertShow {
    class var sharedInstance: ZFAlertShow {
        return shared
    }
    func showAlert(title: String?, message: String?, inViewController viewController: UIViewController?) {
        guard let vc = viewController, msg = message else {
            return
        }
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        vc.presentViewController(alert, animated: true, completion: nil)
    }
}