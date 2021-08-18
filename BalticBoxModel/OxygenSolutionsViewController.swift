//
//  OxygenSolutionsViewController.swift
//  boxModel
//
//  Created by Bo Gustafsson on 19/05/16.
//  Copyright © 2016 BNI. All rights reserved.
//

import Cocoa
import CorePlot

class OxygenSolutionsViewController: NSViewController {
    
    fileprivate var o2Data = [Double]()
    var funcData = [Double]()
    let plotGenerator = PlotGenerator()

    @IBOutlet var plotView: NSView!
    
    @IBOutlet weak var graphView: CPTGraphHostingView!

    fileprivate var saveObserver : NSObjectProtocol?
    fileprivate var oxygenObserver : NSObjectProtocol?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let size = CGSize(width: plotView.bounds.width * 0.5, height: plotView.bounds.height)
        let rect = NSRect(origin: plotView.bounds.origin, size: size)
        plotView.wantsLayer = true
        
        graphView.printRect = rect
        let center = NotificationCenter.default
        let queue = OperationQueue.main
        
        oxygenObserver = center.addObserver(forName: NSNotification.Name(rawValue: OXYGENSOLUTION.Notification), object: nil, queue: queue)  { notification in
            if let o2 = (notification as NSNotification).userInfo?[OXYGENSOLUTION.OxygenValues] as? [Double] {
                self.o2Data = o2
            } else {
                self.o2Data.removeAll()
            }
            if let f = (notification as NSNotification).userInfo?[OXYGENSOLUTION.FValues] as? [Double] {
                self.funcData = f
            } else {
                self.funcData.removeAll()
            }
            if self.funcData.count * self.o2Data.count > 0 {self.plotData()}
        }
        saveObserver = center.addObserver(forName: NSNotification.Name(rawValue: SAVE.Notification), object: nil, queue: queue) { [weak self] notification in
            if let myExporter = (notification as NSNotification).userInfo?[SAVE.ExporterInstance] as? ExportData {
                do {
                    let pdfData = self?.graphView.hostedGraph!.dataForPDFRepresentationOfLayer()
                    try pdfData?.write(to: URL(fileURLWithPath: myExporter.outputPath + "/OxygenSolutionsPlots" + ".pdf"), options: [.atomic])
                } catch {
                    print("PDF write failed")
                }
                do {
                    let epsData = self?.plotView.dataWithEPS(inside: (self?.plotView.bounds)!)
                    try epsData?.write(to: URL(fileURLWithPath: myExporter.outputPath + "/OxygenSolutionsPlots" + ".eps"), options: [.atomic])
                } catch {
                    print("EPS write failed")
                }
            }
        }
    }
    override func viewWillAppear() {
        super.viewWillAppear()
        plotView.layer?.backgroundColor = NSColor.white.cgColor
    }
    
/*    override func viewDidDisappear() {
        let center = NSNotificationCenter.defaultCenter()
        center.removeObserver(saveObserver!)
        center.removeObserver(oxygenObserver!)
    }
    */
    fileprivate func plotData() {
        let plotData = prepareDataForPlot(o2Data, yValues: funcData)
        plotGenerator.plotSettings.legend = false
        plotGenerator.plotSettings.xAxisTitle = "Oxygen (x)"
        plotGenerator.plotSettings.yAxisTitle = "f(x)"
        plotGenerator.plottingData = plotData.plottingData
        plotGenerator.makePlot(graphView, xyLimits: plotData.limits, variableNames: ["Function"])
    }
    
    fileprivate func prepareDataForPlot(_ xValues: [Double], yValues: [Double]) -> (limits: XYLimits, plottingData: [Int: [Point]]) {
        var plottingData = [Int: [Point]]()
        let xmin = xValues.first!
        let xmax = xValues.last!
        var ymax = -1.0e10
        var ymin = 1.0e10
        var temp = [Point]()
        for j in 0..<yValues.count {
            temp.append(Point(x: xValues[j], y: yValues[j]))
            ymin = min(ymin, yValues[j])
            ymax = max(ymax, yValues[j])
        }
        plottingData[0] = temp
        
        ymax = ymax + 0.1 * (ymax - ymin)
        ymin = ymin - 0.1 * (ymax - ymin)
        if abs(ymax) > 0 {
            if abs(ymax - ymin)/abs(ymax) < 1.0e-4 {
                ymax = ymax * 1.2
                ymin = ymin * 0.8
            }
        }
        
        return (XYLimits(min: Point(x: xmin, y: ymin), max: Point(x: xmax, y: ymax)), plottingData)
    }
    
    
}
