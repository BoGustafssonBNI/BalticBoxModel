//
//  Complex.swift
//  RootFinder
//
//  Created by Bo Gustafsson on 30/08/16.
//  Copyright © 2016 BNI. All rights reserved.
//

import Foundation

struct Complex {
    var real : Double
    var imaginary : Double
}

func == (lhs: Complex, rhs: Complex) -> Bool {
    return lhs.real == rhs.real && lhs.imaginary == rhs.imaginary
}

func + (lhs: Complex, rhs: Complex) -> Complex {
    return Complex(real: lhs.real + rhs.real, imaginary: lhs.imaginary + rhs.imaginary)
}
func + (lhs: Double, rhs: Complex) -> Complex {
    return Complex(real: lhs + rhs.real, imaginary: rhs.imaginary)
}
func + (lhs: Complex, rhs: Double) -> Complex {
    return Complex(real: lhs.real + rhs, imaginary: lhs.imaginary)
}


func - (lhs: Complex, rhs: Complex) -> Complex {
    return Complex(real: lhs.real - rhs.real, imaginary: lhs.imaginary - rhs.imaginary)
}

func - (lhs: Double, rhs: Complex) -> Complex {
    return Complex(real: lhs - rhs.real, imaginary: -rhs.imaginary)
}
func - (lhs: Complex, rhs: Double) -> Complex {
    return Complex(real: lhs.real - rhs, imaginary: lhs.imaginary)
}

prefix func - (cmplx: Complex) -> Complex {
    return Complex(real: -cmplx.real, imaginary: -cmplx.imaginary)
}


func * (lhs: Complex, rhs: Complex) -> Complex {
    return Complex(real: lhs.real * rhs.real - lhs.imaginary * rhs.imaginary, imaginary: lhs.real * rhs.imaginary + lhs.imaginary * rhs.real)
}

func * (lhs: Double, rhs: Complex) -> Complex {
    return Complex(real: lhs * rhs.real, imaginary: lhs * rhs.imaginary)
}

func * (lhs: Complex, rhs: Double) -> Complex {
    return rhs * lhs
}

func conj(_ cmplx: Complex) -> Complex {
    return Complex(real: cmplx.real, imaginary: -cmplx.imaginary)
}

func norm(_ cmplx: Complex) -> Double {
    return (cmplx * conj(cmplx)).real
}

func abs(_ cmplx: Complex) -> Double {
    return sqrt(norm(cmplx))
}
func arg(_ cmplx: Complex) -> Double {
    let x = cmplx.real
    let y = cmplx.imaginary
    var phi : Double
    if x > 0 {
        phi = atan(y/x)
    } else if x < 0 {
        if y >= 0 {
            phi = atan(y/x) + Double.pi
        } else {
            phi = atan(y/x) - Double.pi
        }
    } else {
        if y > 0 {
            phi = Double.pi/2.0
        } else {
            phi = -Double.pi/2.0
        }
    }
    return phi
}

func rectForm(_ r: Double, phi: Double) -> Complex {
    return Complex(real: r * cos(phi), imaginary: r * sin(phi))
}

func sqrt(_ cmplx: Complex) -> Complex {
    let r = sqrt(abs(cmplx))
    let phi = arg(cmplx)/2.0
    return rectForm(r, phi: phi)
}

func / (lhs: Complex, rhs: Double) -> Complex {
    return Complex(real: lhs.real/rhs, imaginary: lhs.imaginary/rhs)
}
func / (lhs: Complex, rhs: Complex) -> Complex {
    return lhs * conj(rhs) / norm(rhs)
}
func / (lhs: Double, rhs: Complex) -> Complex {
    return Complex(real:lhs, imaginary: 0.0)/rhs
}

func exp(_ cmplx: Complex) -> Complex {
    return Complex(real: exp(cmplx.real)*cos(cmplx.imaginary), imaginary: exp(cmplx.real)*sin(cmplx.imaginary))
}

func tanh(_ cmplx: Complex) -> Complex {
    return (exp(cmplx) - exp(-cmplx))/(exp(cmplx) + exp(-cmplx))
}

func niceString(_ cmplx: Complex) -> String {
    if cmplx.imaginary >= 0 {
        return String(cmplx.real) + "+ i" + String(cmplx.imaginary)
    } else {
        return String(cmplx.real) + "- i" + String(abs(cmplx.imaginary))
    }
    
}


