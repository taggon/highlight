//
//  Highlighter.swift
//  Highlight
//
//  Created by Taegon Kim on 27/03/2017.
//  Copyright © 2017 Taegon Kim. All rights reserved.
//

import Foundation
import JavaScriptCore
import AppKit

class Highlighter: UserSettings {
    var currentStyle: Style?
    private var vm: JSVirtualMachine!
    private var context: JSContext!
    private var hljs: JSValue!
    
    init() {
        vm = JSVirtualMachine()
        context = JSContext(virtualMachine: vm)
        loadHighlightJS()

        setStyle(name: "Default")
        setStyle(name: UserDefaults.standard.string(forKey: "style") ?? "Default")
    }
    
    func loadHighlightJS() {
        let jsPath = Bundle.main.path(forResource: "scripts/highlight.pack", ofType: "js")
        let js = try! String(contentsOfFile: jsPath!, encoding: .utf8)

        context.evaluateScript("var self={};" + js)
        hljs = context.objectForKeyedSubscript("self").forProperty("hljs")
    }
    
    func isValidStyle(name: String) -> Bool {
        return ( hlStyles.index(forKey: name) != nil )
    }

    func setStyle(name: String) {
        if !isValidStyle(name: name) || currentStyle?.name == name {
            return
        }
        
        let stylePath = Bundle.main.path(forResource: "scripts/styles/\(hlStyles[name]!).min", ofType: "css")
        let styleCode = try! String(contentsOfFile: stylePath!, encoding: .utf8)
        
        currentStyle = Style(name: name, code: styleCode)
    }
    
    func getStyle() -> String {
        return currentStyle!.name
    }
    
    func paint(code: String, lang: String = "") -> NSAttributedString {
        let codeVar = JSValue(object: code, in: context)!
        let subset = (lang == "") ? getDefaultSubsetLanguages(): JSValue(object: [JSValue(object: lang, in: context)], in: context )!
        let result = hljs.invokeMethod("highlightAuto", withArguments: [codeVar, subset])
        let renderedCode = result!.forProperty("value")
        
        var attrStr = NSMutableAttributedString(string: "An error occurs while rendering the code")
        if renderedCode != nil {
            let html = parseClassAsInlineStyles(html: "<pre class=\"hljs\"><code>\(renderedCode!.toString()!)</code></pre>")
            attrStr = NSMutableAttributedString(html: html.data(using: .utf8)!, options: [:], documentAttributes: nil)!
            attrStr.addAttribute(NSFontAttributeName, value: userFont ?? defaultFont, range: NSMakeRange(0, attrStr.length))
        }
        
        return attrStr
    }
    
    func parseClassAsInlineStyles(html: String) -> String {
        var str = html
        let regex = try! NSRegularExpression(pattern: "<(span|pre)\\s+class=\"([^\"]+)\">", options: [])
        var anchorPos = 0

        while let match = regex.firstMatch(in: str, options: [], range: NSMakeRange(anchorPos, str.characters.count - anchorPos)) {
            let strNS = str as NSString
            let classNames = strNS.substring(with: match.rangeAt(2)).components(separatedBy: .whitespacesAndNewlines)
            
            var style = ""
            for className in classNames {
                guard let ruleset = currentStyle?[".\(className)"] else {
                    continue
                }
                
                for (_, prop) in ruleset.keys.enumerated() {
                    style += "\(prop):\(ruleset[prop]!.value!);"
                }
                
                // For the root container, skip the background and add font family and size
                if className == "hljs" {
                    let font = userFont ?? defaultFont
                    style += "background:transparent none;font-size:\(Float(font.pointSize))pt"
                }
            }
            
            if style == "" {
                anchorPos = match.range.location + match.range.length
            } else {
                let replacement = "<\(strNS.substring(with: match.rangeAt(1))) style=\"\(style)\">"
                str = str.substring(to: str.index(str.startIndex, offsetBy: match.range.location)) +
                    replacement +
                    str.substring(from: str.index(str.startIndex, offsetBy: match.range.location + match.range.length))
                anchorPos = match.range.location + replacement.characters.count
            }
        }
        
        return str
    }
    
    func getDefaultSubsetLanguages() -> JSValue {
        let subset = userLangs.map { lang in JSValue(object: lang, in: context) }
        return JSValue(object: subset, in: context)
    }
}
