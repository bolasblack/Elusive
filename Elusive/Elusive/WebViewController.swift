//
//  ViewController.swift
//  Elusive
//
//  Created by c4605 on 4/9/15.
//  Copyright (c) 2015 c4605. All rights reserved.
//

import Cocoa
import WebKit

class WebViewController: NSViewController, WKNavigationDelegate {
    var webView = CustomWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addTrackingRect(view.bounds, owner: self, userData: nil, assumeInside: false)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadURLObject:", name: "loadURL", object: nil)

        // Layout webview
        view.addSubview(webView)

        webView.frame = view.bounds
        webView.autoresizingMask = [NSAutoresizingMaskOptions.ViewHeightSizable, NSAutoresizingMaskOptions.ViewWidthSizable]
        
        // Allow plug-ins such as silverlight
        webView.configuration.preferences.plugInsEnabled = true
        
        // Custom user agent string for Netflix HTML5 support
        webView._customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_4) AppleWebKit/600.7.12 (KHTML, like Gecko) Version/8.0.7 Safari/600.7.12"
        
        // Setup magic URLs
        webView.navigationDelegate = self
        
        // Allow zooming
        webView.allowsMagnification = true
        
        // Alow back and forth
        webView.allowsBackForwardNavigationGestures = true
        
        clear()
    }
    
    override func validateMenuItem(menuItem: NSMenuItem) -> Bool {
        switch menuItem.title {
        case "Back":
            return webView.canGoBack
        case "Forward":
            return webView.canGoForward
        default:
            return true
        }
    }

    override var representedObject: AnyObject? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    func loadAlmostURL(var text: String) {
        if !(text.lowercaseString.hasPrefix("http://") || text.lowercaseString.hasPrefix("https://")) {
            text = "http://" + text
        }
        
        if let url = NSURL(string: text) {
            loadURL(url)
        }
    }
    
    func loadURL(url:NSURL) {
        webView.loadRequest(NSURLRequest(URL: url))
    }
    
    func clear() {
        loadURL(NSURL(string: "https://cdn.rawgit.com/JadenGeller/Helium/master/helium_start.html")!)
    }
    
    // MARK: Events
    
    func loadURLObject(notification : NSNotification) {
        if let url = notification.userInfo!["url"] as? NSURL {
            if let target = url.queryComponents["url"] {
                NSLog("urlscheme open url \(target!)")
                loadAlmostURL(target!)
            }
            var windowFrame = self.webView.window!.frame
            if let x = parseQueryComponents(url, paramName: "x") {
                windowFrame.origin.x = CGFloat(x)
            }
            if let y = parseQueryComponents(url, paramName: "y") {
                windowFrame.origin.y = CGFloat(y)
            }
            if let width = parseQueryComponents(url, paramName: "width") {
                windowFrame.size.width = CGFloat(width)
            }
            if let height = parseQueryComponents(url, paramName: "height") {
                windowFrame.size.height = CGFloat(height)
            }
            NSLog("urlscheme set window frame origin \(windowFrame)")
            self.webView.window?.setFrame(windowFrame, display: true)
        }
    }
    
    func parseQueryComponents(url: NSURL, paramName: String) -> Float? {
        if let value = url.queryComponents[paramName] {
            return Float(value!)
        } else {
            return nil
        }
    }
    
    // MARK: IBAction
    
    @IBAction func backPress(sender: AnyObject) {
        webView.goBack()
    }
    @IBAction func forwardPress(sender: AnyObject) {
        webView.goForward()
    }
    @IBAction func reloadPress(sender: AnyObject) {
        webView.reload()
    }
    @IBAction func clearPress(sender: AnyObject) {
        clear()
    }
    @IBAction func resetZoomLevel(sender: AnyObject) {
        webView.magnification = 1
    }
    @IBAction func zoomIn(sender: AnyObject) {
        webView.magnification += 0.1
    }
    @IBAction func zoomOut(sender: AnyObject) {
        webView.magnification -= 0.1
    }
}
