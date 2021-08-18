//
//  StepFunction.swift
//  BalticBoxModel
//
//  Created by Bo Gustafsson on 2016-12-06.
//  Copyright © 2016 Bo Gustafsson. All rights reserved.
//

import Foundation

func hstep(_ x : Double) -> Double {
    let k = 50.0
    return 0.5 * (1.0 + tanh(k * x))
}

func dirac(_ x : Double) -> Double {
    let k = 50.0
    return k * 0.5 * (1.0 - tanh(k * x) * tanh(k * x))
//    return 0.0
}
