//
//  StylePreferencesViewController.swift
//  Highlight
//
//  Created by Taegon Kim on 08/01/2017.
//  Copyright © 2017 Taegon Kim. All rights reserved.
//

import Cocoa

class StylePreferencesViewController: NSViewController, UserSettings {

    @IBOutlet weak var fontInfo: NSTextField!
    @IBOutlet weak var fontSelectButton: NSButton!
    @IBOutlet weak var stylePopup: NSPopUpButton!
    @IBOutlet weak var codeView: NSTextView!
    @IBOutlet weak var langButton: NSButton!
    @IBOutlet weak var langMenu: NSMenu!

    private var appDelegate: AppDelegate {
        return NSApplication.shared().delegate as! AppDelegate
    }
    
    var snippet: String!
    var lang = "js"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildLangMenu()
        loadSnippet(type: lang)
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        fontInfo.selectText(nil)
        setupFont()
        resetStyles()
        refreshCode()
        
        NotificationCenter.default.addObserver(self, selector: #selector(defaultsChanged), name: UserDefaults.didChangeNotification, object: nil)
    }
    
    override func viewWillDisappear() {
        NotificationCenter.default.removeObserver(self)
        super.viewWillDisappear()
    }

    func defaultsChanged(notification: Notification) {
        setupFont()
        setupStyle()
        refreshCode()
    }
    
    func resetStyles() {
        let menu = stylePopup.menu!
        menu.removeAllItems()
        
        let styles = hlStyles.keys.enumerated().map { item in
            return item.element
        }
        
        for style in styles.sorted() {
            let item = NSMenuItem(title: style, action: #selector(setStyle), keyEquivalent: "")
            menu.addItem(item)
        }
        
        setupStyle()
    }
    
    func setStyle(sender: AnyObject?) {
        let senderItem = sender as! NSMenuItem
        stylePopup.select(senderItem)
        appDelegate.setStyle(sender: sender)
        
        setupStyle()
        refreshCode()
    }
    
    func setupStyle() {
        stylePopup.setTitle(UserDefaults.standard.string(forKey: "style")!)
        stylePopup.synchronizeTitleAndSelectedItem()
    }
    
    func selectFont(sender: AnyObject?) {
        let fontManager = sender as? NSFontManager
        if let font = fontManager?.convert(.systemFont(ofSize: 0)) {
            saveFont(font: font)
        }
    }
    
    func setupFont() {
        guard let userFont = self.userFont else { return }
        fontInfo.stringValue = "\(userFont.displayName!), \(Float(userFont.pointSize))pt"
        codeView.font = userFont
    }
    
    func refreshCode() {
        let containerRuleset = appDelegate.highlighter.currentStyle?[".hljs"]
        let bgColor = containerRuleset?["background"]?.color ?? containerRuleset?["background-color"]?.color ?? CGColor.white
        codeView.backgroundColor = NSColor(cgColor: bgColor)!
        
        codeView.isEditable = true
        DispatchQueue.global().async {
            let text = self.appDelegate.highlighter.paint(code: self.snippet)
            DispatchQueue.main.async {
                self.codeView.string = ""
                self.codeView.textStorage?.append(text)
                self.codeView.isEditable = false
            }
        }
    }
    
    @IBAction func openFontPanel(sender: AnyObject?) {
        let defaults = UserDefaults.standard
        let font = NSFont( name: defaults.string(forKey: "font-family")!, size: CGFloat(defaults.float(forKey: "font-size")) )
        let buttonRect = fontSelectButton.window!.convertToScreen(fontSelectButton.frame)
        let panel = NSFontPanel.shared()
        let panelOrigin = CGPoint(x: buttonRect.origin.x, y: buttonRect.origin.y - panel.frame.height)
        let fontManager = NSFontManager.shared()

        panel.setFrameOrigin(panelOrigin)

        fontManager.action = #selector(selectFont)
        fontManager.setSelectedFont(font!, isMultiple: false)
        fontManager.orderFrontFontPanel(self)
        
    }
}

// Lanauges
extension StylePreferencesViewController {
    var languages:[String: String] {
        return [
            "JS": "js",
            "PHP": "php",
            "Java": "java",
            "C++": "cpp",
            "HTML": "html",
            "CSS": "css",
        ]
    }
    
    func buildLangMenu() {
        langMenu.removeAllItems()

        for lang in languages.keys {
            langMenu.insertItem(withTitle: lang, action: #selector(changeLanguage), keyEquivalent: "", at: 0)
        }
    }
    
    func changeLanguage(sender: AnyObject?) {
        guard let item = sender as? NSMenuItem else { return }

        loadSnippet(type: languages[item.title]!)
        langButton.title = "Language: \(item.title)"
        lang = languages[item.title]!
        
        refreshCode()
    }
    
    func loadSnippet(type: String) {
        guard let path = Bundle.main.path(forResource: "snippets/demo", ofType: type) else { return }
        self.snippet = try! String(contentsOfFile: path, encoding: .utf8)
    }
    
    @IBAction func showLangMenu(sender: AnyObject?) {
        NSMenu.popUpContextMenu(langMenu, with: NSApplication.shared().currentEvent!, for: langButton)
    }
}
