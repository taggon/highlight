//
//  CSSParser.swift
//  Highlight
//
//  Created by Taegon Kim on 12/02/2017.
//  Copyright © 2017 Taegon Kim. All rights reserved.
//

import Foundation

class CSSParser {

    init(options: [CSSParserOption]?) {
        
    }

    func tokenize(_ input: String) -> [CSSToken] {
        var tokens: [CSSToken] = [];
        
        var regex = try! NSRegularExpression(pattern: "(?<newline>\\r?\\n|\\n)|(?<commentstart>/\\*)|(?<commentend>\\*/)|(?<blockstart>\\{)|(?<blockend>\\})|(?<delimiter>[,:;])", options: []);
        let result = regex.matches(in: input, options: [], range: NSMakeRange(0, input.characters.count))
        print(result)

        /*
        var lineNumber = 1
        // normalize new line characters and split the input into lines
        input.enumerateLines { line, _ in
            lineNumber = lineNumber + 1
        }
        */
        
        return tokens;
    }

    func parse(input: String) {
        let tokens = self.tokenize(input)
    }
}
