//
//  Test.h
//  Elusive
//
//  Created by c4605 on 4/13/15.
//  Copyright (c) 2015 c4605. All rights reserved.
//

@import WebKit;

@interface WKWebView (Privates)

@property (copy, setter=_setCustomUserAgent:) NSString *_customUserAgent;

@property (nonatomic, readonly) NSString *_userAgent;

@end