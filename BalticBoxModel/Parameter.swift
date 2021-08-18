//
//  Parameters.swift
//  parameterTest
//
//  Created by Bo Gustafsson on 03/05/16.
//  Copyright © 2016 Bo Gustafsson. All rights reserved.
//

import Foundation

struct Parameter {
    var key : String
    var name : String
    var value : Double
    var minValue : Double?
    var maxValue : Double?
    var explanation : String?
    var sensitivityCalculation : Bool
}

struct ParameterValues {
    var value = 0.0
    var minValue : Double? = nil
    var maxValue : Double? = nil
}

extension Parameter {
    func toCSVLine() -> String {
        var out = key + "," + name + "," + String(value) + ","
        if let x = minValue {
            out += String(x) + ","
        } else {
            out += "nil,"
        }
        if let x = maxValue {
            out += String(x) + ","
        } else {
            out += "nil,"
        }
        out += sensitivityCalculation.description + ","
        if let x = explanation {
            out += x + "\n"
        } else {
            out += "\n"
        }
        return out
    }
    mutating func parseCSVLine(_ line: String)  {
        let components = line.components(separatedBy: ",")
        if components.count != 6 {
            print("error reading")
        }
        key = components[0]
        name = components[1]
        value = Double(components[2])!
        minValue = Double(components[3])
        maxValue = Double(components[4])
        sensitivityCalculation = components[5] == true.description
        explanation = components[6]
    }
    mutating func addParameterValues(values: ParameterValues) {
        value = values.value
        minValue = values.minValue
        maxValue = values.maxValue
    }
    mutating func addParameterValues(param: Parameter) {
        value = param.value
        minValue = param.minValue
        maxValue = param.maxValue
    }
    func getValues() -> ParameterValues {
        var out = ParameterValues()
        out.value = value
        out.minValue = minValue
        out.maxValue = maxValue
        return out
    }

}

extension ParameterValues {
    func checkMinMax() -> ParameterValues {
        var out = self
        if minValue != nil && maxValue != nil {
            if minValue! > maxValue! {
                out.maxValue = minValue
                out.minValue = maxValue
            }
        }
        return out
    }
}

func += (left: inout Parameter, right: Parameter) {
    var outValues = ParameterValues()
    outValues.value = left.value + right.value
    if left.minValue != nil && right.minValue != nil {
        outValues.minValue = left.minValue! + right.minValue!
    }
    if left.maxValue != nil && right.maxValue != nil {
        outValues.maxValue = left.maxValue! + right.maxValue!
    }
    left.value = outValues.value
    left.minValue = outValues.minValue
    left.maxValue = outValues.maxValue
}


func + (left: Parameter, right: Parameter) -> ParameterValues {
    var outValues = ParameterValues()
    outValues.value = left.value + right.value
    if left.minValue != nil && right.minValue != nil {
        outValues.minValue = left.minValue! + right.minValue!
    }
    if left.maxValue != nil && right.maxValue != nil {
        outValues.maxValue = left.maxValue! + right.maxValue!
    }
    return outValues
}
func - (left: Parameter, right: Parameter) -> ParameterValues {
    var outValues = ParameterValues()
    outValues.value = left.value - right.value
    if left.minValue != nil && right.minValue != nil {
        outValues.minValue = left.minValue! - right.minValue!
    }
    if left.maxValue != nil && right.maxValue != nil {
        outValues.maxValue = left.maxValue! - right.maxValue!
    }
    return outValues
}
func * (left: Parameter, right: Parameter) -> ParameterValues {
    var outValues = ParameterValues()
    outValues.value = left.value * right.value
    if left.minValue != nil && right.minValue != nil {
        outValues.minValue = left.minValue! * right.minValue!
    }
    if left.maxValue != nil && right.maxValue != nil {
        outValues.maxValue = left.maxValue! * right.maxValue!
    }
    return outValues
}
func / (left: Parameter, right: Parameter) -> ParameterValues {
    var outValues = ParameterValues()
    outValues.value = left.value / right.value
    if left.minValue != nil && right.maxValue != nil {
        outValues.minValue = left.minValue! / right.maxValue!
    }
    if left.maxValue != nil && right.minValue != nil {
        outValues.maxValue = left.maxValue! / right.minValue!
    }
    return outValues
}
func * (left: Double, right: Parameter) -> ParameterValues {
    var outValues = ParameterValues()
    outValues.value = left * right.value
    if right.minValue != nil {
        outValues.minValue = left * right.minValue!
    }
    if right.maxValue != nil {
        outValues.maxValue = left * right.maxValue!
    }
    return outValues
}
func / (left: Double, right: Parameter) -> ParameterValues {
    var outValues = ParameterValues()
    outValues.value = left / right.value
    if right.maxValue != nil {
        outValues.minValue = left / right.maxValue!
    }
    if right.minValue != nil {
        outValues.maxValue = left / right.minValue!
    }
    return outValues
}
func * (left: Parameter, right: Double) -> ParameterValues {
    var outValues = ParameterValues()
    outValues.value = left.value * right
    if left.minValue != nil {
        outValues.minValue = left.minValue! * right
    }
    if left.maxValue != nil {
        outValues.maxValue = left.maxValue! * right
    }
    return outValues
}
func / (left: Parameter, right: Double) -> ParameterValues {
    var outValues = ParameterValues()
    outValues.value = left.value / right
    if left.minValue != nil {
        outValues.minValue = left.minValue! / right
    }
    if left.maxValue != nil {
        outValues.maxValue = left.maxValue! / right
    }
    return outValues
}

func + (left: Parameter, right: ParameterValues) -> ParameterValues {
    var outValues = ParameterValues()
    outValues.value = left.value + right.value
    if left.minValue != nil && right.minValue != nil {
        outValues.minValue = left.minValue! + right.minValue!
    }
    if left.maxValue != nil && right.maxValue != nil {
        outValues.maxValue = left.maxValue! + right.maxValue!
    }
    return outValues
}
func - (left: Parameter, right: ParameterValues) -> ParameterValues {
    var outValues = ParameterValues()
    outValues.value = left.value - right.value
    if left.minValue != nil && right.minValue != nil {
        outValues.minValue = left.minValue! - right.minValue!
    }
    if left.maxValue != nil && right.maxValue != nil {
        outValues.maxValue = left.maxValue! - right.maxValue!
    }
    return outValues
}
func * (left: Parameter, right: ParameterValues) -> ParameterValues {
    var outValues = ParameterValues()
    outValues.value = left.value * right.value
    if left.minValue != nil && right.minValue != nil {
        outValues.minValue = left.minValue! * right.minValue!
    }
    if left.maxValue != nil && right.maxValue != nil {
        outValues.maxValue = left.maxValue! * right.maxValue!
    }
    return outValues
}
func / (left: Parameter, right: ParameterValues) -> ParameterValues {
    var outValues = ParameterValues()
    outValues.value = left.value / right.value
    if left.minValue != nil && right.maxValue != nil {
        outValues.minValue = left.minValue! / right.maxValue!
    }
    if left.maxValue != nil && right.minValue != nil {
        outValues.maxValue = left.maxValue! / right.minValue!
    }
    return outValues
}
func + (left: ParameterValues, right: Parameter) -> ParameterValues {
    var outValues = ParameterValues()
    outValues.value = left.value + right.value
    if left.minValue != nil && right.minValue != nil {
        outValues.minValue = left.minValue! + right.minValue!
    }
    if left.maxValue != nil && right.maxValue != nil {
        outValues.maxValue = left.maxValue! + right.maxValue!
    }
    return outValues
}
func - (left: ParameterValues, right: Parameter) -> ParameterValues {
    var outValues = ParameterValues()
    outValues.value = left.value - right.value
    if left.minValue != nil && right.minValue != nil {
        outValues.minValue = left.minValue! - right.minValue!
    }
    if left.maxValue != nil && right.maxValue != nil {
        outValues.maxValue = left.maxValue! - right.maxValue!
    }
    return outValues
}
func * (left: ParameterValues, right: Parameter) -> ParameterValues {
    var outValues = ParameterValues()
    outValues.value = left.value * right.value
    if left.minValue != nil && right.minValue != nil {
        outValues.minValue = left.minValue! * right.minValue!
    }
    if left.maxValue != nil && right.maxValue != nil {
        outValues.maxValue = left.maxValue! * right.maxValue!
    }
    return outValues
}
func / (left: ParameterValues, right: Parameter) -> ParameterValues {
    var outValues = ParameterValues()
    outValues.value = left.value / right.value
    if left.minValue != nil && right.maxValue != nil {
        outValues.minValue = left.minValue! / right.maxValue!
    }
    if left.maxValue != nil && right.minValue != nil {
        outValues.maxValue = left.maxValue! / right.minValue!
    }
    return outValues
}



func += (left: inout ParameterValues, right: ParameterValues) {
    var outValues = ParameterValues()
    outValues.value = left.value + right.value
    if left.minValue != nil && right.minValue != nil {
        outValues.minValue = left.minValue! + right.minValue!
    }
    if left.maxValue != nil && right.maxValue != nil {
        outValues.maxValue = left.maxValue! + right.maxValue!
    }
    left.value = outValues.value
    left.minValue = outValues.minValue
    left.maxValue = outValues.maxValue
}


func + (left: ParameterValues, right: ParameterValues) -> ParameterValues {
    var outValues = ParameterValues()
    outValues.value = left.value + right.value
    if left.minValue != nil && right.minValue != nil {
        outValues.minValue = left.minValue! + right.minValue!
    }
    if left.maxValue != nil && right.maxValue != nil {
        outValues.maxValue = left.maxValue! + right.maxValue!
    }
    return outValues
}

func - (left: ParameterValues, right: ParameterValues) -> ParameterValues {
    var outValues = ParameterValues()
    outValues.value = left.value - right.value
    if left.minValue != nil && right.minValue != nil {
        outValues.minValue = left.minValue! - right.minValue!
    }
    if left.maxValue != nil && right.maxValue != nil {
        outValues.maxValue = left.maxValue! - right.maxValue!
    }
    return outValues
}
func * (left: ParameterValues, right: ParameterValues) -> ParameterValues {
    var outValues = ParameterValues()
    outValues.value = left.value * right.value
    if left.minValue != nil && right.minValue != nil {
        outValues.minValue = left.minValue! * right.minValue!
    }
    if left.maxValue != nil && right.maxValue != nil {
        outValues.maxValue = left.maxValue! * right.maxValue!
    }
    return outValues
}
func / (left: ParameterValues, right: ParameterValues) -> ParameterValues {
    var outValues = ParameterValues()
    outValues.value = left.value / right.value
    if left.minValue != nil && right.maxValue != nil {
        outValues.minValue = left.minValue! / right.maxValue!
    }
    if left.maxValue != nil && right.minValue != nil {
        outValues.maxValue = left.maxValue! / right.minValue!
    }
    return outValues
}
func * (left: Double, right: ParameterValues) -> ParameterValues {
    var outValues = ParameterValues()
    outValues.value = left * right.value
    if right.minValue != nil {
        outValues.minValue = left * right.minValue!
    }
    if right.maxValue != nil {
        outValues.maxValue = left * right.maxValue!
    }
    return outValues
}
func / (left: Double, right: ParameterValues) -> ParameterValues {
    var outValues = ParameterValues()
    outValues.value = left / right.value
    if right.maxValue != nil {
        outValues.minValue = left / right.maxValue!
    }
    if right.minValue != nil {
        outValues.maxValue = left / right.minValue!
    }
    return outValues
}
func * (left: ParameterValues, right: Double) -> ParameterValues {
    var outValues = ParameterValues()
    outValues.value = left.value * right
    if left.minValue != nil {
        outValues.minValue = left.minValue! * right
    }
    if left.maxValue != nil {
        outValues.maxValue = left.maxValue! * right
    }
    return outValues
}
func / (left: ParameterValues, right: Double) -> ParameterValues {
    var outValues = ParameterValues()
    outValues.value = left.value / right
    if left.minValue != nil {
        outValues.minValue = left.minValue! / right
    }
    if left.maxValue != nil {
        outValues.maxValue = left.maxValue! / right
    }
    return outValues
}

func exp (values: ParameterValues) -> ParameterValues {
    var outValues = ParameterValues()
    outValues.value = exp(values.value)
    if values.minValue != nil {
        outValues.minValue = exp(values.minValue!)
    }
    if values.maxValue != nil {
        outValues.maxValue = exp(values.maxValue!)
    }
    return outValues
}
func log (values: ParameterValues) -> ParameterValues {
    var outValues = ParameterValues()
    outValues.value = log(values.value)
    if values.minValue != nil {
        outValues.minValue = log(values.minValue!)
    }
    if values.maxValue != nil {
        outValues.maxValue = log(values.maxValue!)
    }
    return outValues
}
