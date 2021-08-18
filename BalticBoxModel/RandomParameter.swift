//
//  RandomParameter.swift
//  boxModel
//
//  Created by Bo Gustafsson on 25/05/16.
//  Copyright © 2016 BNI. All rights reserved.
//

import Foundation

class RandomParameter {
    
    var parameterForNoise : Parameter?
    var noiseValue : Double?
    var returnPeriod = 10.0
    
    

    func addNoise(_ pvalues: [String: Double]) -> (newPvalues: [String: Double], newNoiseValue: Double?) {
        if let param = parameterForNoise {
            if let minValue = param.minValue {
                let new = updateValue()
                if new || noiseValue == nil {
                    let deviation = (param.value - minValue)/2.0
                    let mu = log(param.value/sqrt(1.0 + pow(deviation/param.value,2.0)))
                    let sigma = sqrt(log(1.0+pow(deviation/param.value,2.0)))
                    let random = Double(arc4random())/Double(RAND_MAX)
                    let number = norm_rand(random, mu: mu, sigma: sigma)
                    noiseValue = exp(number)
                }
                var pv = pvalues
                pv[param.key] = noiseValue!
                return (newPvalues: pv, newNoiseValue: noiseValue)
            }
            return (newPvalues: pvalues, newNoiseValue: noiseValue)
        }
        noiseValue = nil
        return (newPvalues: pvalues, newNoiseValue: noiseValue)
    }
    
    fileprivate func updateValue() -> Bool {
        let random = Double(arc4random())/Double(RAND_MAX)
        if random < 1.0 / returnPeriod {
            return true
        }
        return false
    }
// Routine to create normally distributed random numbers
// returns a normally distributed random number with given average (mu) and
// standard deviation (sigma) for a uniform random number x
    
    fileprivate func norm_rand(_ x: Double, mu: Double, sigma: Double) -> Double {
        let prec = 1.0e-10
        var y = [Double]()
        var phi = [Double]()
        var i0 = 0
        var i1 = 1
        
        
        //      gauss=1.0d0/sqrt(2.0d0*pi)/sigma*dexp(-(z-mu)**2/2.0d0/sigma**2)
        y.append(-1.0)
        y.append(1.0)
        phi.append(x - 0.5 * (1.0 + erf(y[i0] / sqrt(2.0))))
        phi.append(x - 0.5 * (1.0 + erf(y[i1] / sqrt(2.0))))
        
        while abs(phi[i0]) > prec {
            y[i1] = y[i0] - phi[i0] * (y[i0] - y[i1]) / (phi[i0] - phi[i1])
            phi[i1] = x - 0.5 * (1.0 + erf(y[i1]/sqrt(2.0)))
            let iSwap = i0
            i0 = i1
            i1 = iSwap
        }
        return y[i0] * sigma + mu
    }
    
}
