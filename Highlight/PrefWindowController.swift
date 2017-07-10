//
//  PrefWindowController.swift
//  Highlight
//
//  Created by Taegon Kim on 18/01/2017.
//  Copyright © 2017 Taegon Kim. All rights reserved.
//

import Cocoa

class PrefWindowController: NSWindowController, NSToolbarDelegate {
    
    @IBOutlet weak var toolbar: NSToolbar!

    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        
    }

    override func showWindow(_ sender: Any?) {
        var frame = window?.frame

        if frame != nil {
            frame?.size.width = CGFloat( 550 )
            frame?.size.height = CGFloat( 500 )
            window?.setFrame(frame!, display: false)
        }

        super.showWindow(self)
    }

}
