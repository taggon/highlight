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

class GeneralPreferencesViewController: NSViewController, UserSettings {
    
    @IBOutlet weak var recordView: RecordView!
    @IBOutlet weak var toggleLineNumbers: NSButton!
    @IBOutlet weak var spacesAfterLineNumber: NSTextField!
    @IBOutlet weak var spacesAfterLineNumberStepper: NSStepper!

    override func viewDidLoad() {
        super.viewDidLoad()
        recordView.delegate = self
        recordView.borderColor = NSColor.windowFrameColor
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()

        recordView.keyCombo = hotkey
        spacesAfterLineNumberStepper.integerValue = lineNumberPadding
        spacesAfterLineNumber.integerValue = spacesAfterLineNumberStepper.integerValue
        updateToggleLineNumbers()

        NotificationCenter.default.addObserver(self, selector: #selector(defaultsDidChange), name: UserDefaults.didChangeNotification, object: nil)
    }

    override func viewWillDisappear() {
        NotificationCenter.default.removeObserver(self)

        super.viewWillDisappear()
    }

    @objc func defaultsDidChange(notification: Notification) {
        updateToggleLineNumbers()
    }

    func updateToggleLineNumbers() {
        toggleLineNumbers.state = showLineNumbers ? NSControl.StateValue.on : NSControl.StateValue.off
    }

    @IBAction func toggleLineNumbersDidChange(sender: AnyObject) {
        saveShowLineNumbers(display: toggleLineNumbers.state == NSControl.StateValue.on)
    }

    @IBAction func spacesAfterLineNumberDidChange(sender: AnyObject) {
        spacesAfterLineNumber.integerValue = (sender as! NSStepper).integerValue
        saveLineNumberPadding(numberOfSpaces: spacesAfterLineNumber.integerValue)
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
    
    func recordView(_ recordView: RecordView, didChangeKeyCombo keyCombo: KeyCombo?) {
    }
}
