//
//  SpectraPlotViewController.swift
//  BalticBoxModel
//
//  Created by Bo Gustafsson on 2017-01-16.
//  Copyright © 2017 Bo Gustafsson. All rights reserved.
//

import Cocoa
import CorePlot

class SpectraPlotViewController: NSViewController {
    
    fileprivate var o2Data = [Double]()
    var modelTimeInterval = 1.0
    var modelTimeSeries = [[Double]]()
    let plotGenerator = PlotGenerator()
    
    @IBOutlet var plotView: NSView!
    
    @IBOutlet weak var graphView: CPTGraphHostingView!
    
    fileprivate var saveObserver : NSObjectProtocol?
    fileprivate var modelReadyObserver : NSObjectProtocol?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let size = CGSize(width: plotView.bounds.width * 0.5, height: plotView.bounds.height)
        let rect = NSRect(origin: plotView.bounds.origin, size: size)
        plotView.wantsLayer = true
        
        graphView.printRect = rect
        let center = NotificationCenter.default
        let queue = OperationQueue.main
        
        modelReadyObserver = center.addObserver(forName: NSNotification.Name(rawValue: MODELREADY.Notification), object: nil, queue: queue)  { [weak weakself = self] notification in
            if let ready = (notification as NSNotification).userInfo?[MODELREADY.ReadyKey] as? Bool {
                if ready {
                    if let data = (notification as NSNotification).userInfo?[MODELREADY.Key] as? [[Double]] {
                        weakself!.modelTimeSeries = data
                        if let time1 = data.first?.first, let time2 = data[1].first {
                            weakself!.modelTimeInterval = time2 - time1
                        }
                        weakself!.plotData()
                    }
                }
            }
        }
        saveObserver = center.addObserver(forName: NSNotification.Name(rawValue: SAVE.Notification), object: nil, queue: queue) { [weak self] notification in
            if let myExporter = (notification as NSNotification).userInfo?[SAVE.ExporterInstance] as? ExportData {
                let url = URL.init(fileURLWithPath: myExporter.outputPath + "/Spectra.csv")
                self?.plotGenerator.exportData(to: url, variableNames: ["Spectra"])
                do {
                    let pdfData = self?.graphView.hostedGraph!.dataForPDFRepresentationOfLayer()
                    try pdfData?.write(to: URL(fileURLWithPath: myExporter.outputPath + "/Spectra" + ".pdf"), options: [.atomic])
                } catch {
                    print("PDF write failed")
                }
                do {
                    let epsData = self?.plotView.dataWithEPS(inside: (self?.plotView.bounds)!)
                    try epsData?.write(to: URL(fileURLWithPath: myExporter.outputPath + "/Spectra" + ".eps"), options: [.atomic])
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
        let myAnalyzer = TimeSeriesAnalysis()
        var o2TimeSeries = [Double]()
        for row in modelTimeSeries {
            o2TimeSeries.append(row[2])
        }
        let variance = myAnalyzer.variance(forSingleTimeSeries: o2TimeSeries)
        let spectra = myAnalyzer.spectra(singleVariance: variance, timeStep: modelTimeInterval)
        let period = spectra.period
        let power = spectra.power
        let plotData = prepareDataForPlot(period, yValues: power)
        plotGenerator.plotSettings.legend = false
        plotGenerator.plotSettings.xAxisTitle = "Period"
        plotGenerator.plotSettings.yAxisTitle = "Power"
        plotGenerator.plottingData = plotData.plottingData
        plotGenerator.makePlot(graphView, xyLimits: plotData.limits, variableNames: ["Power"])
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
