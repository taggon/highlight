//
//  Style.swift
//  Highlight
//
//  Created by Taegon Kim on 27/03/2017.
//  Copyright © 2017 Taegon Kim. All rights reserved.
//

import Foundation

let regexStylesheet = try! NSRegularExpression(pattern: "([^\\{\\}]+?)\\s*\\{\\s*([^\\}]+)\\s*\\}", options: [])
let regexPreprocess = try! NSRegularExpression(pattern: "/\\*.+?\\*/|\r?\n|\u{D}", options: [.dotMatchesLineSeparators])
let regexDeclaration = try! NSRegularExpression(pattern: "\\s*([^:;]+)\\s*:\\s*([^;]+);?\\s*", options: [])
let regexColor = try! NSRegularExpression(pattern: "#([0-9a-fA-F]{3,6})", options: [])

class Style {
    struct Ruleset {
        var selectors: [String]!
        var declarations: [Declaration]!
    }
    
    struct Declaration {
        var property: Property!
        var value: String!
        var color: CGColor?
    }
    
    typealias Property = String

    var name: String {
        return self._name
    }
    private var _name: String! = ""
    var rulesets: [Ruleset] = [];
    
    init(name: String, code: String) {
        _name = name
        setCode(code: code)
    }
    
    subscript(selector: String) -> [Property: Declaration]? {
        let filteredRuleset = rulesets.filter { ruleset in
            return ruleset.selectors.contains(selector)
        }
        
        if filteredRuleset.count == 0 {
            return nil
        }

        var result:[Property: Declaration] = [:]
        
        for ruleset in filteredRuleset {
            for declaration in ruleset.declarations {
                result[declaration.property] = declaration
            }
        }
        
        return (result.count > 0) ? result: nil
    }
    
    func setCode(code: String) {
        let css = preprocess(input: code)
        let cssNS = css as NSString
        let matches = regexStylesheet.matches(in: css, options: [], range: NSMakeRange(0, css.characters.count))
        
        rulesets = []
        
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
    }
    
    func preprocess(input: String) -> String {
        // remove comment and new lines
        let code  = regexPreprocess.stringByReplacingMatches(in: input, options: [], range: NSMakeRange(0, input.characters.count), withTemplate: "")
        
        return code
    }
    
    func parseSelector(input: String) -> [String] {
        let selectors = input.components(separatedBy: ",").map { str in
            return str.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        return selectors
    }
    
    func parseRuleset(input: String) -> [Style.Declaration] {
        let inputNS = input as NSString
        let matches = regexDeclaration.matches(in: input, options: [], range: NSMakeRange(0, input.characters.count))
        var declarations:[Style.Declaration] = []
        
        for match in matches {
            let prop = inputNS.substring(with: match.rangeAt(1)).trimmingCharacters(in: .whitespacesAndNewlines)
            let value = inputNS.substring(with: match.rangeAt(2)).trimmingCharacters(in: .whitespacesAndNewlines)
            
            if prop == "" || value == "" {
                continue
            }
            
            declarations.append(Style.Declaration(property: prop, value: value, color: parseColor(input: value)))
        }
        
        return declarations
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
