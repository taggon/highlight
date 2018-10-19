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
        context.exceptionHandler = { context, exception in
            self.logJSException(exception: exception)
        }
        loadHighlightJS()

        setStyle(name: UserDefaults.standard.string(forKey: "style") ?? "Default")
    }

    func logJSException(exception: JSValue?) {
        debugPrint(exception ?? "Unknown JavaScript exception occurs.")
    }
    
    func loadHighlightJS() {
        let jsPath = Bundle.main.path(forResource: "scripts/highlight.pack", ofType: "js")
        let js = try! String(contentsOfFile: jsPath!, encoding: .utf8)

        context.evaluateScript(js)
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
        var attrStr = NSMutableAttributedString(string: "An error occurs while rendering the code")
        var result: JSValue? = nil

        if lang != "" {
            // use a specific language
            let langVar = JSValue(object: lang, in: context)!
            result = hljs.invokeMethod("highlight", withArguments: [langVar, codeVar])!.forProperty("value")
        } else {
            // auto detect language
            let subset = getDefaultSubsetLanguages()
            result = hljs.invokeMethod("highlightAuto", withArguments: [codeVar, subset])!.forProperty("value")
        }

        guard var renderedCode = result?.toString() else {
            return attrStr
        }

        // Add line numbers
        if showLineNumbers {
            renderedCode = addLineNumbers(code: renderedCode)
        }

        let html = parseClassAsInlineStyles(html: "<pre class=\"hljs\"><code>\(renderedCode)</code></pre>")
        attrStr = NSMutableAttributedString(html: html.data(using: .unicode)!, options: [:], documentAttributes: nil)!

        // set the default font size
        attrStr.addAttribute(NSAttributedString.Key.font, value: userFont ?? defaultFont, range: NSMakeRange(0, attrStr.length))
        
        return attrStr
    }

    func parseClassAsInlineStyles(html: String) -> String {
        var str = html
        let regex = try! NSRegularExpression(pattern: "<(span|pre)\\s+class=\"([^\"]+)\">", options: [])
        var anchorPos = 0

        while let match = regex.firstMatch(in: str, options: [], range: NSMakeRange(anchorPos, str.count - anchorPos)) {
            let strNS = str as NSString
            let classNames = strNS.substring(with: match.range(at: 2)).components(separatedBy: .whitespacesAndNewlines)

            var style = ""
            for className in classNames {
                guard let ruleset = currentStyle?[".\(className)"] else {
                    continue
                }
                
                for (_, prop) in ruleset.keys.enumerated() {
                    style += "\(prop):\(ruleset[prop]!.value!);"
                }

                // For the root container, skip the background
                if className == "hljs" {
                    style += "background:transparent none"
                }
            }
            
            if style == "" {
                anchorPos = match.range.location + match.range.length
            } else {
                let replacement = "<\(strNS.substring(with: match.range(at: 1))) style=\"\(style)\">"
                str = str[..<str.index(str.startIndex, offsetBy: match.range.location)] +
                    replacement +
                    str[str.index(str.startIndex, offsetBy: match.range.location + match.range.length)...]
                anchorPos = match.range.location + replacement.count
            }
        }
        return str
    }
    
    func getDefaultSubsetLanguages() -> JSValue {
        let subset = userLangs.map { lang in JSValue(object: lang, in: context) }
        return JSValue(object: subset, in: context)
    }

    func addLineNumbers(code: String) -> String {
        var lines = code.components(separatedBy: .newlines)
        let maxDigit = "\(lines.count)".count
        let padding = "".padding(toLength: lineNumberPadding, withPad: " ", startingAt: 0)

        for (index, line) in lines.enumerated() {
            let lineNum = "".padding(toLength: maxDigit - "\(index + 1)".count, withPad: " ", startingAt: 0) + "\(index + 1)"
            lines[index] = "<span class=\"hljs-line-number\">\(lineNum)</span>\(padding)\(line)"
        }

        return lines.joined(separator:"\n")
    }
}
