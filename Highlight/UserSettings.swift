//
//  UserSettings.swift
//  Highlight
//
//  Created by Taegon Kim on 30/03/2017.
//  Copyright © 2017 Taegon Kim. All rights reserved.
//

import Foundation
import AppKit
import Magnet

protocol UserSettings { }

var cachedUserFont: NSFont?
var cachedUserStyle: String?

extension UserSettings {

    // # Font
    
    var defaultFont: NSFont {
        return NSFontManager.shared().font(withFamily: "Courier", traits: NSFontTraitMask(rawValue: 0), weight: Int(NSFontWeightRegular), size: CGFloat(14.0))!
    }

    var userFont: NSFont? {
        if cachedUserFont != nil {
            return cachedUserFont
        }

        let fontManager = NSFontManager.shared()
        let defaults = UserDefaults.standard
        let family = defaults.string(forKey: "font-family") ?? fontManager.localizedName(forFamily: "Courier", face: nil)

        let font = fontManager.font(
            withFamily: family,
            traits: NSFontTraitMask(rawValue: UInt(defaults.integer(forKey: "font-traits"))),
            weight: defaults.integer(forKey: "font-weight"),
            size: CGFloat(max(defaults.float(forKey: "font-size"), 12))
        )

        cachedUserFont = font

        return font
    }
    
    func saveFont(font: NSFont) {
        if cachedUserFont == font {
            return
        }

        cachedUserFont = font

        let defaults = UserDefaults.standard
        let fontManager = NSFontManager.shared()
        
        defaults.set(font.familyName ?? font.fontName, forKey: "font-family")
        defaults.set(Float(font.pointSize), forKey: "font-size")
        defaults.set(fontManager.traits(of: font).rawValue, forKey: "font-traits")
        defaults.set(fontManager.weight(of: font), forKey: "font-weight")
    }
    
    // # Style

    var userStyle: String {
        if cachedUserStyle == nil {
            cachedUserStyle = UserDefaults.standard.string(forKey: "style") ?? "Default"
        }
        return cachedUserStyle!
    }
    
    func saveStyle(style: String) {
        if hlStyles[style] != nil {
            cachedUserStyle = style
            UserDefaults.standard.set(style, forKey: "style")
        }
    }
    
    // # Programming languages

    var defaultLangs: [String] {
        return ["apache", "bash", "cs", "cpp", "css", "diff", "xml", "http", "ini", "json", "java", "javascript", "markdown", "objectivec", "php", "perl", "python", "ruby", "sql", "swift"]
    }
    
    var userLangs: [String] {
        return (UserDefaults.standard.array(forKey: "selected-languages") as? [String]) ?? defaultLangs
    }
    
    func addLang(lang: String) {
        if userLangs.index(of: lang) != nil {
            return
        }
        
        var newLangs = userLangs
        newLangs.append(lang)
        
        UserDefaults.standard.set(newLangs, forKey: "selected-languages")
    }
    
    func removeLang(lang: String) {
        guard let idx = userLangs.index(of: lang) else { return }
        var newLangs = userLangs
        newLangs.remove(at: idx)
        
        UserDefaults.standard.set(newLangs, forKey: "selected-languages")
    }
    
    // # Hotkey
    
    var hotkey: KeyCombo? {
        guard let hotkeyInfo = UserDefaults.standard.object(forKey: "highlight:hotkey") as? [String: Int] else {
            return nil
        }
        
        return KeyCombo(keyCode: hotkeyInfo["keycode"]!, carbonModifiers: hotkeyInfo["modifiers"]!)
    }
    
    func saveHotkey(keycomb: KeyCombo) {
        let appDelegate = NSApplication.shared().delegate as! AppDelegate
        let hotkey = HotKey(identifier: "highlight:hotkey", keyCombo: keycomb, target: appDelegate, action: #selector(AppDelegate.highlightCode))
        let info = ["keycode": keycomb.keyCode, "modifiers": keycomb.modifiers]
        
        if keycomb.modifiers == 0 {
            return
        }
        
        removeHotkey()
        UserDefaults.standard.set(info, forKey: "highlight:hotkey")

        if !HotKeyCenter.shared.register(with: hotkey) {
            debugPrint("Failure to register the hotkey.")
        }

        appDelegate.updateKeyEquivalentOfHighlightMenu()
    }
    
    func removeHotkey() {
        let appDelegate = NSApplication.shared().delegate as! AppDelegate
        UserDefaults.standard.removeObject(forKey: "highlight:hotkey")
        HotKeyCenter.shared.unregisterHotKey(with: "highlight:hotkey")
        appDelegate.updateKeyEquivalentOfHighlightMenu()
    }

    // # Line numbers

    var showLineNumbers: Bool {
        return UserDefaults.standard.bool(forKey: "show-line-numbers")
    }

    func saveShowLineNumbers(display: Bool) {
        UserDefaults.standard.set(display, forKey: "show-line-numbers")
    }

    var lineNumberPadding: Int {
        return UserDefaults.standard.integer(forKey: "line-number-padding")
    }

    func saveLineNumberPadding(numberOfSpaces: Int) {
        UserDefaults.standard.set(numberOfSpaces, forKey: "line-number-padding")
    }
}
