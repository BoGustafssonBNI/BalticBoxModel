//
//  boxWindowController.swift
//  boxModel
//
//  Created by Bo Gustafsson on 29/04/16.
//  Copyright © 2016 BNI. All rights reserved.
//

import Cocoa

class boxWindowController: NSWindowController {

    @IBOutlet weak var mainWindow: NSWindow! {
        didSet {
            mainWindow.backgroundColor = NSColor.white
            mainWindow.title = "Baltic Box Model"
        }
    }
    override func windowDidLoad() {
        super.windowDidLoad()
        let center = NotificationCenter.default
        let queue = OperationQueue.main
        center.addObserver(forName: NSNotification.Name(rawValue: PRINT.Notification), object: nil, queue: queue) { notification in
            self.mainWindow.printWindow(self.mainWindow)
            
            
        }
    }
    
}
