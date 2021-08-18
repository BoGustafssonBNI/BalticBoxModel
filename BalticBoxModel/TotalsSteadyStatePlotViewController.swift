//
//  TotalsSteadyStatePlotViewController.swift
//  BalticBoxModel
//
//  Created by Bo Gustafsson on 2017-01-12.
//  Copyright © 2017 Bo Gustafsson. All rights reserved.
//

import Cocoa
import CorePlot

class TotalsSteadyStatePlotViewController: NSViewController {
    var dataToPlot = [[[Double]]]()
    var stability = [[Bool]]()
    var variables = [[Int]]()
    var variableNames = [[String]]()
    var parameterName = ""
    let topleftPG = SteadyStatePlotGenerator()
    let topRightPG = SteadyStatePlotGenerator()
    let lowerLeftPG = SteadyStatePlotGenerator()
    let lowerRightPG = SteadyStatePlotGenerator()

    @IBOutlet var plotView: NSView!
    
    @IBOutlet weak var topRightView: CPTGraphHostingView!
    @IBOutlet weak var lowerRightView: CPTGraphHostingView!
    @IBOutlet weak var lowerLeftView: CPTGraphHostingView!
    @IBOutlet weak var topLeftView: CPTGraphHostingView!
    
    
    fileprivate var saveObserver : NSObjectProtocol?
    fileprivate var steadyStateObserver : NSObjectProtocol?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        plotView.printRect = plotView.bounds
        let size = CGSize(width: plotView.bounds.width * 0.5, height: plotView.bounds.height)
        let rect = NSRect(origin: plotView.bounds.origin, size: size)
        plotView.wantsLayer = true
        
        topLeftView.printRect = rect
        lowerLeftView.printRect = rect
        topRightView.printRect = rect
        lowerRightView.printRect = rect
        
        
        let center = NotificationCenter.default
        let queue = OperationQueue.main
        
        steadyStateObserver = center.addObserver(forName: NSNotification.Name(rawValue: STEADYSTATEREADY.Notification), object: nil, queue: queue)  { notification in
            if let data = (notification as NSNotification).userInfo?[STEADYSTATEREADY.TotalsResults] as? [[[Double]]] {
                self.dataToPlot = data
            } else {
                self.dataToPlot.removeAll()
            }
            if let data = (notification as NSNotification).userInfo?[STEADYSTATEREADY.StabilityResults] as? [[Bool]] {
                self.stability = data
            } else {
                self.stability.removeAll()
            }
            if let vars = (notification as NSNotification).userInfo?[STEADYSTATEREADY.TotalsVariables] as? [[Int]] {
                self.variables = vars
                if let names = (notification as NSNotification).userInfo?[STEADYSTATEREADY.TotalsVarNames] as? [[String]] {
                    self.variableNames = names
                    if let pName = (notification as NSNotification).userInfo?[STEADYSTATEREADY.NameOfParameter] as? String {
                        self.parameterName = pName
                        self.plotData()
                    }
                }
            }
        }
        saveObserver = center.addObserver(forName: NSNotification.Name(rawValue: SAVE.Notification), object: nil, queue: queue) { notification in
            if let myExporter = (notification as NSNotification).userInfo?[SAVE.ExporterInstance] as? ExportData {
                let pdfData = self.plotView.dataWithPDF(inside: self.plotView.bounds)
                if !((try? pdfData.write(to: URL(fileURLWithPath: myExporter.outputPath + "/SteadyStateTotalsplots" + ".pdf"), options: [.atomic])) != nil) {
                    print("PDF write failed")
                }
                let epsData = self.plotView.dataWithEPS(inside: self.plotView.bounds)
                if !((try? epsData.write(to: URL(fileURLWithPath: myExporter.outputPath + "/SteadyStateTotalsplots" + ".eps"), options: [.atomic])) != nil) {
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
     center.removeObserver(steadyStateObserver!)
     }
     */
    
    fileprivate func plotData() {
        makeOnePlot(topLeftView, plotGenerator: topleftPG, data: dataToPlot, stability: stability, vars: variables[0], names: variableNames[0])
        makeOnePlot(topRightView, plotGenerator: topRightPG, data: dataToPlot, stability: stability, vars: variables[1], names: variableNames[1])
        makeOnePlot(lowerLeftView, plotGenerator: lowerLeftPG, data: dataToPlot, stability: stability, vars: variables[2], names: variableNames[2])
        makeOnePlot(lowerRightView, plotGenerator: lowerRightPG, data: dataToPlot, stability: stability, vars: variables[3], names: variableNames[3])
    }
    
    fileprivate func makeOnePlot(_ view: CPTGraphHostingView, plotGenerator: SteadyStatePlotGenerator, data: [[[Double]]], stability: [[Bool]], vars: [Int], names: [String]) {
        let prepareResult = prepareDataForPlot(data, stabilityData: stability, variablesToPlot: vars)
        let plottingData = prepareResult.plottingData
        let limits = prepareResult.limits
        let plottingVariables = prepareResult.plottingVariables
        plotGenerator.plottingData = plottingData
        plotGenerator.plottingStability = prepareResult.plottingStability
        plotGenerator.xAxisTitle = self.parameterName
        plotGenerator.makePlot(view, xyLimits: limits, variableNames: names, plottingVariables: plottingVariables)
    }
    fileprivate func prepareDataForPlot(_ data : [[[Double]]], stabilityData: [[Bool]], variablesToPlot : [Int]) -> (limits: XYLimits, plottingData: [Int: [Point]], plottingStability: [Int: [Bool]], plottingVariables: [Int]) {
        var plottingData = [Int: [Point]]()
        var plottingStability = [Int: [Bool]]()
        
        var xmin = 1.0e10
        var xmax = -1.0e10
        var ymax = -1.0e10
        var ymin = 1.0e10
        var plottingVariables = [Int]()
        
        var k = 0
        var n = 0
        for vars in variablesToPlot {
            // data[x][solution][variable]
            var temp = [Int: [Point]]()
            var stemp = [Int: [Bool]]()
            var imax = 0
            var l = 0
            for result in data { //Loop over "x" point
                for i in 0..<result.count { //Loop over multiple solutions for given "x"
                    let solution = result[i]
                    let stab = stability[l][i]
                    if solution.count > 0 {
                        if var ta = temp[i] {
                            ta.append(Point(x: solution[0], y: solution[vars]))
                            temp[i] = ta
                        } else {
                            let ta = [Point(x: solution[0], y: solution[vars])]
                            temp[i] = ta
                        }
                        if var st = stemp[i] {
                            st.append(stab)
                            stemp[i] = st
                        } else {
                            let ts = [stab]
                            stemp[i] = ts
                        }
                        xmin = min(xmin, solution[0])
                        xmax = max(xmax, solution[0])
                        ymin = min(ymin, solution[vars])
                        ymax = max(ymax, solution[vars])
                        imax = max(i, imax)
                    }
                }
                l += 1
            }
            for i in 0...imax {
                if let pd = temp[i] {
                    if pd.count > 0 {
                        plottingData[k] = pd
                        plottingStability[k] = stemp[i]
                        plottingVariables.append(n)
                        k += 1
                    }
                }
            }
            n += 1
        }
        
        ymax = ymax + 0.1 * (ymax - ymin)
        ymin = ymin - 0.1 * (ymax - ymin)
        if abs(ymax) > 0 {
            if abs(ymax - ymin)/abs(ymax) < 1.0e-4 {
                ymax = ymax * 1.2
                ymin = ymin * 0.8
            }
        }
        
        return (XYLimits(min: Point(x: xmin, y: ymin), max: Point(x: xmax, y: ymax)), plottingData, plottingStability, plottingVariables)
    }
    
}
