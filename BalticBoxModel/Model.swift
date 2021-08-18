
//
//  Model.swift
//  boxModel
//
//  Created by Bo Gustafsson on 28/04/16.
//  Copyright © 2016 BNI. All rights reserved.
//

import Foundation


class Model {
    
    var state = [Double]()
    fileprivate var newState = [Double]()
    var output = [[Double]]()
    var scalingFactors : [Double]? = nil
    var initialValues: (()->[Double])?
    var coefficients: (([Double]) -> [[Double]])?
    var maxTime: (() -> Double)?
    var outputTimeInterval: (() -> Double)?
    
    func initiateModel() {
        state = initialValues!()
        newState = state
        if scalingFactors == nil {
            scalingFactors = []
            for _ in state {
                scalingFactors!.append(1.0)
            }
        }
        output.removeAll()
    }
    func iterateModel() {
        
        var coef = coefficients!(state)
        let dt0 = (coef.first!.last)!

        let interval = Int(outputTimeInterval!()/dt0)
        var i = 0
        while state[0] < maxTime!() {
            coef = coefficients!(state)
            if i%interval == 0 {
                var s = [Double]()
                for k in 0..<state.count {
                    s.append(state[k] * scalingFactors![k])
                }
                output.append(s)
            }
            i += 1
            var j = 0
            var dt = 1.0
            for factors in coef {
                if j > 0 {
                    dt = dt0
                }
                newState[j] = state[j] + dt * factors.last!
                for i in 0..<factors.count-1 {
                    newState[j] += dt * factors[i] * state[i]
                }
                j += 1
            }
            state = newState
            
        }
    }
}
