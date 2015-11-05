//
//  Helper.swift
//  guahao
//
//  Created by Jeff Wong on 15/11/4.
//  Copyright © 2015年 Jeff. All rights reserved.
//

import Foundation

class Helper {
    class func isEmailAddress(emailAddr: String?) -> Bool {
        guard let email = emailAddr else {
            return false
        }
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let predicate = NSPredicate(format: "SELF MATCHES%@", regex)
        return predicate.evaluateWithObject(email)
    }
}

/**
 在主线程中异步运行
 
 - Parameter block: 要执行的代码块
 */
func runAsyncOnMainThread(block: () -> ()) {
    if NSThread.isMainThread() {
        block()
    }else {
        dispatch_async(dispatch_get_main_queue()) {
            block()
        }
    }
}

func runSyncOnMainThread(block: () -> ()) {
    if NSThread.isMainThread() {
        block()
    }else {
        dispatch_sync(dispatch_get_main_queue()) {
            block()
        }
    }
}