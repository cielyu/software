//
//  ZFHttpRequest.swift
//  guahao
//
//  Created by Jeff Wong on 15/10/15.
//  Copyright © 2015年 Jeff. All rights reserved.
//

import Foundation

enum ZFHttpRequestError: Int {
    case NSURLError = 1
    case HttpBodyError
    case ReturnNSDataError
    case JSONSerializationError
}

class ZFHttpRequest {
    typealias successBlock = (AnyObject) -> ()
    typealias failureBlock = (ZFHttpRequestError) -> ()
    
    // 1: nsurl, 2: bodyString, 3:return nsdata
    class func postRequest(toUrl url: String, withParameter param: [String: String], success: successBlock?, failure: failureBlock?) {
        let _nsurl = NSURL(string: url)
        guard let nsurl = _nsurl else {
            failure?(.NSURLError)
            return
        }
        let paramArr = NSMutableArray()
        for key in param.keys {
            let str = "\(key)=" + "\(param[key]!)"
            paramArr.addObject(str)
        }
        let bodyString = paramArr.componentsJoinedByString("&") as String
        let utf8Body = bodyString.dataUsingEncoding(NSUTF8StringEncoding)
        
        guard let body = utf8Body else {
            failure?(.HttpBodyError)
            return
        }
        
        let post = NSMutableURLRequest(
            URL: nsurl,
            cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy,
            timeoutInterval: 15)
        post.HTTPMethod = "POST"
        post.HTTPBody = body
        
        NSURLSession.sharedSession().dataTaskWithRequest(post) { (nsdata, response, error) -> Void in
            if error != nil {
                failure?(.ReturnNSDataError)
            }else {
                if let data = nsdata {
                    do {
                        let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
                        success?(json)
                    }catch let error as NSError {
                        print(error)
                        failure?(.JSONSerializationError)
                    }
                }else {
                    failure?(.ReturnNSDataError)
                }
            }
        }.resume()
    }
}