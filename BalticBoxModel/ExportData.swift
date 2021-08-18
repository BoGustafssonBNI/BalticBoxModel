//
//  ExportData.swift
//  plcDataReader
//
//  Created by Bo Gustafsson on 18/01/16.
//  Copyright © 2016 Bo Gustafsson. All rights reserved.
//

import Foundation

class ExportData {
    var outputPath = String()
    var runID = "0"
    init() {
        let myFilemanager = FileManager.default
        outputPath = NSHomeDirectory() + "/Documents/boxModel"
        if !myFilemanager.fileExists(atPath: outputPath) {
            do {
                try myFilemanager.createDirectory(atPath: outputPath, withIntermediateDirectories: false, attributes: nil)
            } catch {
                print(error)
            }
        } else {
            let filename = outputPath + "/RunLog.txt"
            do {
                let oldrun = try String.init(contentsOfFile: filename)
                if let i = Int(oldrun) {
                    runID = String(i + 1)
                }
            } catch {
                print("No old run")
            }
            do {
                try runID.write(toFile: filename, atomically: true, encoding: String.Encoding.ascii)
            } catch {
                print("Could not write log file")
            }
        }
        outputPath = outputPath + "/run" + runID
        if !myFilemanager.fileExists(atPath: outputPath) {
            do {
                try myFilemanager.createDirectory(atPath: outputPath, withIntermediateDirectories: false, attributes: nil)
            } catch {
                print(error)
            }
        }
        
    }
    
    func saveTimeSeries(data: [[Double]], names: [String]) throws {
            var outString = String()
        for i in 0..<names.count-1 {
            outString += names[i] + ","
        }
        outString += names.last! + "\n"
        for row in data {
            for i in 0..<row.count-1 {
                outString += String(row[i]) + ","
            }
            outString += String(row.last!) + "\n"
        }
            do {
                let url = URL(fileURLWithPath: outputPath + "/timeseries.csv")
                try outString.write(to: url, atomically: true, encoding: String.Encoding.unicode)
            } catch {
                throw error
            }

    }
    
}
