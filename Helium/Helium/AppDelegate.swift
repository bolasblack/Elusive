//
//  AppDelegate.swift
//  Helium
//
//  Created by Jaden Geller on 4/9/15.
//  Copyright (c) 2015 Jaden Geller. All rights reserved.
//

import Cocoa
import Carbon

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

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        magicURLMenu.state = NSUserDefaults.standardUserDefaults().boolForKey(UserSetting.DisabledMagicURLs.userDefaultsKey) ? NSOffState : NSOnState
        
        fullScreenFloatMenu.state = NSUserDefaults.standardUserDefaults().boolForKey(UserSetting.DisabledFullScreenFloat.userDefaultsKey) ? NSOffState : NSOnState
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    func closeSelf() {
        NSApplication.sharedApplication().terminate(self)
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
            if let url = NSURL(string: urlString!) {
                NSLog("url scheme \(url.absoluteString)")
                NSNotificationCenter.defaultCenter().postNotificationName("loadURL", object: nil, userInfo: ["url": url])
            }else {
                NSLog("url scheme no valid URL to handle")
            }
        }
    }
}

