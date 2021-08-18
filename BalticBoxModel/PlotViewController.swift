//
//  PlotViewController.swift
//  iPLCData
//
//  Created by Bo Gustafsson on 24/04/16.
//  Copyright © 2016 BNI. All rights reserved.
//

import Cocoa
import CorePlot

class PlotViewController: NSViewController {

    var dataToPlot = [[Double]]()
    var variables = [[Int]]()
    var variableNames = [[String]]()
    let topleftPG = PlotGenerator()
    let topRightPG = PlotGenerator()
    let lowerLeftPG = PlotGenerator()
    let lowerRightPG = PlotGenerator()
    
    @IBOutlet var plotView: NSView!
    @IBOutlet weak var topLeftView: CPTGraphHostingView!
    @IBOutlet weak var topRightView: CPTGraphHostingView!
    @IBOutlet weak var lowerLeftView: CPTGraphHostingView!
    @IBOutlet weak var lowerRightView: CPTGraphHostingView!
    
    @IBOutlet weak var spinner: NSProgressIndicator!

    fileprivate var saveObserver : NSObjectProtocol?
    fileprivate var modelStartedObserver : NSObjectProtocol?
    fileprivate var modelReadyObserver : NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let size = CGSize(width: plotView.bounds.width, height: plotView.bounds.height)
        let rect = NSRect(origin: plotView.bounds.origin, size: size)
        plotView.wantsLayer = true
        topLeftView.printRect = rect
        lowerLeftView.printRect = rect
        topRightView.printRect = rect
        lowerRightView.printRect = rect
        
        let center = NotificationCenter.default
        let queue = OperationQueue.main
        
        modelStartedObserver = center.addObserver(forName: NSNotification.Name(rawValue: MODELSTARTED.Notification), object: nil, queue: queue)  { [weak weakself = self] notification in
            if let started = (notification as NSNotification).userInfo?[MODELSTARTED.StartedKey] as? Bool {
                if started {
                    weakself!.spinner.startAnimation(weakself!.spinner)
                }
            }
        }
        modelReadyObserver = center.addObserver(forName: NSNotification.Name(rawValue: MODELREADY.Notification), object: nil, queue: queue)  { [weak weakself = self] notification in
            if let ready = (notification as NSNotification).userInfo?[MODELREADY.ReadyKey] as? Bool {
                if ready {
                    weakself!.spinner.stopAnimation(weakself!.spinner)
                    if let data = (notification as NSNotification).userInfo?[MODELREADY.Key] as? [[Double]] {
                        weakself!.dataToPlot = data
                        if let vars = (notification as NSNotification).userInfo?[MODELREADY.VariablesKey] as? [[Int]] {
                            weakself!.variables = vars
                            if let names = (notification as NSNotification).userInfo?[MODELREADY.NamesKey] as? [[String]] {
                                weakself!.variableNames = names
                                weakself!.plotData()
                            }
                        }
                    }
                }
            }
        }
        saveObserver = center.addObserver(forName: NSNotification.Name(rawValue: SAVE.Notification), object: nil, queue: queue) { [weak weakself = self] notification in
            if let myExporter = (notification as NSNotification).userInfo?[SAVE.ExporterInstance] as? ExportData {
                var pdfData = weakself!.topLeftView.hostedGraph!.dataForPDFRepresentationOfLayer()
                if !((try? pdfData.write(to: URL(fileURLWithPath: myExporter.outputPath + "/tpConc" + ".pdf"), options: [.atomic])) != nil) {
                    print("PDF write failed")
                }
                pdfData = weakself!.topRightView.hostedGraph!.dataForPDFRepresentationOfLayer()
                if !((try? pdfData.write(to: URL(fileURLWithPath: myExporter.outputPath + "/O2Conc" + ".pdf"), options: [.atomic])) != nil) {
                    print("PDF write failed")
                }
                pdfData = weakself!.lowerLeftView.hostedGraph!.dataForPDFRepresentationOfLayer()
                if !((try? pdfData.write(to: URL(fileURLWithPath: myExporter.outputPath + "/BCarbon" + ".pdf"), options: [.atomic])) != nil) {
                    print("PDF write failed")
                }
                pdfData = weakself!.lowerRightView.hostedGraph!.dataForPDFRepresentationOfLayer()
                if !((try? pdfData.write(to: URL(fileURLWithPath: myExporter.outputPath + "/BPhos" + ".pdf"), options: [.atomic])) != nil) {
                    print("PDF write failed")
                }
                let epsData = weakself!.plotView.dataWithEPS(inside: weakself!.plotView.bounds)
                if !((try? epsData.write(to: URL(fileURLWithPath: myExporter.outputPath + "/plots" + ".eps"), options: [.atomic])) != nil) {
                    print("EPS write failed")
                }
            }
        }
        
        
/*         center.addObserverForName(PRINT.Notification, object: nil, queue: queue) { [unowned self] notification in
            self.plotView.print(self.plotView)
         }
*/      
    }
    override func viewWillAppear() {
        super.viewWillAppear()
        plotView.layer?.backgroundColor = NSColor.white.cgColor
    }
/*    override func viewDidDisappear() {
        let center = NSNotificationCenter.defaultCenter()
        center.removeObserver(saveObserver!)
        center.removeObserver(modelReadyObserver!)
        center.removeObserver(modelStartedObserver!)
    }
*/    
    
    fileprivate func plotData() {
        makeOnePlot(topLeftView, plotGenerator: topleftPG, data: dataToPlot, vars: variables[0], names: variableNames[0])
        makeOnePlot(topRightView, plotGenerator: topRightPG, data: dataToPlot, vars: variables[1], names: variableNames[1])
        makeOnePlot(lowerLeftView, plotGenerator: lowerLeftPG, data: dataToPlot, vars: variables[2], names: variableNames[2])
        makeOnePlot(lowerRightView, plotGenerator: lowerRightPG, data: dataToPlot, vars: variables[3], names: variableNames[3])
    }
    fileprivate func makeOnePlot(_ view: CPTGraphHostingView, plotGenerator: PlotGenerator, data: [[Double]], vars: [Int], names: [String]) {
        let prepareResult = prepareDataForPlot(data, variablesToPlot: vars)
        let plottingData = prepareResult.plottingData
        let limits = prepareResult.limits
        plotGenerator.plotSettings.xAxisTitle = "time"
        plotGenerator.plotSettings.yAxisTitle = names.joined(separator: " ")
        plotGenerator.plottingData = plottingData
        plotGenerator.makePlot(view, xyLimits: limits, variableNames: names)
    }
    
    fileprivate func prepareDataForPlot(_ dataToPlot : [[Double]], variablesToPlot : [Int]) -> (limits: XYLimits, plottingData: [Int: [Point]]) {
        var plottingData = [Int: [Point]]()
        let xmin = (dataToPlot.first!.first)!
        let xmax = dataToPlot.last!.first!
        var ymax = -1.0e10
        var ymin = 1.0e10
        var k = 0
        for vars in variablesToPlot {
            var temp = [Point]()
            for j in 0..<dataToPlot.count {
                temp.append(Point(x: dataToPlot[j][0], y: dataToPlot[j][vars]))
                ymin = min(ymin, dataToPlot[j][vars])
                ymax = max(ymax, dataToPlot[j][vars])
            }
            plottingData[k] = temp
            k += 1
        }
        
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
