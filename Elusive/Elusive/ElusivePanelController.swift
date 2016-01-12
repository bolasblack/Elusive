//
//  ElusivePanelController.swift
//  Elusive
//
//  Created by c4605 on 4/9/15.
//  Copyright (c) 2015 c4605. All rights reserved.
//

import AppKit

class ElusivePanelController : NSWindowController {
    
    var panel: NSPanel! {
        get {
            return (self.window as! NSPanel)
        }
    }
    
    var webViewController: WebViewController {
        get {
            return self.window?.contentViewController as! WebViewController
        }
    }

    override func windowDidLoad() {
        panel.floatingPanel = true
        setFloatOverFullScreenApps()
    }
    
    func setFloatOverFullScreenApps() {
        if NSUserDefaults.standardUserDefaults().boolForKey(UserSetting.DisabledFullScreenFloat.userDefaultsKey) {
            panel.collectionBehavior = [.MoveToActiveSpace, .FullScreenAuxiliary]
        } else {
            panel.collectionBehavior = [.CanJoinAllSpaces, .FullScreenAuxiliary]
        }
    }
    
    //MARK: IBActions
    
    @IBAction func openLocationPress(sender: AnyObject) {
        didRequestLocation()
    }
    
    @IBAction func openFilePress(sender: AnyObject) {
        didRequestFile()
    }
    
    @IBAction func floatOverFullScreenAppsToggled(sender: NSMenuItem) {
        sender.state = (sender.state == NSOnState) ? NSOffState : NSOnState
        NSUserDefaults.standardUserDefaults().setBool((sender.state == NSOffState), forKey: UserSetting.DisabledFullScreenFloat.userDefaultsKey)
        setFloatOverFullScreenApps()
    }
    
    // MARK: Actual functionality
    
    func didRequestFile() {
        let open = NSOpenPanel()
        open.allowsMultipleSelection = false
        open.canChooseFiles = true
        open.canChooseDirectories = false
        
        if open.runModal() == NSModalResponseOK {
            if let url = open.URL {
                webViewController.loadURL(url)
            }
        }
    }
    
    
    func didRequestLocation() {
        let alert = NSAlert()
        alert.alertStyle = NSAlertStyle.InformationalAlertStyle
        alert.messageText = "Enter Destination URL"
        
        let urlField = NSTextField()
        urlField.frame = NSRect(x: 0, y: 0, width: 300, height: 20)
        urlField.lineBreakMode = NSLineBreakMode.ByTruncatingHead
        urlField.usesSingleLineMode = true
        
        alert.accessoryView = urlField
        alert.addButtonWithTitle("Load")
        alert.addButtonWithTitle("Cancel")
        alert.beginSheetModalForWindow(self.window!, completionHandler: { response in
            if response == NSAlertFirstButtonReturn {
                // Load
                let text = (alert.accessoryView as! NSTextField).stringValue
                self.webViewController.loadAlmostURL(text)
            }
        })
    }
}