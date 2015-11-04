//
//  StructModel.swift
//  guahao
//
//  Created by Jeff Wong on 15/11/4.
//  Copyright © 2015年 Jeff. All rights reserved.
//

import UIKit

/**
 用于储存医院、类别、医生名字的结构体
 */
struct Category {
    var name: String
    
    /**
     解析医院名，如果为nil，则返回的结构体中的变量为空字符串
     */
    static func serialization(name: String?) -> Category {
        if let name = name {
            return Category(name: name)
        }else {
            return Category(name: "")
        }
    }
}
