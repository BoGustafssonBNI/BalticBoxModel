//
//  ModelSpecs.swift
//  boxModel
//
//  Created by Bo Gustafsson on 19/06/16.
//  Copyright © 2016 BNI. All rights reserved.
//

import Foundation

protocol ModelSpecs {
    var modelID : String {get}
    var params : [Parameter]? {get set}
    var dimensions : [Parameter]? {get set}
    var initialStateForSimulation : Int? {get set}
    
    func getVars() -> [String]
    
    func getScalingFactors() -> [Double]
    
    func getNamesToPlots() -> [[String]]
    
    func getVarsToPlots() -> [[Int]]
    
    func getDefaultParameters() -> [Parameter]
    
    func getDefaultDimensions() -> [Parameter]
    
    func getMaxTime() -> Double
    
    func getOutputTimeInterval() -> Double
    
    func getInitialState() -> [Double]
    
    func getSensitivity(nonDimensionalParam param: Parameter, numCalc: Int) -> (solutions: [[[Double]]], stability: [[Bool]], totals: [[[Double]]])
    func getSensitivity(dimensionalParam dimParam: Parameter, numCalc: Int) -> (solutions: [[[Double]]], stability: [[Bool]], totals: [[[Double]]])
    
    func getSteadyStateInitialSolution() -> [[Double]]
    
    func getCoefficients(_ state: [Double]) -> [[Double]]
    
    func o2FuncRange() -> (oxygen: [Double], funcValues: [Double])
    
    func getStability(forState state: [Double]) -> (roots: [Complex], stable: Bool)
    
}
