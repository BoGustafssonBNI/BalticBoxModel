//
//  Combinations.swift
//  RootFinder
//
//  Created by Bo Gustafsson on 06/09/16.
//  Copyright © 2016 BNI. All rights reserved.
//


import Foundation


// Recursive func that returns a matrix of general type that includes all combinations of the elements in the source array given takenBy long "words"
func combinations<T>(_ source: [T], takenBy : Int) -> [[T]] {
    if(source.count == takenBy) {
        return [source]
    }
    
    if(source.isEmpty) {
        return []
    }
    
    if(takenBy == 0) {
        return []
    }
    
    if(takenBy == 1) {
        return source.map { [$0] }
    }
    
    var result : [[T]] = []
    
    let rest = Array(source.suffix(from: 1))
    let sub_combos = combinations(rest, takenBy: takenBy - 1)
    result += sub_combos.map { [source[0]] + $0 }
    
    result += combinations(rest, takenBy: takenBy)
    
    return result
}

// Takes constants c of the type (c_0 + sign*x)(c_1 + sign*x)... and returns the coefficients
// a such as a_n y^n + a_(n-1) y^(n-1)... a_1 y + a_0
func binominalType(_ c: [Double], sign: Int) -> [Double] {
    let degree = c.count
    var a = [Double]()
    for m in 0...degree-1 {
        let combs = combinations(c, takenBy: degree - m)
        var sum = 0.0
        for vector in combs {
            var prod = 1.0
            for element in vector {
                prod *= element
            }
            sum += prod
        }
        sum *= pow(Double(sign),Double(m))
        a.append(sum)
    }
    a.append(pow(-1.0,Double(degree)))
    
    return a
}

