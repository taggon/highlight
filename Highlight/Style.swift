//
//  Style.swift
//  Highlight
//
//  Created by Taegon Kim on 27/03/2017.
//  Copyright © 2017 Taegon Kim. All rights reserved.
//

import AppKit

let regexStylesheet = try! NSRegularExpression(pattern: "([^\\{\\}]+?)\\s*\\{\\s*([^\\}]+)\\s*\\}", options: [])
let regexPreprocess = try! NSRegularExpression(pattern: "/\\*.+?\\*/|\r?\n|\u{D}", options: [.dotMatchesLineSeparators])
let regexDeclaration = try! NSRegularExpression(pattern: "\\s*([^:;]+)\\s*:\\s*([^;]+);?\\s*", options: [])
let regexColor = try! NSRegularExpression(pattern: "#([0-9a-fA-F]{3,6})", options: [])
let regexRGBA = try! NSRegularExpression(pattern: "rgba\\(\\s*([\\d\\.]+)\\s*,\\s*([\\d\\.]+),\\s*([\\d\\.]+),\\s*([\\d\\.]+)\\s*\\)", options: [])

let webColors = [
    "aqua": "00ffff",
    "azure": "f0ffff",
    "black": "000000",
    "blue": "0000ff",
    "brown": "a52a2a",
    "cyan": "00ffff",
    "darkgray": "a9a9a9",
    "darkgrey": "a9a9a9",
    "fuchsia": "ff00ff",
    "gray": "808080",
    "grey": "808080",
    "green": "008000",
    "lightgray": "d3d3d3",
    "lightgrey": "d3d3d3",
    "navy": "000080",
    "orange": "ffa500",
    "pink": "ffc0cb",
    "purple": "800080",
    "red": "ff0000",
    "silver": "c0c0c0",
    "white": "ffffff",
    "yellow": "ffff00",
]

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
        let matches = regexStylesheet.matches(in: css, options: [], range: NSMakeRange(0, css.count))
        
        rulesets = []
        
        for match in matches {
            let selectors = cssNS.substring(with: match.range(at: 1)).trimmingCharacters(in: .whitespacesAndNewlines)
            let ruleset = cssNS.substring(with: match.range(at: 2)).trimmingCharacters(in: .whitespacesAndNewlines)
            
            if selectors == "" || ruleset == "" {
                continue
            }
            
            rulesets.append(Ruleset(
                selectors: parseSelector(input: selectors),
                declarations: parseRuleset(input: ruleset)
            ))
        }
        
        // Automatically add line number style
        addLineNumColor()
    }
    
    func preprocess(input: String) -> String {
        // remove comment and new lines
        let code  = regexPreprocess.stringByReplacingMatches(in: input, options: [], range: NSMakeRange(0, input.count), withTemplate: "")
        
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
        let matches = regexDeclaration.matches(in: input, options: [], range: NSMakeRange(0, input.count))
        var declarations:[Style.Declaration] = []

        for match in matches {
            let prop = inputNS.substring(with: match.range(at: 1)).trimmingCharacters(in: .whitespacesAndNewlines)
            let value = inputNS.substring(with: match.range(at: 2)).trimmingCharacters(in: .whitespacesAndNewlines)

            if prop == "" || value == "" {
                continue
            }
            
            declarations.append(Style.Declaration(property: prop, value: value, color: parseColor(input: value)))
        }
        
        return declarations
    }
    
    func parseColor(input: String) -> CGColor? {
        let color: String = input.lowercased()
        var hexColor: String = ""
        
        if webColors[color] != nil {
            hexColor = webColors[color]!
        } else if let match = regexColor.firstMatch(in: color, options: [], range: NSMakeRange(0, color.count)) {
            hexColor = (color as NSString).substring(with: match.range(at: 1))
        } else if let match = regexRGBA.firstMatch(in: color, options: [], range: NSMakeRange(0, color.count)) {
            let colorNS = color as NSString
            return CGColor(
                red: CGFloat( ( colorNS.substring(with: match.range(at: 1)) as NSString ).floatValue / 255.0 ),
                green: CGFloat( ( colorNS.substring(with: match.range(at: 2)) as NSString ).floatValue / 255.0 ),
                blue: CGFloat( ( colorNS.substring(with: match.range(at: 3)) as NSString ).floatValue / 255.0 ),
                alpha: CGFloat( ( colorNS.substring(with: match.range(at: 4)) as NSString ).floatValue )
            )
        } else {
            return nil
        }

        if hexColor.count == 3 {
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

    /**
     * Get the color of line numbers
     *
     * Since Highlight.js doesn't support line numbers, there is no color definition for it.
     * Therefore, it is necessary to calculate the color to support line numbers.
     */
    func addLineNumColor() {
        // If a line number style is already defined, skip it.
        if self[".hljs-line-number"] != nil {
            return
        }

        guard let hljs = self[".hljs"] else {
            return
        }

        var color = CGColor(red: 0, green: 0, blue: 0, alpha: 1.0)
        if hljs["color"] != nil && hljs["color"]!.color != nil {
            color = hljs["color"]!.color!
        }

        var hsv = RGB.hsv(r: Float(color.components![0]) * 255.0, g: Float(color.components![1]) * 255.0, b: Float(color.components![2]) * 255.0)

        // lighten or darken the default text color to get line number color
        if hsv.v > 127 {
            hsv = HSV(h: hsv.h, s: hsv.s, v: 127)
        } else {
            hsv = HSV(h: hsv.h, s: hsv.s, v: 127)
        }

        rulesets.append(Ruleset(
            selectors: [".hljs-line-number"],
            declarations: [
                Declaration(
                    property: "color",
                    value: String(format: "#%02x%02x%02x", Int(hsv.rgb.r), Int(hsv.rgb.g), Int(hsv.rgb.b)),
                    color: color
                )
            ]
        ))
    }
}
