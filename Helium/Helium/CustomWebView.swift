//
//  CustomWebView.swift
//  Helium
//
//  Created by c4605 on 16/1/5.
//  Copyright © 2016年 Jaden Geller. All rights reserved.
//

import Cocoa
import WebKit

// Inject JavaScript
/*
(function() {

var initialPosition = null;
var getMousePosiiton = function getMousePosiiton(event) {
  return {
    x: event.clientX,
    y: event.clientY
  }
};
window.document.addEventListener('mousedown', function(event) {
  initialPosition = getMousePosiiton(event)
});
window.document.addEventListener('mouseup', function(event) {
  initialPosition = null
});
window.document.addEventListener('mousemove', function(event) {
  if (initialPosition) {
    var currentPosition = getMousePosiiton(event);
    window.webkit.messageHandlers.mouseDrag.postMessage({
      x: currentPosition.x - initialPosition.x,
      y: initialPosition.y - currentPosition.y
    })
  }
});

var style = document.createElement('style');
style.textContent = '* { -webkit-user-select: none; }';
document.querySelector('body').appendChild(style);

})();
*/
// Can be compressed by http://www.cleancss.com/javascript-minify/
let injectedJavaScript = "(function(){var initialPosition=null;var getMousePosiiton=function getMousePosiiton(event){return{x:event.clientX,y:event.clientY}};window.document.addEventListener('mousedown',function(event){initialPosition=getMousePosiiton(event)});window.document.addEventListener('mouseup',function(event){initialPosition=null});window.document.addEventListener('mousemove',function(event){if(initialPosition){var currentPosition=getMousePosiiton(event);window.webkit.messageHandlers.mouseDrag.postMessage({x:currentPosition.x-initialPosition.x,y:initialPosition.y-currentPosition.y})}});var style=document.createElement('style');style.textContent='* { -webkit-user-select: none; }';document.querySelector('body').appendChild(style)})();"
let userScript = WKUserScript(source: injectedJavaScript, injectionTime: .AtDocumentStart, forMainFrameOnly: false)


private enum ScriptMessageType: String {
    case mouseDrag = "mouseDrag"
}

class CustomWebView: WKWebView, WKScriptMessageHandler {
    
    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
        
        self.configuration.userContentController.addScriptMessageHandler(self, name: ScriptMessageType.mouseDrag.rawValue)
        self.configuration.userContentController.addUserScript(userScript)
        self.configuration.preferences.setValue(true, forKey: "developerExtrasEnabled")
    }
    
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        if let _ = ScriptMessageType(rawValue: message.name) {
            let frameOffset: NSDictionary = message.body as! NSDictionary
            let screenFrame = NSScreen.mainScreen()?.frame
            let windowFrame = self.window!.frame
            var newOrigin = NSPoint(
                x: windowFrame.origin.x + CGFloat(frameOffset["x"] as! Float),
                y: windowFrame.origin.y + CGFloat(frameOffset["y"] as! Float)
            )
            if ((newOrigin.y + windowFrame.size.height) > (screenFrame!.origin.y + screenFrame!.size.height)) {
                newOrigin.y = screenFrame!.origin.y + (screenFrame!.size.height - windowFrame.size.height);
            }
            self.window?.setFrameOrigin(newOrigin)
        }
    }
}