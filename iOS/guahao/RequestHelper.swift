//
//  RequestHelper.swift
//  guahao
//
//  Created by Jeff Wong on 15/11/4.
//  Copyright © 2015年 Jeff. All rights reserved.
//

import UIKit

class RequestHelper {
    
    class var sharedInstance: RequestHelper {
        struct shared {
            static let instance = RequestHelper()
        }
        return shared.instance
    }
    
    func getPostURL(type: MainVCType) -> String {
        switch type {
        case .Hospital:
            return "http://192.168.137.1:8000/getlist/"
        case .Department:
            return "http://192.168.137.1:8000/getdepartment/"
        case .Doctor:
            return "http://192.168.137.1:8000/searchdoctor/"
        }
    }
    
    func getPostParam(type: MainVCType, hospital: String?, department: String?) -> ([String: String]?, Bool) {
        switch type {
        case .Hospital:
            return (nil, true)
        case .Department:
            if let hospital = hospital {
                return (["hospital": hospital], true)
            }else {
                return (nil, false)
            }
        case .Doctor:
            if let hospital = hospital, let department = department {
                return (["hospital": hospital, "department": department], true)
            }else {
                return (nil, false)
            }
        }
    }
}
