//
//  DataStruct.swift
//  GuahaoWithChat
//
//  Created by Jeff Wong on 15/11/5.
//  Copyright © 2015年 Jeff. All rights reserved.
//

import Foundation

/**
 储存好友请求的信息
 - username: 好友id
 - message: 请求原因
 */
struct RequestInfo {
    var username: String
    var message: String
}

/**
 用于储存医院、类别、医生名字的结构体
 - name: 类目名（医院、部门、医生）
 */
struct Category {
    var name: String
    
    /**
     解析医院名，如果为nil，则返回的结构体中的变量为空字符串
     
     - Parameter name: 类别名
     */
    static func serialization(name: String?) -> Category {
        if let name = name {
            return Category(name: name)
        }else {
            return Category(name: "")
        }
    }
}

/**
 储存用户资料
 - key: 资料名, username, tel, addr, mail等
 - value: 值
 */
struct Profile {
    var key: String
    var value: String
}

/**
 预约列表项
 */
struct BookItem {
    var doctor: String
    var date: String
    
    static func serialization(dict: [String: NSObject]) -> BookItem {
        var dateStr: String
        var doctorStr: String
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .ShortStyle
        dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 28800)
        dateFormatter.locale = NSLocale(localeIdentifier: "zh")
        
        if let doctor = dict["doctor"] as? String {
            doctorStr = doctor
        }else {
            doctorStr = ""
        }
        
        if let timeF = dict["time"] as? Float {
                let date = NSDate(timeIntervalSince1970: NSTimeInterval(timeF))
                dateStr = dateFormatter.stringFromDate(date)
        }else {
            dateStr = ""
        }
        
        return BookItem(
            doctor: doctorStr,
            date: dateStr)
    }
}