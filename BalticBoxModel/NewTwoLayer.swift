//
//  NewTwoLayer.swift
//  boxModel
//
//  Created by Bo Gustafsson on 17/05/16.
//  Copyright © 2016 BNI. All rights reserved.
//

import Foundation


class NewTwoLayer : ModelSpecs {
    fileprivate let defaultParams = [
        Parameter(key: "zeta", name: "𝞯", value: 0.6, minValue: 0.1, maxValue: 0.9, explanation: "Factor higher OM flux to shallow areas", sensitivityCalculation: true),
        Parameter(key: "lambda", name: "𝞴", value: 0.74, minValue: 0.0, maxValue: 1.0, explanation: "Ratio of shallow areas to total area", sensitivityCalculation: true),
        Parameter(key: "pi", name: "Fraction resuspended to deep layer", value: 0.5, minValue: 0.0, maxValue: 1.0, explanation: "The fraction of the organic matter flux to upper layer transport bottoms that is transported to the deep layer", sensitivityCalculation: true),
        Parameter(key: "a1", name: "Frac. Acc bottoms shallow layer", value: 0.2, minValue: 0.1, maxValue: 1.0, explanation: "Fraction of accumulation bottoms in the shallow layer", sensitivityCalculation: true),
        Parameter(key: "a2", name: "Frac. Acc bottoms deep layer", value: 0.75, minValue: 0.1, maxValue: 1.0, explanation: "Fraction of accumulation bottoms in the deep layer", sensitivityCalculation: true),
        Parameter(key: "regenerationRate1", name: "r1", value: 0.434, minValue: 0.1, maxValue: 4, explanation: "Regeneration Rate shallow", sensitivityCalculation: true),
        Parameter(key: "regenerationRate2", name: "r2", value: 0.434, minValue: 0.1, maxValue: 4, explanation: "Regeneration Rate deep", sensitivityCalculation: true),
        Parameter(key: "alphaPlus", name: "𝜶 (O2 > 0)", value: 1.0, minValue: 0.1, maxValue: 2, explanation: "Redox dependence on regeneration rate", sensitivityCalculation: true),
        Parameter(key: "alphaMinus", name: "𝜶 (O2 < 0)", value: 0.2, minValue: 0.1, maxValue: 2, explanation: "Redox dependence on regeneration rate", sensitivityCalculation: true),
        Parameter(key: "betaPlus", name: "𝜷 (O2 > 0)", value: 1.0, minValue: 0.1, maxValue: 4.0, explanation: "Redox depent preferential P regeneration", sensitivityCalculation: true),
        Parameter(key: "betaMinus", name: "𝜷 (O2 < 0)", value: 4.0, minValue: 1.0, maxValue: 8.0, explanation: "Redox depent preferential P regeneration", sensitivityCalculation: true),
        Parameter(key: "burialRate1", name: "𝜺1", value: 0.0434, minValue: 0.001, maxValue: 0.1, explanation: "Burial rate shallow", sensitivityCalculation: true),
        Parameter(key: "burialRate2", name: "𝜺2", value: 0.0434, minValue: 0.001, maxValue: 0.1, explanation: "Burial rate deep", sensitivityCalculation: true),
        Parameter(key: "mixingRate", name: "d", value: 0.4135, minValue: 0.1, maxValue: 1, explanation: "Mixing rate", sensitivityCalculation: true),
        Parameter(key: "chi", name: "𝝌", value: 2.8, minValue: 0.5, maxValue: 6, explanation: "Oxygen reference concentration", sensitivityCalculation: true),
        Parameter(key: "exchangeRate", name: "e", value: 0.0538, minValue: 0.01, maxValue: 0.1, explanation: "Exchange rate", sensitivityCalculation: true),
        Parameter(key: "qf", name: "qf", value: 0.0461, minValue: 0.02, maxValue: 0.07, explanation: "River runoff", sensitivityCalculation: true),
        Parameter(key: "psi", name: "𝝍", value: 1.3, minValue: 0.1, maxValue: 2.0, explanation: "Adjacent basin P concentration", sensitivityCalculation: true),
        Parameter(key: "rhoUptake", name: "𝝆u", value: 0.3, minValue: 0.01, maxValue: 5, explanation: "FeP uptake rate", sensitivityCalculation: true),
        Parameter(key: "rhoRelease", name: "𝝆r", value: 0.3, minValue: 0.01, maxValue: 5, explanation: "FeP release rate", sensitivityCalculation: true),
        Parameter(key: "mu1", name: "𝝁1", value: 6.06, minValue: 1.0, maxValue: 20.0, explanation: "Maximal FeP concentration shallow", sensitivityCalculation: true),
        Parameter(key: "mu2", name: "𝝁2", value: 10.0, minValue: 1.0, maxValue: 20.0, explanation: "Maximal FeP concentration deep", sensitivityCalculation: true),
        Parameter(key: "kappa1", name: "𝜿1", value: 0.59, minValue: 0.1, maxValue: 4.0, explanation: "Dependency of FeP conc shallow", sensitivityCalculation: true),
        Parameter(key: "kappa2", name: "𝜿2", value: 1.03, minValue: 0.1, maxValue: 4.0, explanation: "Dependency of FeP conc deep", sensitivityCalculation: true),
        Parameter(key: "m", name: "m", value: 2.0, minValue: 0.0, maxValue: 4.0, explanation: "Dependency of FeP conc", sensitivityCalculation: true),
        Parameter(key: "burialFe", name: "𝜺FeP", value: 0.0, minValue: 0.0, maxValue: 0.01, explanation: "FeP burial rate", sensitivityCalculation: true),
        Parameter(key: "endTime", name: "Tmax", value: 300.0, minValue: 0.0, maxValue: nil, explanation: "Length of simulation", sensitivityCalculation: false),
        Parameter(key: "timeStep", name: "𝜟t", value: 0.01, minValue: 0.0, maxValue: nil, explanation: "Time step", sensitivityCalculation: false),
        Parameter(key: "outputTimeInterval", name: "Output 𝜟t", value: 1.0, minValue: 0.0, maxValue: nil, explanation: "Time interval between outputs", sensitivityCalculation: false),
        Parameter(key: "startOfScenario", name: "Scenario start", value: 0.0, minValue: 0.0, maxValue: nil, explanation: "Loads will start to change at this time", sensitivityCalculation: false),
        Parameter(key: "endOfScenario", name: "Scenario end", value: 1.0, minValue: 0.0, maxValue: nil, explanation: "Loads will stop changing at this time", sensitivityCalculation: false),
        Parameter(key: "initialLoad", name: "Initial load", value: 0.0838, minValue: 0.0675, maxValue: 0.34, explanation: "Load at the beginning of the scenario", sensitivityCalculation: true),
        Parameter(key: "finalLoad", name: "Final load", value: 0.0838, minValue: 0.0, maxValue: nil, explanation: "Load at the end of the scenario", sensitivityCalculation: false),
       Parameter(key: "o2Values", name: "x range", value: 0.0, minValue: -2.0, maxValue: 1.0, explanation: "The range of x for which steady state solution plot is drawn, value is not used", sensitivityCalculation: false)
    ]

    fileprivate let defaultDimensions = [
        Parameter(key: "At", name: "Area (km2)", value: 372000, minValue: 100000.0, maxValue: 400000.0, explanation: "The total basin area", sensitivityCalculation: false),
        Parameter(key: "H", name: "Average depth (m)", value: 55.0, minValue: 30.0, maxValue: 100.0, explanation: "Average basin depth", sensitivityCalculation: false),
        Parameter(key: "HB", name: "Deep basin depth (m)", value: 35.0, minValue: 15.0, maxValue: 50.0, explanation: "Deep basin average depth", sensitivityCalculation: false),
        Parameter(key: "P0", name: "P conc. (uM)", value: 1.0, minValue: 0.2, maxValue: 1.5, explanation: "P concentration scale", sensitivityCalculation: false),
        Parameter(key: "NU", name: "ν (m/yr)", value: 38.0, minValue: 5.0, maxValue: 200.0, explanation: "Organic matter apparent settling velicity", sensitivityCalculation: false),
        Parameter(key: "GAMMA", name: "𝜸", value: 0.00943, minValue: 0.00943, maxValue: 0.00943, explanation: "P/C ratio in OM", sensitivityCalculation: false),
        Parameter(key: "XI", name: "𝝃", value: 1.0, minValue: 1.0, maxValue: 1.0, explanation: "O2/C ratio", sensitivityCalculation: false),
        Parameter(key: "A1", name: "Area 1 (km2)", value: 285000, minValue: 80000.0,maxValue: 350000.0, explanation: "Area of the sediments of the upper box", sensitivityCalculation: true),
        Parameter(key: "AM1A1", name: "Frac. Acc bottoms shallow layer", value: 0.2, minValue: 0.1, maxValue: 1.0, explanation: "Fraction of accumulation bottoms in the shallow layer", sensitivityCalculation: true),
        Parameter(key: "AM2A2", name: "Frac. Acc bottoms deep layer", value: 0.75, minValue: 0.1, maxValue: 1.0, explanation: "Fraction of accumulation bottoms in the deep layer", sensitivityCalculation: true),
        Parameter(key: "PI", name: "Fraction resuspended to deep layer", value: 0.5, minValue: 0.0, maxValue: 1.0, explanation: "The fraction of the organic matter flux to upper layer transport bottoms that is transported to the deep layer", sensitivityCalculation: true),
        Parameter(key: "LM", name: "L mineralization (m)", value: 999999.0, minValue: 15.0, maxValue: 150.0, explanation: "Length scale for pelagic mineralization", sensitivityCalculation: true),
        Parameter(key: "PIn", name: "P in (uM)", value: 0.9, minValue: 0.1, maxValue: 0.5, explanation: "P concentration in inflowing water", sensitivityCalculation: true),
        Parameter(key: "IPMAX1", name: "Max FeP conc. shallow (mmol/m2)", value: 200.0, minValue: 10.0, maxValue: 150.0, explanation: "Max FeP conc. (mmol/m2)", sensitivityCalculation: true),
        Parameter(key: "IPMAX2", name: "Max FeP conc. deep (mmol/m2)", value: 200.0, minValue: 10.0, maxValue: 150.0, explanation: "Max FeP conc. (mmol/m2)", sensitivityCalculation: true),
        Parameter(key: "O2In", name: "O2 in (uM)", value: 350.0, minValue: 100.0, maxValue: 350.0, explanation: "O2 in inflowing water", sensitivityCalculation: true),
        Parameter(key: "E", name: "Exchange (m3/s)", value: 5000.0, minValue: 10000.0, maxValue: 40000.0, explanation: "Water exchange flux", sensitivityCalculation: true),
        Parameter(key: "QF", name: "River runoff (m3/s)", value: 14500.0, minValue: 10000.0, maxValue: 20000.0, explanation: "River runoff", sensitivityCalculation: true),
        Parameter(key: "D", name: "Diffusive exchange (m/yr)", value: 14.0, minValue: 5.0, maxValue: 20.0, explanation: "Diffusive exchange flux", sensitivityCalculation: true),
        Parameter(key: "K1", name: "Piston velocity (m/yr) shallow", value: 50.0, minValue: 5.0, maxValue: 40.0, explanation: "Piston velocity for sediment-water exchange of O2 shallow", sensitivityCalculation: true),
        Parameter(key: "K2", name: "Piston velocity (m/yr) deep", value: 50.0, minValue: 5.0, maxValue: 40.0, explanation: "Piston velocity for sediment-water exchange of O2 deep", sensitivityCalculation: true),
        Parameter(key: "RO1", name: "Regeneration rate (upper layer) (1/yr)", value: 0.3, minValue: 0.1, maxValue: 3.0, explanation: "Regeneration rate of organic matter", sensitivityCalculation: true),
        Parameter(key: "RO2", name: "Regeneration rate (lower layer) (1/yr)", value: 0.3, minValue: 0.1, maxValue: 3.0, explanation: "Regeneration rate of organic matter", sensitivityCalculation: true),
        Parameter(key: "alphaPlus", name: "𝜶 (O2 > 0)", value: 1.0, minValue: 0.1, maxValue: 2, explanation: "Redox dependence on regeneration rate", sensitivityCalculation: true),
        Parameter(key: "alphaMinus", name: "𝜶 (O2 < 0)", value: 0.2, minValue: 0.1, maxValue: 2, explanation: "Redox dependence on regeneration rate", sensitivityCalculation: true),
        Parameter(key: "betaPlus", name: "𝜷 (O2 > 0)", value: 1.0, minValue: 0.1, maxValue: 4.0, explanation: "Redox depent preferential P regeneration", sensitivityCalculation: true),
        Parameter(key: "betaMinus", name: "𝜷 (O2 < 0)", value: 4.0, minValue: 1.0, maxValue: 8.0, explanation: "Redox depent preferential P regeneration", sensitivityCalculation: true),
        Parameter(key: "BUR1", name: "Burial rate (upper layer) (1/yr)", value: 0.02, minValue: 0.002, maxValue: 0.1, explanation: "Burial rate of organic matter", sensitivityCalculation: true),
        Parameter(key: "BUR2", name: "Burial rate (lower layer) (1/yr)", value: 0.02, minValue: 0.002, maxValue: 0.1, explanation: "Burial rate of organic matter", sensitivityCalculation: true),
        Parameter(key: "BURFE", name: "Burial rate of FeP (1/yr)", value: 0.0, minValue: 0.0, maxValue: 0.2, explanation: "Burial rate for ironbound P", sensitivityCalculation: true),
        Parameter(key: "RFEuptake", name: "FeP uptake rate (1/yr)", value: 0.25, minValue: 0.01, maxValue: 1.0, explanation: "FeP uptake rate (1/yr)", sensitivityCalculation: true),
        Parameter(key: "RFErelease", name: "FeP release rate (1/yr)", value: 0.25, minValue: 0.01, maxValue: 1.0, explanation: "FeP release rate (1/yr)", sensitivityCalculation: true),
        Parameter(key: "m", name: "m", value: 2.0, minValue: 0.0, maxValue: 4.0, explanation: "Dependency of FeP conc", sensitivityCalculation: true),
        Parameter(key: "ENDTIME", name: "Tmax (yrs)", value: 300.0, minValue: 0.0, maxValue: nil, explanation: "Length of simulation (yrs)", sensitivityCalculation: false),
        Parameter(key: "TIMESTEP", name: "𝜟t (yrs)", value: 0.01, minValue: 0.0, maxValue: nil, explanation: "Time step", sensitivityCalculation: false),
        Parameter(key: "OUTPUTTIMEINTERVAL", name: "Output 𝜟t (yrs)", value: 1.0, minValue: 0.0, maxValue: nil, explanation: "Time interval between outputs", sensitivityCalculation: false),
        Parameter(key: "STARTOFSCENARIO", name: "Scenario start (yrs)", value: 0.0, minValue: 0.0, maxValue: nil, explanation: "Loads will start to change at this time", sensitivityCalculation: false),
        Parameter(key: "ENDOFSCENARIO", name: "Scenario end (yrs)", value: 1.0, minValue: 0.0, maxValue: nil, explanation: "Loads will stop changing at this time", sensitivityCalculation: false),
        Parameter(key: "INITIAL LOAD", name: "Initial load (ton)", value: 8000.0, minValue: 8000.0, maxValue: 80000.0, explanation: "Load at the beginning of the scenario", sensitivityCalculation: true),
        Parameter(key: "FINAL LOAD", name: "Final load (ton)", value: 8000.0, minValue: 0.0, maxValue: nil, explanation: "Load at the end of the scenario", sensitivityCalculation: false),
//        Parameter(key: "LAMBDA1", name: "Λ1", value: 1, minValue: nil, maxValue: nil, explanation: "LAMBDA 1", sensitivityCalculation: false),
//        Parameter(key: "LAMBDA2", name: "Λ2", value: 1, minValue: nil, maxValue: nil, explanation: "LAMBDA 2", sensitivityCalculation: false)
        ]

    fileprivate let modelVariables = ["p", "o2", "c1", "c2", "b1", "b2", "i1", "i2"]
    
    fileprivate let varsToPlots = [[1],[2],[3,4],[5, 6, 7, 8]]
    fileprivate let namesToPlots = [["p"],["o2"],["c1","c2"],["b1", "b2","i1", "i2"]]
    
    fileprivate let totalsToPlots = [[1], [2], [3], [1,2,3,4]]
    fileprivate let namesToTotalPlots = [["Pel"],["Org"],["In-org"],["Pel", "Org", "In-org", "Tot"]]
    
    fileprivate var pvalues = [String : Double]()
    fileprivate var dvalues = [String : Double]()
    fileprivate var findO2SteadyStateParams : Parameter?
    var parameterForNoise : Parameter?
    var returnPeriod = 1.0
    var noiseValue : Double?
    var initialStateForSimulation : Int?
    var realLoad = false
    
    let modelID = "Two-layer model"
    var params : [Parameter]? {
        didSet {
            for param in params! {
                pvalues[param.key] = param.value
                if param.key == "o2Values" {
                    findO2SteadyStateParams = param
                }
            }
            
        }
    }
    var dimensions : [Parameter]? {
        didSet {
            for dim in dimensions! {
                dvalues[dim.key] = dim.value
            }
        }
    }
    
    func convertDimensional2Params(dimensional: [Parameter]) -> [Parameter] {
        let outParams = defaultParams
        var dim = [String: Parameter]()
        var nonDim = [String: Parameter]()
        for d in dimensional {
            dim[d.key] = d
        }
        for p in outParams {
            nonDim[p.key] = p
        }
        let nu = dim["NU"]!.value
        let tau = dim["H"]!.value / nu
        let ton2mmolperm2 = 1.0e3 / 31.0 / dim["At"]!.value / dim["P0"]!.value / dim["H"]!.value * tau
        let secPerYear = 86400.0 * 365.0
        var temp = dim["HB"]!.value / dim["LM"]!
        let noll = ParameterValues(value: 0.0, minValue: 0.0, maxValue: 0.0)
        temp = exp(values: noll - temp)
        let zeta = temp.checkMinMax()
        let hhb = dim["H"]!.value / dim["HB"]!.value
        var areaRatio = dim["A1"]! / dim["At"]!
        if let maxValue = areaRatio.maxValue {
            if maxValue > 1 { areaRatio.maxValue = 1.0 }
        }
        let LAMBDA1 = 1.0 - dim["PI"]!.value * (1.0 - dim["AM1A1"]!.value)
        let LAMBDA2 = 1 + dim["PI"]!.value * areaRatio.value/(1.0 - areaRatio.value)*(1.0 - dim["AM1A1"]!.value)
        
        let X0 = LAMBDA2 * dim["XI"]!.value / dim["GAMMA"]!.value * hhb * dim["P0"]!.value
        let I01 = LAMBDA1 * dim["H"]!.value * dim["P0"]!.value / dim["AM1A1"]!.value
        let I02 = zeta * LAMBDA2 * dim["H"]!.value * dim["P0"]!.value / dim["AM2A2"]!.value
        
        nonDim["a1"]!.addParameterValues(param: dim["AM1A1"]!)
        nonDim["a2"]!.addParameterValues(param: dim["AM2A2"]!)
        nonDim["pi"]!.addParameterValues(param: dim["PI"]!)
        nonDim["zeta"]!.addParameterValues(values: zeta)
        nonDim["lambda"]!.addParameterValues(values: areaRatio)
        nonDim["regenerationRate1"]!.addParameterValues(values: dim["RO1"]! * tau)
        nonDim["regenerationRate2"]!.addParameterValues(values: dim["RO2"]! * tau)
        nonDim["burialRate1"]!.addParameterValues(values: dim["BUR1"]! * tau)
        nonDim["burialRate2"]!.addParameterValues(values: dim["BUR2"]! * tau)
        nonDim["burialFe"]!.addParameterValues(values: dim["BURFE"]! * tau)
        nonDim["mixingRate"]!.addParameterValues(values: hhb / nu * dim["D"]!)
        nonDim["chi"]!.addParameterValues(values: dim["O2In"]! / X0)
        nonDim["exchangeRate"]!.addParameterValues(values: tau * dim["E"]! / dim["H"]!.value / dim["At"]!.value * secPerYear / 1.0e6)
        nonDim["qf"]!.addParameterValues(values: tau * dim["QF"]! / dim["H"]!.value / dim["At"]!.value * secPerYear / 1.0e6)
        nonDim["psi"]!.addParameterValues(values: dim["PIn"]! / dim["P0"]!.value)
        nonDim["rhoUptake"]!.addParameterValues(values: dim["RFEuptake"]! * tau)
        nonDim["rhoRelease"]!.addParameterValues(values: dim["RFErelease"]! * tau)
        nonDim["mu1"]!.addParameterValues(values: dim["IPMAX1"]! / I01)
        nonDim["mu2"]!.addParameterValues(values: dim["IPMAX2"]! / I02)
        nonDim["kappa1"]!.addParameterValues(values: hhb * dim["K1"]! / nu * dim["AM1A1"]! * LAMBDA2 / LAMBDA1)
        nonDim["kappa2"]!.addParameterValues(values: hhb * dim["K2"]! / nu * dim["AM2A2"]! / zeta.value)
        nonDim["m"]!.addParameterValues(param: dim["m"]!)
        nonDim["endTime"]!.addParameterValues(values: dim["ENDTIME"]! / tau)
        nonDim["timeStep"]!.addParameterValues(values: dim["TIMESTEP"]! / tau)
        nonDim["outputTimeInterval"]!.addParameterValues(values: dim["OUTPUTTIMEINTERVAL"]! / tau)
        nonDim["startOfScenario"]!.addParameterValues(values: dim["STARTOFSCENARIO"]! / tau)
        nonDim["endOfScenario"]!.addParameterValues(values: dim["ENDOFSCENARIO"]! / tau)
        nonDim["initialLoad"]!.addParameterValues(values: dim["INITIAL LOAD"]! * ton2mmolperm2)
        nonDim["finalLoad"]!.addParameterValues(values: dim["FINAL LOAD"]! * ton2mmolperm2)
        nonDim["alphaPlus"]!.addParameterValues(param: dim["alphaPlus"]!)
        nonDim["alphaMinus"]!.addParameterValues(param: dim["alphaMinus"]!)
        nonDim["betaPlus"]!.addParameterValues(param: dim["betaPlus"]!)
        nonDim["betaMinus"]!.addParameterValues(param: dim["betaMinus"]!)
        var out = [Parameter]()
        for p in outParams {
            out.append(nonDim[p.key]!)
        }
        return out
    }
    fileprivate func convertdvalues2pvalues(dv: [String: Double]) -> [String: Double] {
        var pv = pvalues
        let secPerYear = 86400.0 * 365.0
        let areaRatio = dv["A1"]! / dv["At"]!
        let temp = -dv["HB"]! / dv["LM"]!
        let zeta = exp(temp)
        let LAMBDA1 = 1.0 - dv["PI"]! * (1.0 - dv["AM1A1"]!)
        let LAMBDA2 = 1 + dv["PI"]! * areaRatio/(1.0 - areaRatio)*(1.0 - dv["AM1A1"]!)
        let nu = dv["NU"]!
        let tau = dv["H"]! / nu
        let ton2mmolperm2 = 1.0e3 / 31.0 / dv["At"]! / dv["P0"]! / dv["H"]! * tau
        let hhb = dv["H"]! / dv["HB"]!
        let X0 = LAMBDA2 * dv["XI"]! / dv["GAMMA"]! * hhb * dv["P0"]!
        let I01 = LAMBDA1 * dv["H"]! * dv["P0"]! / dv["AM1A1"]!
        let I02 = zeta * LAMBDA2 * dv["H"]! * dv["P0"]! / dv["AM2A2"]!
        pv["a1"]! = dv["AM1A1"]!
        pv["a2"]! = dv["AM2A2"]!
        pv["pi"]! = dv["PI"]!
        pv["zeta"]! = zeta
        pv["lambda"]! = areaRatio
        pv["regenerationRate1"]! = dv["RO1"]! * tau
        pv["regenerationRate2"]! = dv["RO2"]! * tau
        pv["burialRate1"]! = dv["BUR1"]! * tau
        pv["burialRate2"]! = dv["BUR2"]! * tau
        pv["burialFe"]! = dv["BURFE"]! * tau
        pv["mixingRate"]! = hhb / nu * dv["D"]!
        pv["chi"]! = dv["O2In"]! / X0
        pv["exchangeRate"]! = tau * dv["E"]! / dv["H"]! / dv["At"]! * secPerYear / 1.0e6
        pv["qf"]! = tau * dv["QF"]! / dv["H"]! / dv["At"]! * secPerYear / 1.0e6
        pv["psi"]! = dv["PIn"]! / dv["P0"]!
        pv["rhoUptake"]! = dv["RFEuptake"]! * tau
        pv["rhoRelease"]! = dv["RFErelease"]! * tau
        pv["mu1"]! = dv["IPMAX1"]! / I01
        pv["mu2"]! = dv["IPMAX2"]! / I02
        pv["kappa1"]! = hhb * dv["K1"]! / nu * dv["AM1A1"]! * LAMBDA2 / LAMBDA1
        pv["kappa2"]! = hhb * dv["K2"]! / nu * dv["AM2A2"]! / zeta
        pv["m"]! = dv["m"]!
        pv["endTime"]! = dv["ENDTIME"]! / tau
        pv["timeStep"]! = dv["TIMESTEP"]! / tau
        pv["outputTimeInterval"]! = dv["OUTPUTTIMEINTERVAL"]! / tau
        pv["startOfScenario"]! = dv["STARTOFSCENARIO"]! / tau
        pv["endOfScenario"]! = dv["ENDOFSCENARIO"]! / tau
        pv["initialLoad"]! = dv["INITIAL LOAD"]! * ton2mmolperm2
        pv["finalLoad"]! = dv["FINAL LOAD"]! * ton2mmolperm2
        pv["alphaPlus"]! = dv["alphaPlus"]!
        pv["alphaMinus"]! = dv["alphaMinus"]!
        pv["betaPlus"]! = dv["betaPlus"]!
        pv["betaMinus"]! = dv["betaMinus"]!
        return pv
    }
    
    func convertNonDimensional2Dimensional(dimensional: [Parameter], params : [Parameter]) -> [Parameter] {
        var dim = [String: Parameter]()
        var nonDim = [String: Parameter]()
        for d in dimensional {
            dim[d.key] = d
        }
        for p in params {
            nonDim[p.key] = p
        }
        
        let nu = dim["NU"]!.value
        let tau = dim["H"]!.value / nu
        let hhb = dim["H"]!.value / dim["HB"]!.value
        let LAMBDA1 = 1.0 - nonDim["pi"]!.value * (1.0 - nonDim["a1"]!.value)
        let LAMBDA2 = 1 + nonDim["pi"]!.value * nonDim["lambda"]!.value/(1.0 - nonDim["lambda"]!.value)*(1.0 - nonDim["a1"]!.value)
        let X0 = LAMBDA2 * dim["XI"]!.value / dim["GAMMA"]!.value * hhb * dim["P0"]!.value
        let I01 = LAMBDA1 * dim["H"]!.value * dim["P0"]!.value / nonDim["a1"]!.value
        let I02 = nonDim["zeta"]!.value * LAMBDA2 * dim["H"]!.value * dim["P0"]!.value / nonDim["a2"]!.value
        let ton2mmolperm2 = 1.0e3 / 31.0 / dim["At"]!.value / dim["P0"]!.value / dim["H"]!.value * tau
        let secPerYear = 86400.0 * 365.0
        let logzeta = log(values: nonDim["zeta"]!.getValues())
        dim["PI"]!.addParameterValues(param: nonDim["pi"]!)
        dim["AM1A1"]!.addParameterValues(param: nonDim["a1"]!)
        dim["AM2A2"]!.addParameterValues(param: nonDim["a2"]!)
        dim["LM"]!.addParameterValues(values: -dim["HB"]!.value / logzeta)
        dim["A1"]!.addParameterValues(values: nonDim["lambda"]! * dim["At"]!.value)
        dim["RO1"]!.addParameterValues(values: nonDim["regenerationRate1"]! / tau)
        dim["RO2"]!.addParameterValues(values: nonDim["regenerationRate2"]! / tau)
        dim["BUR1"]!.addParameterValues(values: nonDim["burialRate1"]! / tau)
        dim["BUR2"]!.addParameterValues(values: nonDim["burialRate2"]! / tau)
        dim["BURFE"]!.addParameterValues(values: nonDim["burialFe"]! / tau)
        dim["D"]!.addParameterValues(values: nonDim["mixingRate"]! / hhb * nu)
        dim["O2In"]!.addParameterValues(values: nonDim["chi"]! * X0)
        dim["E"]!.addParameterValues(values: nonDim["exchangeRate"]! / tau * dim["H"]!.value * dim["At"]!.value / secPerYear * 1.0e6)
        dim["QF"]!.addParameterValues(values: nonDim["qf"]! / tau * dim["H"]!.value * dim["At"]!.value / secPerYear * 1.0e6)
        dim["PIn"]!.addParameterValues(values: nonDim["psi"]! * dim["P0"]!.value)
        dim["RFEuptake"]!.addParameterValues(values: nonDim["rhoUptake"]! / tau)
        dim["RFErelease"]!.addParameterValues(values: nonDim["rhoRelease"]! / tau)
        dim["IPMAX1"]!.addParameterValues(values: nonDim["mu1"]! * I01)
        dim["IPMAX2"]!.addParameterValues(values: nonDim["mu2"]! * I02 )
        dim["K1"]!.addParameterValues(values: nonDim["kappa1"]! * nu / hhb / nonDim["a1"]!.value * LAMBDA1 / LAMBDA2)
        dim["K2"]!.addParameterValues(values: nonDim["kappa2"]! * nu / hhb / nonDim["a2"]!.value * nonDim["zeta"]!.value)
        dim["m"]!.addParameterValues(param: nonDim["m"]!)
        dim["ENDTIME"]!.addParameterValues(values: nonDim["endTime"]! * tau)
        dim["TIMESTEP"]!.addParameterValues(values: nonDim["timeStep"]! * tau)
        dim["OUTPUTTIMEINTERVAL"]!.addParameterValues(values: nonDim["outputTimeInterval"]! * tau)
        dim["STARTOFSCENARIO"]!.addParameterValues(values: nonDim["startOfScenario"]! * tau)
        dim["ENDOFSCENARIO"]!.addParameterValues(values: nonDim["endOfScenario"]! * tau)
        dim["INITIAL LOAD"]!.addParameterValues(values: nonDim["initialLoad"]! / ton2mmolperm2)
        dim["FINAL LOAD"]!.addParameterValues(values: nonDim["finalLoad"]! / ton2mmolperm2)
        dim["alphaPlus"]!.addParameterValues(param: nonDim["alphaPlus"]!)
        dim["alphaMinus"]!.addParameterValues(param: nonDim["alphaMinus"]!)
        dim["betaPlus"]!.addParameterValues(param: nonDim["betaPlus"]!)
        dim["betaMinus"]!.addParameterValues(param: nonDim["betaMinus"]!)
//        dim["LAMBDA1"]!.addParameterValues(values: ParameterValues(value: LAMBDA1, minValue: nil, maxValue: nil))
//        dim["LAMBDA2"]!.addParameterValues(values: ParameterValues(value: LAMBDA2, minValue: nil, maxValue: nil))
        var out = [Parameter]()
        for p in dimensional {
            out.append(dim[p.key]!)
        }
        
        return out
    }
    
    func getScalingFactors() -> [Double] {
        var scales = [Double]()
        scales.append(dvalues["H"]!/dvalues["NU"]!)
        scales.append(dvalues["P0"]!)
        let HP0 = dvalues["H"]! * dvalues["P0"]!
        let LAMBDA1 = 1.0 - dvalues["PI"]! * (1.0 - dvalues["AM1A1"]!)
        let LAMBDA2 = 1 + dvalues["PI"]! * pvalues["lambda"]!/(1.0 - pvalues["lambda"]!)*(1.0 - dvalues["AM1A1"]!)

        scales.append(LAMBDA2 * dvalues["XI"]! * HP0 / dvalues["GAMMA"]!/dvalues["HB"]!)
        scales.append(LAMBDA1 * HP0/dvalues["GAMMA"]!/dvalues["AM1A1"]!)
        scales.append(LAMBDA2 * HP0/dvalues["GAMMA"]!*pvalues["zeta"]!/dvalues["AM2A2"]!)
        scales.append(LAMBDA1 * HP0/dvalues["AM1A1"]!)
        scales.append(LAMBDA2 * HP0*pvalues["zeta"]!/dvalues["AM2A2"]!)
        scales.append(LAMBDA1 * HP0/dvalues["AM1A1"]!)
        scales.append(LAMBDA2 * HP0*pvalues["zeta"]!/dvalues["AM2A2"]!)
        return scales
    }
    
    func getScalingFactors(fromdvalues dv: [String: Double]) -> [Double] {
        var scales = [Double]()
        let temp = -dv["HB"]! / dv["LM"]!
        let zeta = exp(temp)
        let areaRatio = dv["A1"]! / dv["At"]!
        scales.append(dv["H"]!/dv["NU"]!)
        scales.append(dv["P0"]!)
        let HP0 = dv["H"]! * dv["P0"]!
        let LAMBDA1 = 1.0 - dv["PI"]! * (1.0 - dv["AM1A1"]!)
        let LAMBDA2 = 1 + dv["PI"]! * areaRatio/(1.0 - areaRatio)*(1.0 - dv["AM1A1"]!)
        scales.append(LAMBDA2 * dv["XI"]! * HP0 / dv["GAMMA"]!/dv["HB"]!)
        scales.append(LAMBDA1 * HP0/dv["GAMMA"]!/dv["AM1A1"]!)
        scales.append(LAMBDA2 * HP0/dv["GAMMA"]!*zeta/dv["AM2A2"]!)
        scales.append(LAMBDA1 * HP0/dv["AM1A1"]!)
        scales.append(LAMBDA2 * HP0*zeta/dv["AM2A2"]!)
        scales.append(LAMBDA1 * HP0/dv["AM1A1"]!)
        scales.append(LAMBDA2 * HP0 * zeta / dv["AM2A2"]!)
        return scales
        
    }
    
    func getVars() -> [String] {
        return modelVariables
    }

    
    func getNamesToPlots() -> [[String]] {
        return namesToPlots
    }
    
    func getVarsToPlots() -> [[Int]] {
        return varsToPlots
    }
    
    func getTotalsNamesToPlots() -> [[String]] {
        return namesToTotalPlots
    }
    
    func getTotalsVarsToPlots() -> [[Int]] {
        return totalsToPlots
    }
    
    func getDefaultParameters() -> [Parameter] {
        return defaultParams
    }

    func getDefaultDimensions() -> [Parameter] {
        return defaultDimensions
    }
    
    func getMaxTime() -> Double {
        return pvalues["endTime"]!
    }
    
    func getOutputTimeInterval() -> Double {
        return pvalues["outputTimeInterval"]!
    }

    func getInitialState() -> [Double] {
        let initial = getSteadyStateSolutions(pvalues)
        if let column = initialStateForSimulation {
            if column < initial.count {
            return initial[column]
            }
        }
        return initial[0]
    }
    
    func getSensitivity(nonDimensionalParam param: Parameter, numCalc: Int) -> (solutions: [[[Double]]], stability: [[Bool]], totals: [[[Double]]]) {
        var pv = pvalues
        var result = [[[Double]]]()
        var stabilityResults = [[Bool]]()
        var totalsResults = [[[Double]]]()
        let dparam = (param.maxValue! - param.minValue!) / Double(numCalc)
        var x = param.minValue!
        for _ in 0..<numCalc {
            pv[param.key] = x
            var solutions = getSteadyStateSolutions(pv)
            var stab = [Bool]()
            var tot = [[Double]]()
            for n in 0..<solutions.count {
                if solutions[n].count > 0 {
                    solutions[n][0] = x
                    let stabTemp = getStability(forPvalues: pv, state: solutions[n])
                    stab.append(stabTemp.stable)
                    let totalsTemp = calculateTotalAmounts(forNonDimensionalState: solutions[n], pv: pv)
                    tot.append(totalsTemp)
                }
            }
            result.append(solutions)
            stabilityResults.append(stab)
            totalsResults.append(tot)
            x = x + dparam
        }
        return (result, stabilityResults, totalsResults)
    }
    func getSensitivity(dimensionalParam dimParam: Parameter, numCalc: Int) -> (solutions: [[[Double]]], stability: [[Bool]], totals: [[[Double]]]) {
        var dv = dvalues
        var result = [[[Double]]]()
        var stabilityResults = [[Bool]]()
        var totalsResults = [[[Double]]]()
        let dparam = (dimParam.maxValue! - dimParam.minValue!) / Double(numCalc)
        var x = dimParam.minValue!
        for _ in 0..<numCalc {
            dv[dimParam.key] = x
            let pv = convertdvalues2pvalues(dv: dv)
            var solutions = getSteadyStateSolutions(pv)
            var stab = [Bool]()
            for n in 0..<solutions.count {
                if solutions[n].count > 0 {
                    solutions[n][0] = x
                    let stabTemp = getStability(forPvalues: pv, state: solutions[n])
                    stab.append(stabTemp.stable)
                }
            }
            var tot = [[Double]]()
            var dimSolution = [[Double]]()
            let scalingFactors = getScalingFactors(fromdvalues: dv)
            for solution in solutions {
                var ds = solution
                for i in 1...solution.count-1 {
                    ds[i] = solution[i] * scalingFactors[i]
                }
                let totalsTemp = calculateTotalAmounts(forDimensionalState: ds, dim: dv)
                tot.append(totalsTemp)
                dimSolution.append(ds)
            }
            result.append(dimSolution)
            stabilityResults.append(stab)
            totalsResults.append(tot)
            x = x + dparam
        }
        return (result, stabilityResults, totalsResults)
    }
    
    
    func getSteadyStateInitialSolution() -> [[Double]] {
         return getSteadyStateSolutions(pvalues)
    }
    
    
    func getCoefficients(_ state: [Double]) -> [[Double]] {
        var pv = pvalues
        if parameterForNoise != nil {
            let noise = RandomParameter()
            noise.parameterForNoise = parameterForNoise
            noise.returnPeriod = returnPeriod
            noise.noiseValue = noiseValue
            let out = noise.addNoise(pvalues)
            pv = out.newPvalues
            noiseValue = out.newNoiseValue
        }
        let p = state[1]
        let o2 = state[2]
        //        let c1 = state[3]
        //        let c2 = state[4]
        let b1 = state[5]
        let b2 = state[6]
        let i1 = state[7]
        let i2 = state[8]
        var load = loadScenario(nonDimensional: state[0])
        if realLoad {
            load = realLoadScenario(nonDimensional: state[0])
        }
        let LAMBDA1 = 1.0 - pv["pi"]! * (1.0 - pv["a1"]!)
        let LAMBDA2 = 1 + pv["pi"]! * pv["lambda"]!/(1.0 - pv["lambda"]!)*(1.0 - pv["a1"]!)
        let alpha1 = pv["alphaPlus"]! * hstep(pv["chi"]!) + pv["alphaMinus"]! * (1.0 - hstep(pv["chi"]!))
        let beta1 = pv["betaPlus"]! * hstep(pv["chi"]!) + pv["betaMinus"]! * (1.0 - hstep(pv["chi"]!))
        let alpha2 = pv["alphaPlus"]! * hstep(o2) + pv["alphaMinus"]! * (1.0 - hstep(o2))
        let beta2 = pv["betaPlus"]! * hstep(o2) + pv["betaMinus"]! * (1.0 - hstep(o2))
        let tanhm = -tanh(-pv["m"]!)
        let delta1 = pv["mu1"]! / 2.0 * max(tanhm + tanh(pv["kappa1"]! * pv["chi"]! / p - pv["m"]!), 0.0) - i1
        var rho = pv["rhoRelease"]!
        if delta1 > 0 {
            rho = pv["rhoUptake"]!
        }
        let phivar1 = min(alpha1 * beta1 * pv["regenerationRate1"]! * b1, rho * delta1)
        let tanTemp = tanh(pv["kappa2"]! * o2 / p - pv["m"]!)
        let delta2 = pv["mu2"]! / 2.0 * max(tanhm + tanTemp, 0.0) - i2
        if delta2 > 0 {
            rho = pv["rhoUptake"]!
        } else {
            rho = pv["rhoRelease"]!
        }
        let phivar2 = min(alpha2 * beta2 * pv["regenerationRate2"]! * b2, rho * delta2)
        let dt = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, pv["timeStep"]!]
        let dp = [0.0, -pv["exchangeRate"]! - pv["qf"]! - pv["lambda"]! * LAMBDA1 - pv["zeta"]! * (1.0 - pv["lambda"]!) * LAMBDA2, 0.0, 0.0, 0.0, pv["lambda"]! * LAMBDA1 * alpha1 * beta1 * pv["regenerationRate1"]!, (1.0 - pv["lambda"]!) * LAMBDA2 * pv["zeta"]! * alpha2 * beta2 * pv["regenerationRate2"]!, 0.0, 0.0, load + pv["exchangeRate"]! * pv["psi"]! - pv["lambda"]! * LAMBDA1 * phivar1 - (1.0 - pv["lambda"]!) * LAMBDA2 * pv["zeta"]! * phivar2]
        let do2 = [0.0, -1 + pv["zeta"]!, -pv["mixingRate"]!, 0.0, -pv["zeta"]! * alpha2 * pv["regenerationRate2"]!, 0.0, 0.0, 0.0, 0.0, pv["mixingRate"]! * pv["chi"]!]
        let dc1 = [0.0, 1.0, 0.0, -alpha1 * pv["regenerationRate1"]! - pv["burialRate1"]!, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
        let dc2 = [0.0, 1.0, 0.0, 0.0, -alpha2 * pv["regenerationRate2"]! - pv["burialRate2"]!, 0.0, 0.0, 0.0, 0.0, 0.0]
        let db1 = [0.0, 1.0, 0.0, 0.0, 0.0, -alpha1 * beta1 * pv["regenerationRate1"]! - pv["burialRate1"]!, 0.0, 0.0, 0.0, 0.0]
        let db2 = [0.0, 1.0, 0.0, 0.0, 0.0, 0.0, -alpha2 * beta2 * pv["regenerationRate2"]! - pv["burialRate2"]!, 0.0, 0.0, 0.0]
        let di1 = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -pv["burialFe"]!, 0.0, phivar1]
        let di2 = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -pv["burialFe"]!, phivar2]
        return [dt, dp, do2, dc1, dc2, db1, db2, di1, di2]
    }
    
     func o2FuncRange() -> (oxygen: [Double], funcValues: [Double]) {
        let maxPoints = 500
        var o2 = [Double]()
        var f = [Double]()
        if findO2SteadyStateParams != nil {
            findO2SteadyStateParams?.maxValue! = pvalues["chi"]!*0.99
            var x = findO2SteadyStateParams!.minValue!
            let dx = (findO2SteadyStateParams!.maxValue! - findO2SteadyStateParams!.minValue!) / Double(maxPoints)
            for _ in 0..<maxPoints {
                f.append(o2Func(x, pv: pvalues))
                o2.append(x)
                x += dx
            }
        }
        return (oxygen: o2, funcValues: f)
    }
    
    func getLoad(for time: Double, dimensional: Bool) -> Double {
        if realLoad {
            if dimensional {
                return realLoadScenario(dimensionalTime: time)
            } else {
                return realLoadScenario(nonDimensional: time)
            }
        } else {
            if dimensional {
                return loadScenario(dimensional: time)
            } else {
                return loadScenario(nonDimensional: time)
            }
        }
    }

    func getTotalAmounts(forInitial state: [Double]) -> [Double] {
        let result = calculateTotalAmounts(forNonDimensionalState: state, pv: pvalues)
        return result
    }

    
     func getTotalAmounts(forModelTimeSeries output: [[Double]], dimensional: Bool) -> (dataToPlot: [[Double]], variablesToPlot: [[Int]], namesToPlot: [[String]]) {
        
        var result = [[Double]]()
        if dimensional {
            result = calculateTotalAmounts(forDimensionalOutput: output)
        } else {
            result = calculateTotalAmounts(forNonDimensionalOutput: output)
        }
        return (result, totalsToPlots, namesToTotalPlots)
    }
    
    fileprivate func getTotalAmounts(forSteadyState state: [Double], dimensional: Bool, pv: [String: Double]) -> (dataToPlot: [Double], variablesToPlot: [[Int]], namesToPlot: [[String]]) {
        var result = [Double]()
        if dimensional {
            result = calculateTotalAmounts(forDimensionalState: state, dim: pv)
        } else {
            result = calculateTotalAmounts(forNonDimensionalState: state, pv: pv)
       }
        return (result, totalsToPlots, namesToTotalPlots)
    }

    fileprivate func calculateTotalAmounts(forNonDimensionalOutput output: [[Double]]) -> [[Double]] {
        var totals = [[Double]]()
        let pv = pvalues
        for row in output {
            let tot = calculateTotalAmounts(forNonDimensionalState: row, pv: pv)
            totals.append(tot)
        }
        return totals
    }

    fileprivate func calculateTotalAmounts(forDimensionalOutput output: [[Double]]) -> [[Double]] {
        var totals = [[Double]]()
        let dim = dvalues
        for row in output {
            let tot = calculateTotalAmounts(forDimensionalState: row, dim: dim)
            totals.append(tot)
        }
        return totals
    }
    fileprivate func calculateTotalAmounts(forNonDimensionalState state: [Double], pv: [String: Double]) -> [Double] {
        var tot = [Double]()
        let LAMBDA1 = 1.0 - pv["pi"]! * (1.0 - pv["a1"]!)
        let LAMBDA2 = 1 + pv["pi"]! * pv["lambda"]!/(1.0 - pv["lambda"]!)*(1.0 - pv["a1"]!)
        tot.append(state.first!)
        let p = state[1]
        let b1 = state[5]
        let b2 = state[6]
        let i1 = state[7]
        let i2 = state[8]
        let totPelagic = p
        let totOrgBen = b1 * pv["lambda"]! * LAMBDA1 + b2 * (1 - pv["lambda"]!) * LAMBDA2 * pv["zeta"]!
        let totInorgBen = i1 * pv["lambda"]! * LAMBDA1 + i2 * (1 - pv["lambda"]!) * LAMBDA2 * pv["zeta"]!
        tot.append(totPelagic)
        tot.append(totOrgBen)
        tot.append(totInorgBen)
        tot.append(totPelagic + totOrgBen + totInorgBen)
        return tot
    }
    fileprivate func calculateTotalAmounts(forDimensionalState state: [Double], dim: [String: Double]) -> [Double] {
        let factor = 31.0e-3
        var tot = [Double]()
        tot.append(state.first!)
        let p = state[1]
        let b1 = state[5]
        let b2 = state[6]
        let i1 = state[7]
        let i2 = state[8]
        let totPelagic = (p * dim["H"]! * dim["At"]!) * factor
        let totOrgBen = (b1 * dim["A1"]! * dim["AM1A1"]! + b2 * (dim["At"]! - dim["A1"]!) * dim["AM2A2"]!) * factor
        let totInorgBen = (i1 * dim["A1"]! * dim["AM1A1"]! + i2 * (dim["At"]! - dim["A1"]!) * dim["AM2A2"]!) * factor
        tot.append(totPelagic)
        tot.append(totOrgBen)
        tot.append(totInorgBen)
        tot.append(totPelagic + totOrgBen + totInorgBen)
        return tot
    }

    fileprivate func loadScenario(nonDimensional time: Double) -> Double {
        let tstart = pvalues["startOfScenario"]!
        let tend = pvalues["endOfScenario"]!
        let lstart = pvalues["initialLoad"]!
        let lend = pvalues["finalLoad"]!
        if tend > tstart {
            return (lend - lstart) * min(max((time - tstart)/(tend - tstart), 0.0), 1.0) + lstart
        } else {
            return lstart
        }
    }
    fileprivate func loadScenario(dimensional time: Double) -> Double {
        let nu = dvalues["NU"]!
        let tau = dvalues["H"]! / nu
        let ton2mmolperm2 = 1.0e3 / 31.0 / dvalues["At"]! / dvalues["P0"]! / dvalues["H"]! * tau
        let nonDimensionalTime = time / tau
        let tstart = pvalues["startOfScenario"]!
        let tend = pvalues["endOfScenario"]!
        let lstart = pvalues["initialLoad"]!
        let lend = pvalues["finalLoad"]!
        if tend > tstart {
            return ((lend - lstart) * min(max((nonDimensionalTime - tstart)/(tend - tstart), 0.0), 1.0) + lstart)/ton2mmolperm2
        } else {
            return lstart/ton2mmolperm2
        }
    }

    fileprivate func realLoadScenario(nonDimensional time: Double) -> Double {
        let nu = dvalues["NU"]!
        let tau = dvalues["H"]! / nu
        let ton2mmolperm2 = 1.0e3 / 31.0 / dvalues["At"]! / dvalues["P0"]! / dvalues["H"]! * tau
        let dimensionalTime = tau * time
        let dimensionalLoad = realLoadScenario(dimensionalTime: dimensionalTime)
        return dimensionalLoad * ton2mmolperm2
    }
    static func getRealLoad() -> [Double] {
        var loads = [Double]()
        if let fileContent = try? String.init(contentsOfFile: Bundle.main.resourcePath! + "/TPload1900_2017.csv") {
            let rows = fileContent.components(separatedBy: "\r\n")
            for row in rows {
                if let load = Double(row) {
                    loads.append(load)
                }
            }
        }
        return loads
    }
    static let realLoads = getRealLoad()
    
    fileprivate func realLoadScenario(dimensionalTime time: Double) -> Double {
        
        let index = Int(time)
        let loads = ModifiedAlphaModel.realLoads
        if loads.count > index + 2 {
            return loads[index] + (time - Double(index)) * (loads[index+1] - loads[index])
        } else {
            return loads.last!
        }
    }

//    fileprivate func realLoadScenario(dimensionalTime time: Double) -> Double {
////        let slopes = [200.0, 950.0, 1300.0, 0.0]
////        let intercepts = [10000.0, 20000.0, 39000.0, 52000.0]
//        let slopes = [200.0, 950.0, 1300.0, -1091.0]
//        let intercepts = [10000.0, 20000.0, 39000.0, 52000.0]
//        let years = [50.0, 70.0, 80.0, 103.0]
//
//       if time < years[0] {
//            return slopes[0] * time + intercepts[0]
//        } else if time < years[1] {
//            return slopes[1] * (time - years[0]) + intercepts[1]
//        } else if time < years[2] {
//            return slopes[2] * (time - years[1]) + intercepts[2]
//        } else if time < years[3] {
//            return slopes[3] * (time - years[2]) + intercepts[3]
//        } else {
//            return slopes[3] * (years[3] - years[2]) + intercepts[3]
//        }
//    }
    
    fileprivate func getSteadyStateSolutions(_ pv : [String: Double]) -> [[Double]] {
        var solutions = [[Double]]()
        var pv2 = pv
        if realLoad {
            pv2["initialLoad"] = realLoadScenario(nonDimensional: 0.0)
        }
        let o2Result = findO2(pv2)
        
        for o2 in o2Result {
            solutions.append(getStateForO2(o2, pv: pv2))
        }
        return solutions
    }
    
    fileprivate func getStateForO2(_ o2: Double, pv: [String: Double]) -> [Double] {
        var state = [Double]()
        let alpha1 = pv["alphaPlus"]! * hstep(pv["chi"]!) + pv["alphaMinus"]! * (1.0 - hstep(pv["chi"]!))
        let beta1 = pv["betaPlus"]! * hstep(pv["chi"]!) + pv["betaMinus"]! * (1.0 - hstep(pv["chi"]!))
        let alpha2 = pv["alphaPlus"]! * hstep(o2) + pv["alphaMinus"]! * (1.0 - hstep(o2))
        let beta2 = pv["betaPlus"]! * hstep(o2) + pv["betaMinus"]! * (1.0 - hstep(o2))
        let theta1 = alpha1 * pv["regenerationRate1"]! / (alpha1 * pv["regenerationRate1"]! + pv["burialRate1"]!)
        let theta2 = alpha2 * pv["regenerationRate2"]! / (alpha2 * pv["regenerationRate2"]! + pv["burialRate2"]!)
        let eta1 = alpha1 * beta1 * pv["regenerationRate1"]! / (alpha1 * beta1 * pv["regenerationRate1"]! + pv["burialRate1"]!)
        let eta2 = alpha2 * beta2 * pv["regenerationRate2"]! / (alpha2 * beta2 * pv["regenerationRate2"]! + pv["burialRate2"]!)
        var i1 = 0.0
        var i2 = 0.0
        let rho = pv["rhoUptake"]!
        if o2 < pv["chi"]! {
            let q1 = pv["kappa1"]! * (pv["zeta"]! * theta2 + 1 - pv["zeta"]!) * pv["chi"]! / (pv["mixingRate"]! * (pv["chi"]! - o2)) - pv["m"]!
            let q2 = pv["kappa2"]! * (pv["zeta"]! * theta2 + 1 - pv["zeta"]!) * o2 / (pv["mixingRate"]! * (pv["chi"]! - o2)) - pv["m"]!
            let tanhm = -tanh(-pv["m"]!)
            let rhoFrac = rho/(rho + pv["burialFe"]!)
            i1 = rhoFrac * pv["mu1"]! / 2.0 * max(tanhm + tanh(q1),0.0)
            i2 = rhoFrac * pv["mu2"]! / 2.0 * max(tanhm + tanh(q2),0.0)
        } else {
            i1 = rho/(rho + pv["burialFe"]!) * pv["mu1"]!
            i2 = rho/(rho + pv["burialFe"]!) * pv["mu2"]!
        }
        if pv["burialFe"]! > 0 {
            i1 = min(i1, eta1 * pv["mixingRate"]! * (pv["chi"]! - o2) / (pv["zeta"]! * theta2 + 1 - pv["zeta"]!) / pv["burialFe"]!)
            i2 = min(i2, eta2 * pv["mixingRate"]! * (pv["chi"]! - o2) / (pv["zeta"]! * theta2 + 1 - pv["zeta"]!) / pv["burialFe"]!)
        }
        let p = pv["mixingRate"]! * (pv["chi"]! - o2) / (pv["zeta"]! * theta2 + 1 - pv["zeta"]!)
        let c1 = theta1 * p / (alpha1 * pv["regenerationRate1"]!)
        let c2 = theta2 * p / (alpha2 * pv["regenerationRate2"]!)
        let b1 = eta1 * p / (alpha1 * beta1 * pv["regenerationRate1"]!)
        let b2 = eta2 * p / (alpha2 * beta2 * pv["regenerationRate2"]!)
        state.append(0.0)
        state.append(p)
        state.append(o2)
        state.append(c1)
        state.append(c2)
        state.append(b1)
        state.append(b2)
        state.append(i1)
        state.append(i2)
        return state
    }
    
    fileprivate func findO2(_ pv: [String: Double]) -> [Double] {
        var roots = [Double]()
        struct Interval {
            var o2min: Double
            var o2max: Double
        }
        var intervals = [Interval]()
        let nCalc = 4
        let o2max = pv["chi"]! * 0.99
        let o2min = -100.0
        intervals.append(Interval(o2min: o2min, o2max: o2max))
        var rootFound = true
        while rootFound {
            var newIntervals = [Interval]()
            rootFound = false
            for interval in intervals {
                if let o2 = bisection(interval.o2min, o2maximum: interval.o2max, pv: pv) {
                    roots.append(o2)
                    rootFound = true
                }
            }
            if !roots.isEmpty {
                roots.sort()
                var diff = (roots.first! - o2min) / Double(nCalc)
                for i in 0..<nCalc {
                    newIntervals.append(Interval(o2min: o2min + diff * Double(i), o2max: o2min + diff * Double(i + 1)))
                }
//                newIntervals.append(Interval(o2min: o2min, o2max: roots.first!))
                for n in 0..<roots.count-1 {
                    diff = (roots[n+1] - roots[n]) / Double(nCalc)
                    for i in 0..<nCalc {
                        newIntervals.append(Interval(o2min: roots[n] + diff * Double(i), o2max: roots[n] + diff * Double(i + 1)))
                    }
//                    newIntervals.append(Interval(o2min: roots[n], o2max: roots[n+1]))
                }
                diff = (o2max - roots.last!) / Double(nCalc)
                for i in 0..<nCalc {
                    newIntervals.append(Interval(o2min: roots.last! + diff * Double(i), o2max: roots.last! + diff * Double(i + 1)))
                }
//                newIntervals.append(Interval(o2min: roots.last!, o2max: o2max))
            }
            if !newIntervals.isEmpty {
                intervals = newIntervals
                newIntervals = []
            } else {
                rootFound = false
            }
        }
        return roots
    }
    
    
    fileprivate func bisection(_ o2minimum: Double, o2maximum: Double, pv: [String: Double]) -> Double? {
        let eps = 1.0e-8
        var o2min = o2minimum
        var o2max = o2maximum
        var f1 = o2Func(o2max, pv: pv)
        var f2 = o2Func(o2min, pv: pv)
        while abs(o2max - o2min) > eps {
            let o2 = 0.5 * (o2max + o2min)
            let fnew = o2Func(o2, pv: pv)
            if f1 * fnew < 0 {
                f2 = fnew
                o2min = o2
            } else if f2 * fnew < 0 {
                f1 = fnew
                o2max = o2
            } else {
                break
            }
        }
        let o2 = 0.5 * (o2min + o2max)
        if abs(o2max-o2min) < eps && o2 > o2minimum + eps && o2 < o2maximum - eps {
            return o2
        } else {
            return nil
        }
    }
    fileprivate func o2Func(_ o2: Double, pv: [String: Double]) -> Double {
        let alpha1 = pv["alphaPlus"]! * hstep(pv["chi"]!) + pv["alphaMinus"]! * (1.0 - hstep(pv["chi"]!))
        let beta1 = pv["betaPlus"]! * hstep(pv["chi"]!) + pv["betaMinus"]! * (1.0 - hstep(pv["chi"]!))
        let alpha2 = pv["alphaPlus"]! * hstep(o2) + pv["alphaMinus"]! * (1.0 - hstep(o2))
        let beta2 = pv["betaPlus"]! * hstep(o2) + pv["betaMinus"]! * (1.0 - hstep(o2))
        let theta2 = alpha2 * pv["regenerationRate2"]! / (alpha2 * pv["regenerationRate2"]! + pv["burialRate2"]!)
        let eta1 = alpha1 * beta1 * pv["regenerationRate1"]! / (alpha1 * beta1 * pv["regenerationRate1"]! + pv["burialRate1"]!)
        let eta2 = alpha2 * beta2 * pv["regenerationRate2"]! / (alpha2 * beta2 * pv["regenerationRate2"]! + pv["burialRate2"]!)
        var phi1 = 0.0
        var phi2 = 0.0
        let p0 = pv["mixingRate"]! * (pv["chi"]! - o2) / (pv["zeta"]! * theta2 + 1 - pv["zeta"]!)
        if o2 < pv["chi"]! {
            let q1 = pv["kappa1"]! * pv["chi"]! / p0 - pv["m"]!
            let q2 = pv["kappa2"]! * o2 / p0 - pv["m"]!
            let tanhm = -tanh(-pv["m"]!)
            let delta1 = pv["burialFe"]!/(pv["rhoUptake"]! + pv["burialFe"]!) * pv["mu1"]! / 2.0 * max(tanhm + tanh(q1),0.0)
            let delta2 = pv["burialFe"]!/(pv["rhoUptake"]! + pv["burialFe"]!) * pv["mu2"]! / 2.0 * max(tanhm + tanh(q2),0.0)
            phi1 = min(pv["rhoUptake"]! * delta1, eta1 * p0)
            phi2 = min(pv["rhoUptake"]! * delta2, eta2 * p0)
        }
        let LAMBDA1 = 1.0 - pv["pi"]! * (1.0 - pv["a1"]!)
        let LAMBDA2 = 1 + pv["pi"]! * pv["lambda"]!/(1.0 - pv["lambda"]!)*(1.0 - pv["a1"]!)
        let a : Double = (pv["zeta"]! * theta2 + 1.0 - pv["zeta"]!) * (pv["initialLoad"]! + pv["exchangeRate"]! * pv["psi"]! - pv["lambda"]! * LAMBDA1 * phi1 - pv["zeta"]! * (1.0 - pv["lambda"]!) * LAMBDA2 * phi2)
        let b = pv["exchangeRate"]! + pv["qf"]! + pv["lambda"]! * LAMBDA1 * (1.0 - eta1) + pv["zeta"]! * (1.0 - pv["lambda"]!) * LAMBDA2 * (1.0 - eta2)
        let o2new = pv["chi"]! - a / b / pv["mixingRate"]!
        //(pv["zeta"]! * theta2 + 1.0 - pv["zeta"]!) * (pv["initialLoad"]! + pv["exchangeRate"]! * pv["psi"]! - pv["lambda"]! * phi1 - pv["zeta"]! * (1.0 - pv["lambda"]!) * phi2)/(pv["mixingRate"]! * (pv["exchangeRate"]! + pv["lambda"]! * (1.0 - eta1) + pv["zeta"]! * (1.0 - pv["lambda"]!) * (1.0 - eta2)))
        return o2 - o2new
    }
    
    fileprivate func jacobian(_ state: [Double], pv: [String: Double]) -> [[Double]] {
        let p = state[1]
        let o2 = state[2]
//        let c1 = state[3]
        let c2 = state[4]
        let b1 = state[5]
        let b2 = state[6]
        let i1 = state[7]
        let i2 = state[8]
        let LAMBDA1 = 1.0 - pv["pi"]! * (1.0 - pv["a1"]!)
        let LAMBDA2 = 1 + pv["pi"]! * pv["lambda"]!/(1.0 - pv["lambda"]!)*(1.0 - pv["a1"]!)
        let alpha1 = pv["alphaPlus"]! * hstep(pv["chi"]!) + pv["alphaMinus"]! * (1.0 - hstep(pv["chi"]!))
        let beta1 = pv["betaPlus"]! * hstep(pv["chi"]!) + pv["betaMinus"]! * (1.0 - hstep(pv["chi"]!))
        let alpha2 = pv["alphaPlus"]! * hstep(o2) + pv["alphaMinus"]! * (1.0 - hstep(o2))
        let beta2 = pv["betaPlus"]! * hstep(o2) + pv["betaMinus"]! * (1.0 - hstep(o2))
        let q1 = pv["kappa1"]! * pv["chi"]! / p - pv["m"]!
        let delta1 = pv["mu1"]! / 2.0 * max(-tanh(-pv["m"]!) + tanh(q1), 0.0) - i1
        var dphidp1 : Double = 0.0
        var dphidi1 = 0.0
        var dphidb1 = 0.0
        if alpha1 * beta1 * pv["regenerationRate1"]! * b1 > pv["rhoUptake"]! * delta1 {
            let tanh2 = pow(tanh(q1),2.0)
            dphidp1 = -pv["rhoUptake"]! * pv["mu1"]! * pv["kappa1"]! * pv["chi"]!/(2.0 * p * p) * (1.0 - tanh2)
            dphidi1 = -pv["rhoUptake"]!
        } else {
            dphidb1 = alpha1 * beta1 * pv["regenerationRate1"]!
        }
        let q2 = pv["kappa2"]! * o2 / p - pv["m"]!
        let delta2 = pv["mu2"]! / 2.0 * max(-tanh(-pv["m"]!) + tanh(q2), 0.0) - i2
        let dalphado2 = (pv["alphaPlus"]! - pv["alphaMinus"]!) * dirac(o2)
        let dbetado2 = (pv["betaPlus"]! - pv["betaMinus"]!) * dirac(o2)
        let dalphabetado2 = alpha2 * dbetado2 + beta2 * dalphado2
        var dphidp2 : Double = 0.0
        var dphido2 = 0.0
        var dphidi2 = 0.0
        var dphidb2 = 0.0
        if alpha2 * beta2 * pv["regenerationRate2"]! * b2 > pv["rhoUptake"]! * delta2 {
            let tanh2 = pow(tanh(q2),2.0)
            dphidp2 = -pv["rhoUptake"]! * pv["mu2"]! * pv["kappa2"]! * o2/(2.0 * p * p) * (1.0 - tanh2)
            dphido2 = pv["rhoUptake"]! * pv["mu2"]! * pv["kappa2"]!/(2.0 * p ) * (1.0 - tanh2)
            dphidi2 = -pv["rhoUptake"]!
        } else {
            dphidb2 = alpha2 * beta2 * pv["regenerationRate2"]!
            dphido2 = pv["regenerationRate2"]! * b2 * dalphabetado2
        }
        
        let minusExchangeRate : Double = -pv["exchangeRate"]! - pv["qf"]!
        let lambda : Double = pv["lambda"]!
        let J11a : Double = minusExchangeRate - lambda * LAMBDA1 * (1.0 + dphidp1)
        let J11b : Double = -pv["zeta"]! * (1.0 - lambda) * LAMBDA2 * (1.0 + dphidp2)
        let J1 : [Double] = [J11a + J11b,
                  -pv["zeta"]! * (1.0 - pv["lambda"]!) * LAMBDA2 * (dphido2 - pv["regenerationRate2"]! * b2 * dalphabetado2),
                  0.0,
                  0.0,
                  pv["lambda"]! * LAMBDA1 * (alpha1 * beta1 * pv["regenerationRate1"]! - dphidb1),
                  pv["zeta"]! * (1.0 - pv["lambda"]!) * LAMBDA2 * (alpha2 * beta2 * pv["regenerationRate2"]! - dphidb2),
                  -pv["lambda"]! * LAMBDA1 * dphidi1,
                  -pv["zeta"]! * (1.0 - pv["lambda"]!) * LAMBDA2 * dphidi2]
        let J2 : [Double] = [ -(1.0 - pv["zeta"]!),
                              -pv["mixingRate"]! - pv["zeta"]! * pv["regenerationRate2"]! * c2 * dalphado2,
                              0.0,
                              -pv["zeta"]! * alpha2 * pv["regenerationRate2"]!,
                              0.0,
                              0.0,
                              0.0,
                              0.0]
        let J3 : [Double] = [ 1.0, 0.0,
                              -alpha1 * pv["regenerationRate1"]! - pv["burialRate1"]!,
                              0.0,
                              0.0,
                              0.0,
                              0.0,
                              0.0]
        let J4 : [Double] = [ 1.0,
                              -pv["regenerationRate2"]! * c2 * dalphado2,
                              0.0,
                              -alpha2 * pv["regenerationRate2"]! - pv["burialRate2"]!,
                              0.0,
                              0.0,
                              0.0,
                              0.0]
        let J5 : [Double] = [ 1.0, 0.0,
                              0.0,
                              0.0,
                              -alpha1 * beta1 * pv["regenerationRate1"]! - pv["burialRate1"]!,
                              0.0,
                              0.0,
                              0.0]
        let J6 : [Double] = [ 1.0,
                              -pv["regenerationRate2"]! * b2 * dalphabetado2,
                              0.0,
                              0.0,
                              0.0,
                              -alpha2 * beta2 * pv["regenerationRate2"]! - pv["burialRate2"]!,
                              0.0,
                              0.0]
        let J7 :[Double] = [dphidp1, 0.0, 0.0, 0.0,
                            dphidb1, 0.0,
                            dphidi1 - pv["burialFe"]!, 0.0]
        let J8 : [Double] = [dphidp2, dphido2, 0.0, 0.0, 0.0,
                             dphidb2, 0.0,
                             dphidi2 - pv["burialFe"]!]
        let J : [[Double]] = [J1, J2, J3, J4, J5, J6, J7, J8]
        return J
    }
    
    fileprivate func obtainEquationFromJacobian(_ J: [[Double]]) -> [Double] {
        var a = [Double]()
        //First component
        let c1 : [Double] = [J[0][0],J[1][1],J[3][3],J[4][4],J[5][5],J[6][6],J[7][7]]
        let a1 = binominalType(c1, sign: -1)
        
        let c2 : [Double] = [J[0][0],J[4][4],J[5][5],J[6][6],J[7][7]]
        let f2 = -J[1][3] * J[3][1]
        let t2 = binominalType(c2, sign: -1)
        var a2 = [Double]()
        for t in t2 {
            a2.append(t * f2)
        }
        
        let c3 : [Double] = [J[3][3],J[4][4],J[5][5],J[6][6],J[7][7]]
        let f3 = -J[0][1] * J[1][0]
        let t3 = binominalType(c3, sign: -1)
        var a3 = [Double]()
        for t in t3 {
            a3.append(t * f3)
        }
        
        let c4 : [Double] = [J[1][1],J[3][3],J[5][5],J[6][6],J[7][7]]
        let f4 = -J[0][4]
        let t4 = binominalType(c4, sign: -1)
        var a4 = [Double]()
        for t in t4 {
            a4.append(t * f4)
        }
        
        let c5 : [Double] = [J[1][1],J[3][3],J[4][4],J[6][6],J[7][7]]
        let f5 = -J[0][5]
        let t5 = binominalType(c5, sign: -1)
        var a5 = [Double]()
        for t in t5 {
            a5.append(t * f5)
        }
        
        let c6 : [Double] = [J[1][1],J[3][3],J[4][4],J[5][5],J[7][7]]
        let f6 = -J[0][6] * J[6][0]
        let t6 = binominalType(c6, sign: -1)
        var a6 = [Double]()
        for t in t6 {
            a6.append(t * f6)
        }
        
        let c7 : [Double] = [J[1][1],J[3][3],J[4][4],J[5][5],J[6][6]]
        let f7 = -J[0][7] * J[7][0]
        let t7 = binominalType(c7, sign: -1)
        var a7 = [Double]()
        for t in t7 {
            a7.append(t * f7)
        }
        
        let c8 : [Double] = [J[4][4],J[5][5],J[6][6],J[7][7]]
        let f8 = J[0][1] * J[1][3]
        let t8 = binominalType(c8, sign: -1)
        var a8 = [Double]()
        for t in t8 {
            a8.append(t * f8)
        }
        
        let c9 : [Double] = [J[3][3],J[4][4],J[6][6],J[7][7]]
        let f9 = J[0][5] * J[1][0] * J[5][1]
        let t9 = binominalType(c9, sign: -1)
        var a9 = [Double]()
        for t in t9 {
            a9.append(t * f9)
        }
        
        let c10 : [Double] = [J[1][1],J[4][4],J[6][6],J[7][7]]
        let f10 = J[0][5] * J[3][1]
        let t10 = binominalType(c10, sign: -1)
        var a10 = [Double]()
        for t in t10 {
            a10.append(t * f10)
        }
        
        let c11 : [Double] = [J[1][1],J[3][3],J[5][5],J[7][7]]
        let f11 = J[0][6] * J[6][4]
        let t11 = binominalType(c11, sign: -1)
        var a11 = [Double]()
        for t in t11 {
            a11.append(t * f11)
        }
        
        let c12 : [Double] = [J[1][1],J[4][4],J[5][5],J[7][7]]
        let f12 = J[0][6] * J[3][1] * J[6][0]
        let t12 = binominalType(c12, sign: -1)
        var a12 = [Double]()
        for t in t12 {
            a12.append(t * f12)
        }
        
        let c13 : [Double] = [J[3][3],J[4][4],J[5][5],J[6][6]]
        let f13 = J[0][7] * J[1][0] * J[7][1]
        let t13 = binominalType(c13, sign: -1)
        var a13 = [Double]()
        for t in t13 {
            a13.append(t * f13)
        }
        
        let c14 : [Double] = [J[1][1],J[3][3],J[4][4],J[6][6]]
        let f14 = J[0][7] * J[7][5]
        let t14 = binominalType(c14, sign: -1)
        var a14 = [Double]()
        for t in t14 {
            a14.append(t * f14)
        }
        
        let c15 : [Double] = [J[5][5],J[6][6],J[7][7]]
        let f15 = J[0][4] * J[1][3] * J[3][1] * J[4][0]
        let t15 = binominalType(c15, sign: -1)
        var a15 = [Double]()
        for t in t15 {
            a15.append(t * f15)
        }
        
        let c16 : [Double] = [J[4][4],J[6][6],J[7][7]]
        let f16 = -J[0][5] * J[1][3] * J[5][1]
        let t16 = binominalType(c16, sign: -1)
        var a16 = [Double]()
        for t in t16 {
            a16.append(t * f16)
        }
        let c17 : [Double] = [J[3][3],J[4][4],J[6][6]]
        let f17 = -J[0][7] * J[1][0] * J[5][1] * J[7][5]
        let t17 = binominalType(c17, sign: -1)
        var a17 = [Double]()
        for t in t17 {
            a17.append(t * f17)
        }
        
        let c18 : [Double] = [J[4][4],J[5][5],J[6][6]]
        let f18 = J[0][7] * J[1][3] * (J[3][1] * J[7][0] - J[7][1])
        let t18 = binominalType(c18, sign: -1)
        var a18 = [Double]()
        for t in t18 {
            a18.append(t * f18)
        }
        
        let c19 : [Double] = [J[5][5],J[7][7]]
        let f19 = -J[0][6] * J[1][3] * J[3][1] * J[6][4]
        let t19 = binominalType(c19, sign: -1)
        var a19 = [Double]()
        for t in t19 {
            a19.append(t * f19)
        }
        
        let c20 : [Double] = [J[4][4],J[6][6]]
        let f20 = J[0][7] * J[1][3] * (J[5][1] - J[3][1]) * J[7][5]
        let t20 = binominalType(c20, sign: -1)
        var a20 = [Double]()
        for t in t20 {
            a20.append(t * f20)
        }
        for i in 0...2 {
            let atemp = a1[i] + a2[i] + a3[i] + a4[i] + a5[i] + a6[i] + a7[i] + a8[i] + a9[i] + a10[i] + a12[i] + a13[i] + a14[i] + a15[i] + a16[i] + a17[i] + a18[i] + a19[i] + a20[i]
            a.append(atemp)
        }
        a.append(a1[3] + a2[3] + a3[3] + a4[3] + a5[3] + a6[3] + a7[3] + a8[3] + a9[3] + a10[3] + a11[3] + a12[3] + a13[3] + a14[3] + a15[3] + a16[3] + a17[3] + a18[3])
        a.append(a1[4] + a2[4] + a3[4] + a4[4] + a5[4] + a6[4] + a7[4] + a8[4] + a9[4] + a10[4] + a11[4] + a12[4] + a13[4] + a14[4])
        a.append(a1[5] + a2[5] + a3[5] + a4[5] + a5[5] + a6[5] + a7[5] + a7[5] + a7[5])
        a.append(a1[6])
        a.append(a1[7])
        return a
    }
    
    func getStability(forState state: [Double]) -> (roots: [Complex], stable: Bool) {
        let pv = pvalues
        let J = jacobian(state, pv: pv)
        let a = obtainEquationFromJacobian(J)
        let myRoots = Roots()
        for x in a {
            myRoots.coefficients.append(Complex(real: x, imaginary: 0.0))
        }
        var roots = myRoots.zroots()
        roots.append(Complex(real: J[2][2], imaginary: 0.0)) //Adding the trivial eigthst root
        var stable = true
        print("New Roots")
        for root in roots {
            if root.real > 0 {
                stable = false
                print(niceString(root))
            }
        }
        return (roots, stable)
    }
    fileprivate func getStability(forPvalues pv: [String: Double], state: [Double]) -> (roots: [Complex], stable: Bool) {
//        let pv = pvalues
        let J = jacobian(state, pv: pv)
        let a = obtainEquationFromJacobian(J)
        let myRoots = Roots()
        for x in a {
            myRoots.coefficients.append(Complex(real: x, imaginary: 0.0))
        }
        var roots = myRoots.zroots()
        roots.append(Complex(real: J[2][2], imaginary: 0.0)) //Adding the trivial eigthst root
        var stable = true
        print("New roots")
        for root in roots {
            if root.real > 0 {
                stable = false
                print(niceString(root))
            }
        }
        return (roots, stable)
    }

}
