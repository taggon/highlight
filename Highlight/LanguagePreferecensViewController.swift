//
//  LanguagePreferecensViewController.swift
//  Highlight
//
//  Created by Taegon Kim on 09/07/2017.
//  Copyright © 2017 Taegon Kim. All rights reserved.
//

import Cocoa

class LanguagePreferecensViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate, UserSettings {

    @IBOutlet weak var langs: NSTableView!
    
    var langNames:[String] = []

    private var appDelegate: AppDelegate {
        return NSApplication.shared.delegate as! AppDelegate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        langNames = hlLanguages.keys.sorted()
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return Int(ceil(Float(hlLanguages.count) / Float(tableView.tableColumns.count)))
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let button = NSButton()
        let index = row  * tableView.tableColumns.count + Int(tableColumn!.title)!
        
        if index > hlLanguages.count - 1 {
            return nil
        }
        
        let name = langNames[ index ]
        
        button.title = name
        button.setButtonType(.switch)
        button.lineBreakMode = .byTruncatingTail
        button.action = #selector(selectLang)
        
        let selectedLangs = userLangs
        
        if selectedLangs.contains(hlLanguages[name]!) {
            button.state = NSControl.StateValue.on
        }
        
        return button
    }
    
    @objc func selectLang(sender: AnyObject?) {
        guard let button = sender as? NSButton else { return }
        let lang = hlLanguages[button.title]!
        if button.state == NSControl.StateValue.on {
            addLang(lang: lang)
        } else {
            removeLang(lang: lang)
        }
        appDelegate.drawLangMenu()
    }
}
