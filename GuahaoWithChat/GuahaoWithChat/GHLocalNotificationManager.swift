//
//  GHLocalNotificationManager.swift
//  GuahaoWithChat
//
//  Created by Jeff Wong on 15/11/8.
//  Copyright © 2015年 Jeff. All rights reserved.
//

import Foundation

class GHLocalNotificationManager {
    /**
     单例
     */
    class var defaultManager: GHLocalNotificationManager {
        struct shared {
            static let instance = GHLocalNotificationManager()
        }
        return shared.instance
    }
    

}