//
//  GeneralPreferencesViewController.swift
//  Highlight
//
//  Created by Taegon Kim on 08/01/2017.
//  Copyright © 2017 Taegon Kim. All rights reserved.
//

import Cocoa
import KeyHolder
import Magnet

class GeneralPreferencesViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate, UserSettings {
    
    @IBOutlet weak var recordView: RecordView!
    @IBOutlet weak var langs: NSTableView!
    
    var langNames:[String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        langNames = hlLanguages.keys.sorted()
        recordView.delegate = self
        recordView.borderColor = NSColor.windowFrameColor
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        recordView.keyCombo = hotkey
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
            button.state = NSOnState
        }

        return button
    }
    
    func selectLang(sender: AnyObject?) {
        guard let button = sender as? NSButton else { return }
        let lang = hlLanguages[button.title]!
        if button.state == NSOnState {
            addLang(lang: lang)
        } else {
            removeLang(lang: lang)
        }
    }
}

extension GeneralPreferencesViewController: RecordViewDelegate {
    func recordViewShouldBeginRecording(_ recordView: RecordView) -> Bool {
        return true
    }
    
    func recordView(_ recordView: RecordView, canRecordKeyCombo keyCombo: KeyCombo) -> Bool {
        return true
    }

    func recordViewDidClearShortcut(_ recordView: RecordView) {
        removeHotkey()
    }
    
    func recordViewDidEndRecording(_ recordView: RecordView) {
        guard let keycomb = recordView.keyCombo else {
            removeHotkey()
            return
        }

        saveHotkey(keycomb: keycomb)
    }
    
    func recordView(_ recordView: RecordView, didChangeKeyCombo keyCombo: KeyCombo) {
    }
}
