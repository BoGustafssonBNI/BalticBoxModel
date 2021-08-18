//
//  AppDelegate.swift
//  BalticBoxModel
//
//  Created by Bo Gustafsson on 2016-12-06.
//  Copyright © 2016 Bo Gustafsson. All rights reserved.
//

import Cocoa
struct SAVE {
    static let Notification = "Save notification"
    static let ExporterInstance = "Exporter"
    static let URL = "Save URL"
}
struct PRINT {
    static let Notification = "Print notification"
}
struct OPEN {
    static let Notification = "Open notification"
    static let URL = "Open URL"
}
struct NEW {
    static let Notification = "New notification"
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    
    @IBAction func newRun(_ sender: NSMenuItem) {
        let center = NotificationCenter.default
        let notification = Notification(name: Notification.Name(rawValue: NEW.Notification), object: self, userInfo: nil)
        center.post(notification)
    }
    
    @IBAction func preferences(_ sender: AnyObject) {
        
    }
    @IBAction func openFile(_ sender: NSMenuItem) {
        let op = NSOpenPanel()
        op.canChooseDirectories = false
        op.canChooseFiles = true
        op.allowsMultipleSelection = false
        op.canCreateDirectories = false
        op.begin { (result) -> Void in
            if result == NSApplication.ModalResponse.OK {
                let url = op.url
                let center = NotificationCenter.default
                let notification = Notification(name: Notification.Name(rawValue: OPEN.Notification), object: self, userInfo: [OPEN.URL: url!])
                center.post(notification)
            }
        }
    }
    
    @IBAction func saveRun(_ sender: NSMenuItem) {
        let myExporter = ExportData()
        let savePanel = NSSavePanel()
        savePanel.allowedFileTypes = ["csv"]
        savePanel.allowsOtherFileTypes = false
        savePanel.canCreateDirectories = true
        savePanel.directoryURL = URL(string: myExporter.outputPath)
        savePanel.begin  { (result) -> Void in
            if result == NSApplication.ModalResponse.OK {
                let url = savePanel.url
                let center = NotificationCenter.default
                let notification = Notification(name: Notification.Name(rawValue: SAVE.Notification), object: self, userInfo: [SAVE.URL: url!, SAVE.ExporterInstance: myExporter])
                center.post(notification)
            }
        }
    }
    
    
    @IBAction func printRun(_ sender: NSMenuItem) {
        let center = NotificationCenter.default
        let notification = Notification(name: Notification.Name(rawValue: PRINT.Notification), object: self, userInfo: nil)
        center.post(notification)
    }
    
}

