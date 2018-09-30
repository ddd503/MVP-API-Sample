//
//  Error+Helper.swift
//  Model
//
//  Created by kawaharadai on 2018/09/30.
//  Copyright © 2018年 kawaharadai. All rights reserved.
//

extension Error {
    
    var ns: NSError {
        return (self as NSError)
    }
    
    /// タイムアウトかどうか
    var isTimeout: Bool {
        return ns.domain == NSURLErrorDomain && ns.code == NSURLErrorTimedOut
    }
    
    /// オフラインかどうか
    var isOffline: Bool {
        return ns.domain == NSURLErrorDomain && ns.code == NSURLErrorNotConnectedToInternet
    }
    
}
