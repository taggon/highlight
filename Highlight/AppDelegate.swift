//
//  AppDelegate.swift
//  Highlight
//
//  Created by Taegon Kim on 07/01/2017.
//  Copyright © 2017 Taegon Kim. All rights reserved.
//

import Cocoa
import Magnet
import LetsMove

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, UserSettings {

    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var styleMenu: NSMenu!
    @IBOutlet weak var highlightCodeItem: NSMenuItem!

    var statusItem: NSStatusItem = NSStatusBar.system().statusItem(withLength: NSSquareStatusItemLength)
    var highlighter: Highlighter = Highlighter()
    var currentFont: NSFont?
    
    lazy var prefWindowController: NSWindowController! = {
        let storyboard = NSStoryboard(name: "Preferences", bundle: Bundle.main)
        let controller = storyboard.instantiateInitialController() as! PrefWindowController
        
        return controller
    }()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // move this application into /Applications if necessary.
        #if !DEBUG
            PFMoveToApplicationsFolderIfNecessary()
        #endif
        
        // register hotkey
        if hotkey != nil {
            saveHotkey(keycomb: hotkey!)
        }

        // Start watching user settings change
        NotificationCenter.default.addObserver(self, selector: #selector(defaultsChanged), name: UserDefaults.didChangeNotification, object: nil)

        // Save the current font for comparison
        currentFont = userFont

        prefWindowController.showWindow(self)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        NotificationCenter.default.removeObserver(self)
        HotKeyCenter.shared.unregisterAll()
    }

    func defaultsChanged(notification: Notification) {
        let styleChanged = ( highlighter.getStyle() != userStyle )

        if styleChanged {
            highlighter.setStyle(name: userStyle)
        }
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

    @IBAction func openPreference(sender: AnyObject?) {
        prefWindowController.showWindow(self)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @IBAction func quitApplication(sender: AnyObject?) {
        NSApplication.shared().terminate(self)
    }
}

// popup menu
extension AppDelegate {
    func initMenu() {
        statusItem.menu = statusMenu
        loadStatusImage(name: "StatusIcon")

        // set version
        statusMenu.items[0].title += " v\(version)"

        drawStyleMenu()
        updateStyleMenu()
    }

    func drawStyleMenu() {
        let styles = hlStyles.keys.enumerated().map { item in
            return item.element
        }

        for style in styles.sorted() {
            let item = NSMenuItem(title: style, action: #selector(setStyleFromMenu), keyEquivalent: "")
            styleMenu.addItem(item)
        }
    }

    func updateStyleMenu() {
        for item in styleMenu.items {
            item.state = ( item.title == userStyle ) ? NSOnState : NSOffState
        }
    }

    @IBAction func setStyleFromMenu(sender: AnyObject?) {
        guard let styleMenuItem = sender as? NSMenuItem else {
            return
        }

        saveStyle(style: styleMenuItem.title)
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
