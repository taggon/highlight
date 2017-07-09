//
//  AppDelegate.swift
//  Highlight
//
//  Created by Taegon Kim on 07/01/2017.
//  Copyright © 2017 Taegon Kim. All rights reserved.
//

import Cocoa
import Magnet

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, UserSettings {

    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var styleMenu: NSMenu!
    @IBOutlet weak var highlightCodeItem: NSMenuItem!

    var statusItem: NSStatusItem = NSStatusBar.system().statusItem(withLength: NSSquareStatusItemLength)
    var highlighter: Highlighter = Highlighter()
    
    lazy var prefWindowController: NSWindowController! = {
        let storyboard = NSStoryboard(name: "Preferences", bundle: Bundle.main)
        let controller = storyboard.instantiateInitialController() as! PrefWindowController
        
        return controller
    }()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem.menu = statusMenu
        loadStatusImage(name: "StatusIcon")
        
        // set version
        statusMenu.items[0].title += " v\(version)"

        drawStyleMenu()
        
        // register hotkey
        if hotkey != nil {
            saveHotkey(keycomb: hotkey!)
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        HotKeyCenter.shared.unregisterAll()
    }
    
    func highlightCode() {
        DispatchQueue.global().async {
            // get text from the pasteboard
            let pboard = NSPasteboard.general()
            
            guard let code = pboard.string(forType: NSPasteboardTypeString) else { return }

            let attrStr = self.highlighter.paint(code: code)
            let data = try? attrStr.data(from: NSMakeRange(0, attrStr.length), documentAttributes: [NSDocumentTypeDocumentAttribute: NSRTFTextDocumentType])
            if data != nil {
                pboard.declareTypes([NSRTFPboardType], owner: self)
                pboard.setData(data!, forType: NSRTFPboardType)
            }
        }
    }
    
    func loadStatusImage(name: String) {
        if let button = statusItem.button {
            button.image = NSImage(named: name)
            button.image!.size = NSMakeSize(18.0, 18.0)
        }
    }
    
    func drawStyleMenu() {
        let styles = hlStyles.keys.enumerated().map { item in
            return item.element
        }
        
        for style in styles.sorted() {
            let item = NSMenuItem(title: style, action: #selector(setStyle), keyEquivalent: "")
            styleMenu.addItem(item)
            
            if highlighter.getStyle() == style {
                setStyle(sender: item)
            }
        }
    }
    
    func updateKeyEquivalentOfHighlightMenu() {
        guard let hotkey = self.hotkey else {
            highlightCodeItem.keyEquivalent = ""
            highlightCodeItem.keyEquivalentModifierMask = NSEventModifierFlags(rawValue: 0)
            return
        }
        highlightCodeItem.keyEquivalent = hotkey.characters
        highlightCodeItem.keyEquivalentModifierMask = KeyTransformer.cocoaFlags(from: hotkey.modifiers)
    }
    
    @IBAction func highlightCodeAction(sender: AnyObject?) {
        highlightCode()
    }
    
    @IBAction func setStyle(sender: AnyObject?) {
        let senderItem = sender as! NSMenuItem
        for item in styleMenu.items {
            item.state = NSOffState
            if item.title == senderItem.title {
                item.state = NSOnState
            }
        }
        highlighter.setStyle(name: senderItem.title)
        UserDefaults.standard.set(senderItem.title, forKey: "style")
    }

    @IBAction func openPreference(sender: AnyObject?) {
        prefWindowController.showWindow(self)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @IBAction func quitApplication(sender: AnyObject?) {
        NSApplication.shared().terminate(self)
    }
    
}

// visit web pages
extension AppDelegate {
    func openURLwithDefaultBrowser(urlKey: String) {
        guard let urls = Bundle.main.object(forInfoDictionaryKey: "URLs") as? Dictionary<String, String> else {
            return
        }
        if let urlString = urls[urlKey] {
            NSWorkspace.shared().open(URL(string: urlString)!)
        }
    }
    
    @IBAction func openHomepage(sender: AnyObject?) {
        openURLwithDefaultBrowser(urlKey: "Homepage")
    }
    
    @IBAction func openIssuePage(sender: AnyObject?) {
        openURLwithDefaultBrowser(urlKey: "Issue Tracker")
    }
}
