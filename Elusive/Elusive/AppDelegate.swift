//
//  AppDelegate.swift
//  Elusive
//
//  Created by c4605 on 4/9/15.
//  Copyright (c) 2015 c4605. All rights reserved.
//

import Cocoa
import Carbon

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {

    @IBOutlet weak var fullScreenFloatMenu: NSMenuItem!
    var statusBarItem: NSStatusItem!
    
    let urlscheme = "elusive"

    func applicationWillFinishLaunching(notification: NSNotification) {
        NSLog("app initialized")
        
        NSAppleEventManager.sharedAppleEventManager().setEventHandler(
            self,
            andSelector: "handleURLEvent:withReply:",
            forEventClass: AEEventClass(kInternetEventClass),
            andEventID: AEEventID(kAEGetURL)
        )
        
        self.listenGlobalKeyDownEvents()
        self.adoptStatusBarItem()
    }

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        fullScreenFloatMenu.state = NSUserDefaults.standardUserDefaults().boolForKey(UserSetting.DisabledFullScreenFloat.userDefaultsKey) ? NSOffState : NSOnState
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    func adoptStatusBarItem() {
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Quit", action: Selector("closeSelf"), keyEquivalent: ""))
        
        let statusBar = NSStatusBar.systemStatusBar()
        statusBarItem = statusBar.statusItemWithLength(NSSquareStatusItemLength)
        statusBarItem.image = NSImage(named: "statusbar-icon")
        statusBarItem.image?.template = true
        statusBarItem.highlightMode = true
        statusBarItem.menu = menu
    }

    func listenGlobalKeyDownEvents() {
        let options = NSDictionary(object: kCFBooleanTrue, forKey: kAXTrustedCheckOptionPrompt.takeUnretainedValue() as NSString) as CFDictionaryRef
        let trusted = AXIsProcessTrustedWithOptions(options)
        if (trusted) {
            NSLog("trusted as accessibility client")
            NSEvent.addGlobalMonitorForEventsMatchingMask(.KeyDownMask) { event in
                // keyCode table:
                //   /System/Library/Frameworks/Carbon.framework/Versions/A/Frameworks/HIToolbox.framework/Versions/A/Headers/Events.h
                if event.keyCode == UInt16(kVK_Escape) {
                    NSLog("keydown globally! ESC")
                    self.closeSelf()
                } else {
                    NSLog("keydown globally! \(event.keyCode)")
                }
            }
        } else {
            NSLog("haven't trusted as accessibility client")
            self.closeSelf()
        }
    }
    
    func closeSelf() {
        NSApplication.sharedApplication().terminate(self)
    }
    
    // MARK: handleURLEvent
    
    // Called when the App opened via URL.
    //   elusive://?x=10&y=20&width=200&height=180&url=https://google.com
    func handleURLEvent(event: NSAppleEventDescriptor, withReply reply: NSAppleEventDescriptor) {
        if let urlString: String? = event.paramDescriptorForKeyword(AEKeyword(keyDirectObject))?.stringValue {
            if let url = NSURL(string: urlString!) {
                NSLog("url scheme \(url.absoluteString)")
                NSNotificationCenter.defaultCenter().postNotificationName("loadURL", object: nil, userInfo: ["url": url])
            }else {
                NSLog("url scheme no valid URL to handle")
            }
        }
    }
}

