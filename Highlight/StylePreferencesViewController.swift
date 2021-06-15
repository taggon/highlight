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
        return NSApplication.shared.delegate as! AppDelegate
    }

    var snippet: String!
    var lang = "js"
    var langLabelFormat: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        buildLangMenu()
        disableWordWrap()
        loadSnippet(type: lang)
        langLabelFormat = langButton.title
        langButton.title = String(format: langLabelFormat, "JS")
    }

    override func viewDidAppear() {
        super.viewDidAppear()

        fontInfo.selectText(nil)
        setupFont()
        resetStyles()
        setupStyle()
        refreshCode()

        NotificationCenter.default.addObserver(self, selector: #selector(defaultsDidChange), name: UserDefaults.didChangeNotification, object: nil)
    }

    override func viewWillDisappear() {
        NotificationCenter.default.removeObserver(self)
        super.viewWillDisappear()
    }

    func disableWordWrap() {
        guard let container = codeView.textContainer else {
            return
        }

        container.containerSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        container.widthTracksTextView = false
    }

    @objc func defaultsDidChange(notification: Notification) {
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
    }

    @objc func setStyle(sender: AnyObject?) {
        let senderItem = sender as! NSMenuItem
        stylePopup.select(senderItem)
        saveStyle(style: senderItem.title)
    }

    func setupStyle() {
        if userStyle != stylePopup.title {
            stylePopup.setTitle(userStyle)
            stylePopup.synchronizeTitleAndSelectedItem()
        }
    }

    @objc func selectFont(sender: AnyObject?) {
        let fontManager = sender as? NSFontManager
        if let font = fontManager?.convert(.systemFont(ofSize: 10)) {
            saveFont(font: font)
            setupFont()
        }
    }

    func setupFont() {
        let font = userFont ?? defaultFont
        fontInfo.stringValue = "\(font.displayName!), \(Float(font.pointSize))pt"
        codeView.font = font
    }

    func refreshCode() {
        let containerRuleset = appDelegate.highlighter.currentStyle?[".hljs"]
        let bgColor = containerRuleset?["background"]?.color ?? containerRuleset?["background-color"]?.color ?? CGColor.white
        let highlighter = appDelegate.highlighter
        
        DispatchQueue.global().async {
            let text = highlighter.paint(code: self.snippet, lang: self.lang)
            DispatchQueue.main.async {
                self.codeView.isEditable = true
                self.codeView.string = ""
                self.codeView.textStorage?.append(text)
                self.codeView.backgroundColor = NSColor(cgColor: bgColor)!
                self.codeView.isEditable = false
            }
        }
    }

    @IBAction func openFontPanel(sender: AnyObject?) {
        let font = userFont ?? defaultFont
        let buttonRect = fontSelectButton.window!.convertToScreen(fontSelectButton.frame)
        let panel = NSFontPanel.shared
        let panelOrigin = CGPoint(x: buttonRect.origin.x, y: buttonRect.origin.y - panel.frame.height)
        let fontManager = NSFontManager.shared

        panel.setFrameOrigin(panelOrigin)

        fontManager.action = #selector(selectFont)
        fontManager.setSelectedFont(font, isMultiple: false)
        fontManager.orderFrontFontPanel(self)
    }
}

// Languages
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
            langMenu.insertItem(withTitle: lang, action: #selector(languageDidChange), keyEquivalent: "", at: 0)
        }
    }
    
    @objc func languageDidChange(sender: AnyObject?) {
        guard let item = sender as? NSMenuItem else { return }

        loadSnippet(type: languages[item.title]!)
        langButton.title = String(format: langLabelFormat, item.title)
        lang = languages[item.title]!
        
        refreshCode()
    }
    
    func loadSnippet(type: String) {
        guard let path = Bundle.main.path(forResource: "snippets/demo", ofType: type) else { return }
        self.snippet = try! String(contentsOfFile: path, encoding: .utf8)
    }
    
    @IBAction func showLangMenu(sender: AnyObject?) {
        NSMenu.popUpContextMenu(langMenu, with: NSApplication.shared.currentEvent!, for: langButton)
    }
}
