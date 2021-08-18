//
//  SteadyStatePlotGenerator.swift
//  boxModel
//
//  Created by Bo Gustafsson on 07/05/16.
//  Copyright © 2016 BNI. All rights reserved.
//

import Foundation
import Cocoa
import CorePlot


class SteadyStatePlotGenerator: NSObject, CPTPlotDataSource, CPTPlotSpaceDelegate, CPTScatterPlotDataSource {
    
    var plottingData = [Int: [Point]]()
    var plottingStability = [Int: [Bool]]()
    var xAxisTitle = ""
    
    func exportData(to url: URL, variableNames : [String]) {
        let plotNumbers = [Int](plottingStability.keys).sorted()
        var string = ""
        var keepOnWriting = true
        var row = 0
        repeat {
            keepOnWriting = false
            if row == 0 {
                for plot in plotNumbers {
                    string += (plot == 0 ? xAxisTitle + ";" : "") + variableNames[plot] + ";Stability" + (plot == plotNumbers.last! ? "\n" : ";")
                }
            }
            for plot in plotNumbers {
                if let data = plottingData[plot], data.count > row, let stability = plottingStability[plot] {
                    string += (plot == 0 ? String(data[row].x) + ";" : "") + String(data[row].y) + ";" + (stability[row] ? "1" : "0") + (plot == plotNumbers.last! ? "\n" : ";")
                    keepOnWriting = true
                } else {
                    string += (plot == 0 ? ";": "") + ";" + (plot == plotNumbers.last! ? "\n" : ";")
                }
            }
            row += 1
        } while keepOnWriting
        try? string.write(to: url, atomically: true, encoding: String.Encoding.isoLatin1)
    }
    
    func makePlot(_ hostview: CPTGraphHostingView, xyLimits: XYLimits, variableNames: [String], plottingVariables: [Int]){
        hostview.autoresizesSubviews = true
        hostview.allowPinchScaling = true
        
        
        let plotBounds = CGRect(x: hostview.frame.origin.x + hostview.frame.size.width * 0.0, y: hostview.frame.origin.y + hostview.frame.size.height * 0.0, width: hostview.frame.size.width * 1, height: hostview.frame.size.height * 1)
        //        let plotBounds = CGRect(x: hostview.bounds.origin.x + hostview.bounds.size.width * 0.0, y: hostview.bounds.origin.y + hostview.bounds.size.height * 0.0, width: hostview.bounds.size.width * 1, height: hostview.bounds.size.height * 1)
        let mygraph = CPTXYGraph(frame: plotBounds)
        let theme = CPTTheme(named: CPTThemeName.plainWhiteTheme)
        mygraph.apply(theme)
        mygraph.plotAreaFrame!.paddingTop    = mygraph.bounds.size.height * 0.05
        mygraph.plotAreaFrame!.paddingBottom = mygraph.bounds.size.height * 0.175
        mygraph.plotAreaFrame!.paddingLeft   = mygraph.bounds.size.width * 0.175
        mygraph.plotAreaFrame!.paddingRight  = mygraph.bounds.size.width * 0.025
        mygraph.plotAreaFrame!.cornerRadius  = 10.0
        mygraph.plotAreaFrame!.masksToBorder = false
        mygraph.plotAreaFrame!.borderLineStyle = nil
        
        let plotSpace = mygraph.defaultPlotSpace as! CPTXYPlotSpace
        let xRange = CPTPlotRange(location: NSNumber(value: xyLimits.min.x), length: NSNumber(value: xyLimits.max.x - xyLimits.min.x))
        plotSpace.xRange = xRange
        let yRange = CPTPlotRange(location: NSNumber(value: xyLimits.min.y), length: NSNumber(value: xyLimits.max.y - xyLimits.min.y))
        plotSpace.yRange = yRange
        plotSpace.delegate = self
        plotSpace.allowsUserInteraction = true
        let majorGridLineStyle = CPTMutableLineStyle()
        majorGridLineStyle.lineWidth = 1.0
        majorGridLineStyle.lineColor = CPTColor.gray().withAlphaComponent(0.7)
        let minorGridLineStyle = CPTMutableLineStyle()
        minorGridLineStyle.lineWidth = 1.0
        minorGridLineStyle.lineColor = CPTColor.gray().withAlphaComponent(0.2)
        
        let axisSet = mygraph.axisSet as! CPTXYAxisSet
        let textStyle = CPTMutableTextStyle()
        if let x = axisSet.xAxis {
            x.orthogonalPosition    = xyLimits.min.y as NSNumber?
            x.labelingPolicy = .automatic
            x.labelingOrigin = 0.0
            textStyle.fontSize = 12
            x.labelTextStyle = textStyle
            x.title = xAxisTitle
            x.titleTextStyle = textStyle
            x.titleOffset = mygraph.bounds.size.height * 0.075
            let format = NumberFormatter()
            if xyLimits.max.x > 10 {
                format.numberStyle = .none
            } else {
                format.numberStyle = .decimal
            }
            x.labelFormatter = format
            x.tickLabelDirection = .negative
            x.majorGridLineStyle = majorGridLineStyle
            x.minorGridLineStyle = minorGridLineStyle
        }
        if let y = axisSet.yAxis {
            let format = NumberFormatter()
            if xyLimits.max.y > 10 {
                format.numberStyle = .none
            } else {
                format.numberStyle = .decimal
            }
            y.labelFormatter = format
            textStyle.fontSize = 12
            y.labelTextStyle = textStyle
            y.orthogonalPosition    = xyLimits.min.x as NSNumber?
            y.majorGridLineStyle = majorGridLineStyle
            y.minorGridLineStyle = minorGridLineStyle
            y.labelingPolicy = .automatic
            y.title = variableNames[0] //.uppercased
            textStyle.fontSize = 12
            y.titleTextStyle = textStyle
            y.titleOffset = mygraph.bounds.size.width * 0.075
        }
        axisSet.xAxis?.axisConstraints = CPTConstraints.constraint(withLowerOffset: 0.0)
        axisSet.yAxis?.axisConstraints = CPTConstraints.constraint(withLowerOffset: 0.0)
        
        let colors = [CPTColor.black(), CPTColor.blue(), CPTColor.orange(), CPTColor.gray(),CPTColor.cyan(), CPTColor.darkGray(),CPTColor.green(), CPTColor.brown(), CPTColor.red()]
        var dataSourceLinePlot = [CPTScatterPlot]()
        for j in 0..<plottingVariables.count {
            dataSourceLinePlot.append(CPTScatterPlot(frame: CGRect.zero))
            dataSourceLinePlot[j].identifier = String(j) as (NSCoding & NSCopying & NSObjectProtocol)?
            let lineStyle = dataSourceLinePlot[j].dataLineStyle!.mutableCopy() as! CPTMutableLineStyle
            lineStyle.lineWidth = 2.0
            lineStyle.lineColor = colors[plottingVariables[j]]
            let symbolStyle = CPTPlotSymbol()
            symbolStyle.fill? = CPTFill(color: colors[plottingVariables[j]])
            symbolStyle.symbolType = .cross
            symbolStyle.lineStyle = CPTLineStyle(style: lineStyle)
            symbolStyle.size = CGSize(width: 6.0, height: 6.0)
            dataSourceLinePlot[j].plotSymbol = symbolStyle
//            if j > 0 && plottingVariables[j] == plottingVariables[j-1] {lineStyle.dashPattern = [20,20]}
            dataSourceLinePlot[j].dataLineStyle = lineStyle
            dataSourceLinePlot[j].dataSource = self
            dataSourceLinePlot[j].title = variableNames[plottingVariables[j]]
            mygraph.add(dataSourceLinePlot[j])
        }
        let legend = CPTLegend(plots: dataSourceLinePlot)
        legend.numberOfRows = 2
        mygraph.legend = legend
        
        hostview.hostedGraph = mygraph
        
    }
    
    func numberOfRecords(for plot: CPTPlot) -> UInt
    {
        if let pl = plot.identifier as? String {
            if let iplot = Int(pl) {
                return UInt(self.plottingData[iplot]!.count)
            }
        }
        return UInt(0)
        
    }
    func symbols(for plot: CPTScatterPlot, recordIndexRange indexRange: NSRange) -> [CPTPlotSymbol]? {
        var symbols = [CPTPlotSymbol]()
        if let cplot = plot.identifier as? String {
            if let iplot = Int(cplot) {
                let i0  = indexRange.location
                let l = indexRange.length
                for i in i0..<i0 + l {
                if self.plottingStability[iplot]![i] {
                    let symbolStyle = plot.plotSymbol?.copy() as! CPTPlotSymbol
                    let lineStyle = plot.dataLineStyle?.mutableCopy() as! CPTMutableLineStyle
                    symbolStyle.symbolType = .cross
                    symbolStyle.fill = CPTFill(color: lineStyle.lineColor!)
                    symbolStyle.lineStyle = CPTLineStyle(style: lineStyle)
                    symbols.append(symbolStyle)
                } else {
                    let symbolStyle = plot.plotSymbol?.copy() as! CPTPlotSymbol
                    let lineStyle = plot.dataLineStyle?.mutableCopy() as! CPTMutableLineStyle
                    symbolStyle.symbolType = .rectangle
                    symbolStyle.fill = CPTFill(color: CPTColor.red())
                    lineStyle.lineColor = CPTColor.red()
                    symbolStyle.lineStyle = CPTLineStyle(style: lineStyle)
                    symbols.append(symbolStyle)
                }
                }
            }
        }
        return symbols
    }
    
    func number(for plot: CPTPlot, field fieldEnum: UInt, record idx: UInt) -> Any? {
        switch CPTScatterPlotField(rawValue: Int(fieldEnum))! {
        case .X:
            if let pl = plot.identifier as? String {
                if let iplot = Int(pl) {
                    return self.plottingData[iplot]![Int(idx)].x as NSNumber
                }
            }
            return nil
        case .Y:
            if let pl = plot.identifier as? String {
                if let iplot = Int(pl) {
                    return self.plottingData[iplot]![Int(idx)].y as NSNumber
                }
            }
            return nil
        @unknown default:
            return nil
        }
    }
    

    
    
    func plotSpace(_ space: CPTPlotSpace, shouldScaleBy interactionScale: CGFloat, aboutPoint interactionPoint: CGPoint) -> Bool {
        return true
    }
    
    
}
