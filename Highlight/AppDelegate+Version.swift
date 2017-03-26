//
//  AppDelegate+Version.swift
//  Coffeefy
//
//  Created by Taegon Kim on 11/01/2017.
//  Copyright © 2017 Taegon Kim. All rights reserved.
//

import Foundation

extension AppDelegate {
    var version: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    }
    
    var buildNumber: String {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as! String
    }
}
