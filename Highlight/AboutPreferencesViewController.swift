//
//  AboutPreferencesViewController.swift
//  Highlight
//
//  Created by Taegon Kim on 08/01/2017.
//  Copyright © 2017 Taegon Kim. All rights reserved.
//

import Cocoa

class AboutPreferencesViewController: NSViewController {
    
    @IBOutlet weak var versionField: NSTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = NSApplication.shared.delegate as! AppDelegate
        versionField.stringValue = "Version \(appDelegate.version) (Build \(appDelegate.buildNumber))"
    }

}
