//
//  RC4.swift
//
//  Created by Jeff Wong on 9/10/15.
//  Copyright (c) 2015 Jeff. All rights reserved.
//

import Foundation

protocol RC4 {
    func RC4_crypt(key: NSString) -> String
}

extension NSString: RC4 {
    func RC4_crypt(key: NSString) -> String {
        let s = NSMutableArray()
        let k = NSMutableArray()
        for i in 0..<256 {
            s.addObject(NSNumber(integer: i))
        }
        for i in 0..<256 {
            let item = key.characterAtIndex(i % key.length)
            k.addObject(NSNumber(unsignedShort: item))
        }
        
        var j = 0
        for i in 0..<255 {
            let _s = Int(s[i].intValue)
            let _k = Int(k[i].intValue)
            j = (j + _s + _k) % 256
            let tmp = s[i] as! NSNumber
            s.replaceObjectAtIndex(i, withObject: s[j])
            s.replaceObjectAtIndex(j, withObject: tmp)
        }
        
        var i = 0
        j = 0
        var result = ""
        for x in 0..<self.length {
            i = (i + 1) % 256
            
            let _s = Int(s[i].intValue)
            j = (j + _s) % 256
            
            let s_i = Int(s[i].intValue)
            let s_j = Int(s[j].intValue)
            
            let t = (s_i + s_j) % 256
            let y = UInt16(s[t].intValue)

            let ch = self.characterAtIndex(x) as unichar
            let ch_y = ch ^ y
            
            result.append(UnicodeScalar(ch_y))
        }
        return result
    }
}


