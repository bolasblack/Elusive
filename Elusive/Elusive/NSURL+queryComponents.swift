//
//  NSURL+queryComponents.swift
//  Elusive
//
//  Created by c4605 on 16/1/7.
//  Copyright © 2016年 c4605. All rights reserved.
//

import Foundation

extension NSURL {
    var queryComponents: [String: String?] {
        if self.query == nil { return [:] }
        let url = NSURLComponents(string: self.absoluteString)
        if url?.queryItems == nil { return [:] }
        return (url?.queryItems?.reduce([String: String?]()) { (var memo, queryObj) in
            memo[queryObj.name] = queryObj.value
            return memo
        })!
    }
}