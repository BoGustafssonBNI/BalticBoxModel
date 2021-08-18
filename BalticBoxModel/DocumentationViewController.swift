//
//  DocumentationViewController.swift
//  boxModel
//
//  Created by Bo Gustafsson on 24/05/16.
//  Copyright © 2016 BNI. All rights reserved.
//

import Cocoa
import Quartz

class DocumentationViewController: NSViewController {

    @IBOutlet weak var pdfDocumentView: PDFView! {
        didSet {
            let myBundle = Bundle.main
            let pathFile = myBundle.resourcePath! + "/BoxModelManual.pdf"
            let url = URL(fileURLWithPath: pathFile)
            let document = PDFDocument(url: url)
            pdfDocumentView.document = document
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
