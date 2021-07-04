//
//  PrefTabViewController.swift
//  Highlight
//
//  Created by Thomas Di Meco on 15/06/2021.
//  Copyright © 2021 Taegon Kim. All rights reserved.
//

import Cocoa

class PrefTabViewController: NSTabViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Better tab icons for macOS Big Sur
        if #available(macOS 11.0, *) {
            tabView.tabViewItems[0].image = NSImage(systemSymbolName: "gearshape", accessibilityDescription: nil)
            tabView.tabViewItems[1].image = NSImage(systemSymbolName: "chevron.left.slash.chevron.right", accessibilityDescription: nil)
            tabView.tabViewItems[2].image = NSImage(systemSymbolName: "paintbrush", accessibilityDescription: nil)
            tabView.tabViewItems[3].image = NSImage(systemSymbolName: "info.circle", accessibilityDescription: nil)
        }
    }
}
