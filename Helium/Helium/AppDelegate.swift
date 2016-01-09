//
//  AppDelegate.swift
//  Helium
//
//  Created by Jaden Geller on 4/9/15.
//  Copyright (c) 2015 Jaden Geller. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {

    @IBOutlet weak var magicURLMenu: NSMenuItem!
    @IBOutlet weak var fullScreenFloatMenu: NSMenuItem!
    
    let urlscheme = "helium"

    func applicationWillFinishLaunching(notification: NSNotification) {
        NSLog("app initialized")
        NSAppleEventManager.sharedAppleEventManager().setEventHandler(
            self,
            andSelector: "handleURLEvent:withReply:",
            forEventClass: AEEventClass(kInternetEventClass),
            andEventID: AEEventID(kAEGetURL)
        )
    }

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        magicURLMenu.state = NSUserDefaults.standardUserDefaults().boolForKey(UserSetting.DisabledMagicURLs.userDefaultsKey) ? NSOffState : NSOnState
        
        fullScreenFloatMenu.state = NSUserDefaults.standardUserDefaults().boolForKey(UserSetting.DisabledFullScreenFloat.userDefaultsKey) ? NSOffState : NSOnState
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    
    @IBAction func magicURLRedirectToggled(sender: NSMenuItem) {
        sender.state = (sender.state == NSOnState) ? NSOffState : NSOnState
        NSUserDefaults.standardUserDefaults().setBool((sender.state == NSOffState), forKey: UserSetting.DisabledMagicURLs.userDefaultsKey)
    }
    
    // MARK: - handleURLEvent
    
    // Called when the App opened via URL.
    //   helium://?x=10&y=20&width=200&height=180&url=https://google.com
    func handleURLEvent(event: NSAppleEventDescriptor, withReply reply: NSAppleEventDescriptor) {
        if let urlString: String? = event.paramDescriptorForKeyword(AEKeyword(keyDirectObject))?.stringValue {
            if let url: NSURL? = NSURL(string: urlString!) {
                NSLog("url scheme \(url?.absoluteString)")
                NSNotificationCenter.defaultCenter().postNotificationName("HeliumLoadURL", object: url)
            }else {
                NSLog("url scheme no valid URL to handle")
            }
        }
    }
}

