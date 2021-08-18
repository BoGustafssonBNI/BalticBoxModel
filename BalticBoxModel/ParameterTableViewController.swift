//
//  ViewController.swift
//  parameterTest
//
//  Created by Bo Gustafsson on 03/05/16.
//  Copyright © 2016 Bo Gustafsson. All rights reserved.
//

import Cocoa

struct MODELREADY {
    static let Notification = "Model Radio Station"
    static let Key = "New Data Key"
    static let VariablesKey = "Variables"
    static let NamesKey = "Names"
    static let ReadyKey = "Ready"
    static let OutputTimeInterval = "OutputTimeInterval"
    static let Totals = "Total amount data key"
    static let TotalNames = "Total names"
    static let TotalVariables = "Total variables"
}
struct MODELSTARTED {
    static let Notification = "Start Model Radio Station"
    static let StartedKey = "Started"
}

struct STEADYSTATEREADY {
    static let Notification = "Steady State Radio Station"
    static let Results = "Steady State Data Key"
    static let StabilityResults = "Stability steady state data key"
    static let VariablesKey = "Steady Vars"
    static let NamesKey = "Steady Names"
    static let NameOfParameter = "Name of Parameter Key"
    static let TotalsResults = "Steady State totals data"
    static let TotalsVariables = "Steady totals vars"
    static let TotalsVarNames = "Steady total names"
}

struct OXYGENSOLUTION {
    static let Notification = "Oxygen Solutions Radio Station"
    static let OxygenValues = "Oxygen Values Key"
    static let FValues = "Function Data Key"
}

class ParameterTableViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource, NSTextFieldDelegate {
    
    var myModelDefs = SimplifiedGeneric()
    
    fileprivate let myModel = Model()
    
    fileprivate var output = [[Double]]()
    
    fileprivate var parameterForSteadyState : Parameter?
    {
        didSet {
            if dimensionalTable {
                let steadyStateResults = myModelDefs.getSensitivity(dimensionalParam: parameterForSteadyState!, numCalc: numCalc)
                let center = NotificationCenter.default
                let notification = Notification(name: Notification.Name(rawValue: STEADYSTATEREADY.Notification), object: self, userInfo: [STEADYSTATEREADY.Results: steadyStateResults.solutions, STEADYSTATEREADY.StabilityResults: steadyStateResults.stability, STEADYSTATEREADY.VariablesKey: self.myModelDefs.getVarsToPlots(), STEADYSTATEREADY.NamesKey: self.myModelDefs.getNamesToPlots(),STEADYSTATEREADY.NameOfParameter: parameterForSteadyState!.name, STEADYSTATEREADY.TotalsResults: steadyStateResults.totals, STEADYSTATEREADY.TotalsVariables: self.myModelDefs.getTotalsVarsToPlots(), STEADYSTATEREADY.TotalsVarNames: self.myModelDefs.getTotalsNamesToPlots()])
                center.post(notification)
                
            } else {
                let steadyStateResults = myModelDefs.getSensitivity(nonDimensionalParam: parameterForSteadyState!, numCalc: numCalc)
                let center = NotificationCenter.default
                let notification = Notification(name: Notification.Name(rawValue: STEADYSTATEREADY.Notification), object: self, userInfo: [STEADYSTATEREADY.Results: steadyStateResults.solutions, STEADYSTATEREADY.StabilityResults: steadyStateResults.stability, STEADYSTATEREADY.VariablesKey: self.myModelDefs.getVarsToPlots(), STEADYSTATEREADY.NamesKey: self.myModelDefs.getNamesToPlots(),STEADYSTATEREADY.NameOfParameter: parameterForSteadyState!.name, STEADYSTATEREADY.TotalsResults: steadyStateResults.totals, STEADYSTATEREADY.TotalsVariables: self.myModelDefs.getTotalsVarsToPlots(), STEADYSTATEREADY.TotalsVarNames: self.myModelDefs.getTotalsNamesToPlots()])
                center.post(notification)
            }
        }
    }
    fileprivate var numCalc = 15
    
   
    fileprivate var params = [Parameter]() {
        didSet {
            myModelDefs.params = params
            if !dimensionalTable {
                dimensions = myModelDefs.convertNonDimensional2Dimensional(dimensional: dimensions, params: params)
            }
            modelVariables = myModelDefs.getVars()
            scalingFactors = myModelDefs.getScalingFactors()
            steadyStateSolution = myModelDefs.getSteadyStateInitialSolution()
            graphicalSteadyState = myModelDefs.o2FuncRange()
            parameterTable?.reloadData()
        }
    }
    fileprivate var dimensions = [Parameter]() {
        didSet {
            myModelDefs.dimensions = dimensions
            if dimensionalTable {
                params = myModelDefs.convertDimensional2Params(dimensional: dimensions)
            }
        }
    }
    
    fileprivate var scalingFactors = [Double]()
    
    fileprivate var dimensionalTable = false {
        didSet {
            if dimensionalTable {
                if !dimensions.isEmpty {
                    dimensions = myModelDefs.convertNonDimensional2Dimensional(dimensional: dimensions, params: params)
                }
            } else {
                if !dimensions.isEmpty && !params.isEmpty {
                    params = myModelDefs.convertDimensional2Params(dimensional: dimensions)
                }
            }
            parameterTable?.reloadData()
        }
    }
    
    fileprivate var eigenvalues = [[Complex]]() {
        didSet {
            for vectors in eigenvalues {
                for roots in vectors {
                    print(niceString(roots))
                }
            }
        }
    }
    fileprivate var stableSteadyStateSolution = [Bool]()
    
    
    fileprivate var steadyStateSolution = [[Double]]() {
        didSet {
            let numberOfSolutions = steadyStateSolution.count
            let numberOfDataColumns = steadyStateTable.tableColumns.count - 1
            if numberOfSolutions > numberOfDataColumns {
                for n in numberOfDataColumns..<numberOfSolutions {
                    let column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: String(n)))
                    column.width = 50.0
                    column.minWidth = 40.0
                    column.maxWidth = 60.0
                    column.title = "#" + String(n + 1)
                    steadyStateTable.addTableColumn(column)
                }
            } else if numberOfSolutions < numberOfDataColumns {
                for n in numberOfSolutions...numberOfDataColumns - 1 {
                    if let column = steadyStateTable.tableColumn(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: String(n))) {
                        steadyStateTable.removeTableColumn(column)
                    }
                }
            }
            eigenvalues.removeAll()
            stableSteadyStateSolution.removeAll()
            for solution in steadyStateSolution {
                let stability = myModelDefs.getStability(forState: solution)
                eigenvalues.append(stability.roots)
                stableSteadyStateSolution.append(stability.stable)
            }
            steadyStateTable?.reloadData()
        }
    }
    
    
    fileprivate var graphicalSteadyState = (oxygen: [Double](), funcValues: [Double]()) {
        didSet {
            if graphicalSteadyState.oxygen.count * graphicalSteadyState.funcValues.count > 0 {
                let center = NotificationCenter.default
                let notification = Notification(name: Notification.Name(rawValue: OXYGENSOLUTION.Notification), object: self, userInfo: [OXYGENSOLUTION.OxygenValues: graphicalSteadyState.oxygen, OXYGENSOLUTION.FValues: graphicalSteadyState.funcValues])
                center.post(notification)
            }
        }
    }
    
    fileprivate var modelVariables = [String]()
    
    @IBOutlet weak var parameterTable: NSTableView!
    
    
    @IBOutlet weak var realLoadButton: NSButton!
    
    @IBAction func changeRealLoad(_ sender: NSButton) {
        myModelDefs.realLoad = realLoadButton.state.rawValue == 1 ? true : false
        
        modelUpdate()
    }
    
    @IBOutlet weak var dimensionalTableButton: NSButton!
    
    @IBAction func changeTableMode(_ sender: NSButtonCell) {
        dimensionalTable = sender.state.rawValue == 1 ? true : false
    }
    
    @IBOutlet weak var steadyStateTable: NSTableView!
    
    @IBOutlet weak var addNoiseCheckButton: NSButton!
    
    @IBOutlet weak var returnPeriodTextField: NSTextField!
    
    fileprivate var saveObserver : NSObjectProtocol?
    fileprivate var openObserver : NSObjectProtocol?
    fileprivate var newObserver : NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        dimensionalTable = dimensionalTableButton.state == NSControl.StateValue.on ? true : false
        if dimensionalTable {
            dimensions = myModelDefs.getDefaultDimensions()
            params = myModelDefs.convertDimensional2Params(dimensional: dimensions)
        } else {
            dimensions = myModelDefs.getDefaultDimensions()
            params = myModelDefs.getDefaultParameters()
            dimensions = myModelDefs.convertNonDimensional2Dimensional(dimensional: dimensions, params: params)
        }
 
        parameterTable.toolTip = "Change paramenters"
        modelUpdate()
        
        let center = NotificationCenter.default
        let queue = OperationQueue.main
        saveObserver = center.addObserver(forName: NSNotification.Name(rawValue: SAVE.Notification), object: nil, queue: queue) { [weak weakself = self] notification in
            if let url = (notification as NSNotification).userInfo?[SAVE.URL] as? URL {
                do {
                    try weakself?.saveParametersToFile(url)
                } catch {
                    print("Could not write parameters to file")
                }
            }
            if let exporter = (notification as NSNotification).userInfo?[SAVE.ExporterInstance] as? ExportData {
                var varNames = (weakself?.myModelDefs.getVars())!
                varNames.insert("Time", at: 0)
                varNames.append("Load")
                var modelResults = [[Double]]()
                for row in (weakself?.myModel.output)! {
                    let load = (weakself?.myModelDefs.getLoad(for: row.first!, dimensional: (weakself?.dimensionalTable)!))!
                    var rowTemp = row
                    rowTemp.append(load)
                    modelResults.append(rowTemp)
                }
                do {
                    try exporter.saveTimeSeries(data: modelResults, names: varNames)
                } catch {
                    print("Could not write timeseries to file")
                }
            }
        }
        openObserver = center.addObserver(forName: NSNotification.Name(rawValue: OPEN.Notification), object: nil, queue: queue) { [weak weakself = self] notification in
            if let url = (notification as NSNotification).userInfo?[OPEN.URL] as? URL {
                do {
                    let res = try weakself!.readParametersFromFile(url)
                    if res.0 {
                        weakself!.dimensions = res.1
                    } else {
                        weakself!.params = res.1
                    }
                    weakself!.modelUpdate()
                } catch {
                    print("Could not write parameters to file")
                }
            }
        }
        newObserver = center.addObserver(forName: NSNotification.Name(rawValue: NEW.Notification), object: nil, queue: queue) { [weak weakself = self] notification in
            weakself!.dimensions = weakself!.myModelDefs.getDefaultDimensions()
            weakself!.params = weakself!.myModelDefs.getDefaultParameters()
            weakself!.modelUpdate()
        }
        
    }
    override func viewDidDisappear() {
        super.viewDidDisappear()
        let center = NotificationCenter.default
        center.removeObserver(saveObserver!)
        center.removeObserver(openObserver!)
    }
    
    
    
    
    @IBAction func runButton(_ sender: NSButton) {
        modelUpdate()
    }
    
    fileprivate func modelUpdate() {
        let row = parameterTable.selectedRow
        if dimensionalTable {
            if row >= 0 {
                if dimensions[row].sensitivityCalculation && dimensions[row].minValue != nil && dimensions[row].maxValue != nil {
                    parameterForSteadyState = dimensions[row]
                }
            }
        } else {
            if row >= 0 {
                if params[row].sensitivityCalculation && params[row].minValue != nil && params[row].maxValue != nil {
                    parameterForSteadyState = params[row]
                }
            }
        }
        let queue = DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated)
        queue.async {[weak weakself = self] in weakself?.runModel()}
//        graphicalSteadyState = myModelDefs.o2FuncRange()
    }
    
    fileprivate func runModel() {
        let center = NotificationCenter.default
        var notification = Notification(name: Notification.Name(rawValue: MODELSTARTED.Notification), object: self, userInfo: [MODELSTARTED.StartedKey: true])
        center.post(notification)
        myModelDefs.params = params
        myModelDefs.dimensions = dimensions
        myModel.initialValues = myModelDefs.getInitialState
        myModel.maxTime = myModelDefs.getMaxTime
        myModel.outputTimeInterval = myModelDefs.getOutputTimeInterval
        myModel.coefficients = myModelDefs.getCoefficients
        if dimensionalTable {
            myModel.scalingFactors = scalingFactors
        } else {
            myModel.scalingFactors = nil
        }
        myModel.initiateModel()
        myModel.iterateModel()
        let totalsResult = myModelDefs.getTotalAmounts(forModelTimeSeries: myModel.output, dimensional: dimensionalTable)
        notification = Notification(name: Notification.Name(rawValue: MODELREADY.Notification), object: self, userInfo: [MODELREADY.Key: myModel.output, MODELREADY.VariablesKey: self.myModelDefs.getVarsToPlots(), MODELREADY.NamesKey: self.myModelDefs.getNamesToPlots(), MODELREADY.ReadyKey: true, MODELREADY.Totals: totalsResult.dataToPlot, MODELREADY.TotalVariables: totalsResult.variablesToPlot, MODELREADY.TotalNames: totalsResult.namesToPlot])
        center.post(notification)
    }
    
    fileprivate func readParametersFromFile(_ url: URL) throws -> (Bool, [Parameter]) {
        var result = [Parameter]()
        var dimensional = false
        do {
            let indata = try  String.init(contentsOf: url, encoding: String.Encoding.unicode)
            let lines = indata.components(separatedBy: "\n")
            for i in 2..<lines.count {
                if !lines[i].isEmpty {
                    var p = Parameter(key: "", name: "", value: 0.0, minValue: nil, maxValue: nil, explanation: nil, sensitivityCalculation: false)
                    p.parseCSVLine(lines[i])
                    result.append(p)
                }
            }
            if lines[1] == "dimensional" {
                dimensional = true
            }
        } catch {
            throw error
        }
        return (dimensional,result)
    }
    
    
    fileprivate func saveParametersToFile(_ url: URL) throws {
        var outString = String()
        outString = myModelDefs.modelID + "\n"
        if dimensionalTable {
            outString += "dimensional\n"
            for p in dimensions {
                outString += p.toCSVLine()
            }
        } else {
            outString += "nonDimensional\n"
            for p in params {
                outString += p.toCSVLine()
            }
        }
        do {
            try outString.write(to: url, atomically: true, encoding: String.Encoding.unicode)
        } catch {
            throw error
        }
    }
    
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        switch tableView.identifier!.rawValue {
        case "parameterTableView":
            if dimensionalTable {
                return dimensions.count
            } else {
                return params.count
            }
        case "steadyStateTableView":
            return modelVariables.count + 1
        default:
            return 0
        }
    }
    
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        let tableColumnName = tableColumn!.identifier.rawValue as String
        switch tableView.identifier!.rawValue {
        case "parameterTableView":
            if dimensionalTable {
                switch tableColumnName {
                case "name":
                    return dimensions[row].name
                case "value":
                    return String(dimensions[row].value)
                case "minValue":
                    if dimensions[row].sensitivityCalculation {
                        if let value = dimensions[row].minValue {
                            return String(value)
                        } else {
                            return nil
                        }
                    } else {
                        return nil
                    }
                case "maxValue":
                    if dimensions[row].sensitivityCalculation {
                        if let value = dimensions[row].maxValue {
                            return String(value)
                        } else {
                            return nil
                        }
                    } else {
                        return nil
                    }
                default:
                    return nil
                }
               
            } else {
                switch tableColumnName {
                case "name":
                    return params[row].name
                case "value":
                    return String(params[row].value)
                case "minValue":
                    if params[row].sensitivityCalculation {
                        if let value = params[row].minValue {
                            return String(value)
                        } else {
                            return nil
                        }
                    } else {
                        return nil
                    }
                case "maxValue":
                    if params[row].sensitivityCalculation {
                        if let value = params[row].maxValue {
                            return String(value)
                        } else {
                            return nil
                        }
                    } else {
                        return nil
                    }
                default:
                    return nil
                }
            }
        case "steadyStateTableView":
            if tableColumnName == "variable" {
                if row > 0 {
                    return modelVariables[row - 1]
                } else {
                    return "Stable"
                }
            } else {
                if let n = Int(tableColumnName) {
                    if row > 0 {
                    if steadyStateSolution[n].count > row {
                         return String(steadyStateSolution[n][row])
                    } else {
                        return ""
                        }} else {
                        return stableSteadyStateSolution[n] == true ? "Stable" : "Unstable"
                    }
                    
                } else {
                    return nil
                }
            }
        default:
            return nil
        }
    }
    
    @IBAction func tableViewAction(_ sender: NSTableView) {
        let row = sender.clickedRow
        if dimensionalTable {
            if row >= 0 {
                if dimensions[row].sensitivityCalculation && dimensions[row].minValue != nil && dimensions[row].maxValue != nil {
                    parameterForSteadyState = dimensions[row]
                }
                graphicalSteadyState = myModelDefs.o2FuncRange()
            }
        } else {
            if row >= 0 {
                if params[row].sensitivityCalculation && params[row].minValue != nil && params[row].maxValue != nil {
                    parameterForSteadyState = params[row]
                }
                graphicalSteadyState = myModelDefs.o2FuncRange()
            }
        }
    }
    func tableView(_ tableView: NSTableView, toolTipFor cell: NSCell, rect: NSRectPointer, tableColumn: NSTableColumn?, row: Int, mouseLocation: NSPoint) -> String {
        if tableView.identifier!.rawValue == "parameterTableView" {
            if dimensionalTable {
                return dimensions[row].explanation!
                
            } else {
                return params[row].explanation!
            }
        } else {
            return ""
        }
    }
    func tableView(_ tableView: NSTableView, shouldEdit tableColumn: NSTableColumn?, row: Int) -> Bool {
        if tableView.identifier!.rawValue == "parameterTableView" {
            let tableColumnName = tableColumn!.identifier.rawValue
            if dimensionalTable {
                switch tableColumnName {
                case "name":
                    return false
                case "value":
                    return true
                case "minValue":
                    return dimensions[row].sensitivityCalculation
                case "maxValue":
                    return dimensions[row].sensitivityCalculation
                default:
                    return false
                }
                
            } else {
                switch tableColumnName {
                case "name":
                    return false
                case "value":
                    return true
                case "minValue":
                    return params[row].sensitivityCalculation
                case "maxValue":
                    return params[row].sensitivityCalculation
                default:
                    return false
                }
            }
        } else {
            return false
        }
        
    }
    func tableView(_ tableView: NSTableView, setObjectValue object: Any?, for tableColumn: NSTableColumn?, row: Int) {
        if tableView.identifier!.rawValue == "parameterTableView" {
            
            let identifier = tableColumn!.identifier.rawValue
            if let str = object as? String {
                if let newValue = Double(str) {
                    if dimensionalTable {
                        switch identifier {
                        case "value":
                            dimensions[row].value = newValue
                        case "minValue":
                            dimensions[row].minValue = newValue
                        case "maxValue":
                            dimensions[row].maxValue = newValue
                        default:
                            break
                        }
                        
                    } else {
                        switch identifier {
                        case "value":
                            params[row].value = newValue
                        case "minValue":
                            params[row].minValue = newValue
                        case "maxValue":
                            params[row].maxValue = newValue
                        default:
                            break
                        }
                    }
                }
            }
        }
    }
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        switch tableView.identifier!.rawValue {
        case "parameterTableView":
            return true
        default:
            return false
        }
    }
    func tableView(_ tableView: NSTableView, shouldSelect tableColumn: NSTableColumn?) -> Bool {
        if tableView.identifier!.rawValue == "steadyStateTableView" {
            if tableColumn!.identifier.rawValue != "variable" {
                return true
            }
        }
        return false
    }
    
    func tableView(_ tableView: NSTableView, didClick tableColumn: NSTableColumn) {
        if let n = Int(tableColumn.identifier.rawValue) {
            myModelDefs.initialStateForSimulation = n
        }
    }
    
}

