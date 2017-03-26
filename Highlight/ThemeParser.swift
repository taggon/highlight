//
//  ThemeParser.swift
//  Highlight
//
//  Created by Taegon Kim on 12/02/2017.
//  Copyright © 2017 Taegon Kim. All rights reserved.
//

import Foundation

class ThemeParser {
    var regexStylesheet: NSRegularExpression!
    var regexPreprocess: NSRegularExpression!
    var regexDeclaration: NSRegularExpression!
    var regexColor: NSRegularExpression!
    
    struct Ruleset {
        var selectors: [String]!
        var declarations: [Declaration]!
    }
    
    struct Declaration {
        var property: String!
        var value: String!
        var color: CGColor?
    }
    
    init() {
        regexStylesheet = try! NSRegularExpression(pattern: "([^\\{\\}]+?)\\s*\\{\\s*([^\\}]+)\\s*\\}", options: [])
        regexPreprocess = try! NSRegularExpression(pattern: "/\\*.+?\\*/|\r?\n|\u{D}", options: [.dotMatchesLineSeparators])
        regexDeclaration = try! NSRegularExpression(pattern: "\\s*([^:;]+)\\s*:\\s*([^;]+);?\\s*", options: [])
        regexColor = try! NSRegularExpression(pattern: "#([0-9a-fA-F]{3,6})", options: [])
    }
    
    public func parse(input: String) -> [Ruleset] {
        let css = preprocess(input: input)
        let cssNS = css as NSString
        let matches = regexStylesheet.matches(in: css, options: [], range: NSMakeRange(0, css.characters.count))
        var rulesets:[Ruleset] = []

        for match in matches {
            let selectors = cssNS.substring(with: match.rangeAt(1)).trimmingCharacters(in: .whitespacesAndNewlines)
            let ruleset = cssNS.substring(with: match.rangeAt(2)).trimmingCharacters(in: .whitespacesAndNewlines)
            
            if selectors == "" || ruleset == "" {
                continue
            }

            rulesets.append(Ruleset(
                selectors: parseSelector(input: selectors),
                declarations: parseRuleset(input: ruleset)
            ))
        }
        
        return rulesets
    }
    
    func parseSelector(input: String) -> [String] {
        let selectors = input.components(separatedBy: ",").map { str in
            return str.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        return selectors
    }
    
    func parseRuleset(input: String) -> [Declaration] {
        let inputNS = input as NSString
        let matches = regexDeclaration.matches(in: input, options: [], range: NSMakeRange(0, input.characters.count))
        var declarations:[Declaration] = []
        
        for match in matches {
            let prop = inputNS.substring(with: match.rangeAt(1)).trimmingCharacters(in: .whitespacesAndNewlines)
            let value = inputNS.substring(with: match.rangeAt(2)).trimmingCharacters(in: .whitespacesAndNewlines)

            if prop == "" || value == "" {
                continue
            }

            declarations.append(Declaration(property: prop, value: value, color: parseColor(input: value)))
        }
        
        return declarations
    }

    func preprocess(input: String) -> String {
        // remove comment and new lines
        let code  = regexPreprocess.stringByReplacingMatches(in: input, options: [], range: NSMakeRange(0, input.characters.count), withTemplate: "")
        
        return code
    }
    
    func parseColor(input: String) -> CGColor? {
        guard let match = regexColor.firstMatch(in: input, options: [], range: NSMakeRange(0, input.characters.count)) else {
            return nil
        }
        
        var hexColor = (input as NSString).substring(with: match.rangeAt(1)).lowercased()
        if hexColor.characters.count == 3 {
            let regex = try! NSRegularExpression(pattern: "[0-9a-f]")
            hexColor = regex.stringByReplacingMatches(in: hexColor, options: [], range: NSMakeRange(0, 3), withTemplate: "$0$0")
        }
        var rgbValue: UInt32 = 0
        Scanner(string: hexColor).scanHexInt32(&rgbValue)
        
        return CGColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
