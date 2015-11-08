//
//  ZFFloat+Float.swift
//  GuahaoWithChat
//
//  Created by Jeff Wong on 15/11/8.
//  Copyright © 2015年 Jeff. All rights reserved.
//

import Foundation

extension Float {
    /**
     根据时间戳转换为年月日
     - Returns: 中文年月日
     */
    var chineseDateFormat: String {
        let date = NSDate(timeIntervalSince1970: Double(self))
        let formatter = NSDateFormatter()
        formatter.dateStyle = .LongStyle
        formatter.locale = NSLocale(localeIdentifier: "zh")
        return formatter.stringFromDate(date)
    }
}
