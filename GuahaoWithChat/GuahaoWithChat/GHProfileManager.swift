//
//  GHProfileManager.swift
//  GuahaoWithChat
//
//  Created by Jeff Wong on 15/11/7.
//  Copyright © 2015年 Jeff. All rights reserved.
//

import Foundation

/**
 用于管理用户资料的类
 */
class GHProfileManager {
    /**
     单例
     - Returns: 默认的Manager实例
     */
    class var defaultManager: GHProfileManager {
        struct shared {
            static let instance = GHProfileManager()
        }
        return shared.instance
    }
    
    /**
     取得储存用户资料的文件路径
     - Returns: 用户资料路径
     */
    private var profilePath: String {
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        return path + "/UserProfile.plist"
    }
    
    private var profileDict: [String: String]? {
        if let dict = NSDictionary(contentsOfFile: profilePath) as? [String: String] {
            return dict
        }else {
            return nil
        }
    }
    
    /**
     将制定keys和values写入profile文件中
     - Parameter keys: 键
     - Parameter values: 值
     */
    func saveProfile(keys: [String], values: [String?]) {
        let _values = values.flatMap { $0 == nil ? "" : $0! }
        
        var profile: [String: String]
        if let profileDict = profileDict {
            profile = profileDict
        }else {
            profile = [String: String]()
        }
        
        for i in 0..<keys.count {
            profile[keys[i]] = _values[i]
        }
        
        NSDictionary(dictionary: profile).writeToFile(profilePath, atomically: true)
    }
    
    /**
     得到指定资料
     - Parameter key: username, tel, addr, mail等等
     - Returns: 返回指定资料
     */
    func getProfile(key: String) -> String {
        guard let profile = profileDict else {
            return ""
        }
        if let value = profile[key] {
            return value
        }else {
            return ""
        }
    }
}