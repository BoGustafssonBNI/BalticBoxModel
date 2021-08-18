//
//  SedimentationBasedSigmoidG.swift
//  BalticBoxModel
//
//  Created by Bo Gustafsson on 2019-07-06.
//  Copyright © 2019 Bo Gustafsson. All rights reserved.
//

import Foundation

struct SedimentationBasedSigmoidG: GFunction {
    // MARK: - Functions for the FeP content
    func g(p: Double, x: Double, c: Double, kappa: Double, m: Double, alpha: Double, r: Double, layer: Int) -> Double {
        return max(0.5 * (tanh(m) + tanh(q(p: p, x: x, c: c, kappa: kappa, m: m, alpha: alpha, r: r, layer: layer))), 0.0)
    }
    
    private func q(p: Double, x: Double, c: Double, kappa: Double, m: Double, alpha: Double, r: Double, layer: Int) -> Double {
        return kappa * x / p - m
    }
    
    func dgdp(p: Double, x: Double,c: Double, kappa: Double, m: Double, alpha: Double, r: Double, layer: Int) -> Double {
        let tanhq = tanh(q(p: p, x: x, c: c, kappa: kappa, m: m, alpha: alpha, r: r, layer: layer))
        return 0.5 * (1.0 - tanhq * tanhq) * dqdp(p: p, x: x, c: c, kappa: kappa, m: m, alpha: alpha, r: r, layer: layer)
    }
    private func dqdp(p: Double, x: Double, c: Double, kappa: Double, m: Double, alpha: Double, r: Double, layer: Int) -> Double {
        return -kappa * x / p / p
    }
    func dgdx(p: Double, x: Double,c: Double, kappa: Double, m: Double, alpha: Double, dalphadx: Double, r: Double, layer: Int) -> Double {
        let tanhq = tanh(q(p: p, x: x, c: c, kappa: kappa, m: m, alpha: alpha, r: r, layer: layer))
        return 0.5 * (1.0 - tanhq * tanhq) * dqdx(p: p, x: x, c: c, kappa: kappa, m: m, alpha: alpha, dalphadx: dalphadx, r: r, layer: layer)
    }
    private func dqdx(p: Double, x: Double, c: Double, kappa: Double, m: Double, alpha: Double, dalphadx: Double, r: Double, layer: Int) -> Double {
        return kappa / p
    }
    func dgdc(p: Double, x: Double,c: Double, kappa: Double, m: Double, alpha: Double, r: Double, layer: Int) -> Double {
        let tanhq = tanh(q(p: p, x: x, c: c, kappa: kappa, m: m, alpha: alpha, r: r, layer: layer))
        return 0.5 * (1.0 - tanhq * tanhq) * dqdc(p: p, x: x, c: c, kappa: kappa, m: m, alpha: alpha, r: r, layer: layer)
    }
    private func dqdc(p: Double, x: Double, c: Double, kappa: Double, m: Double, alpha: Double, r: Double, layer: Int) -> Double {
        return 0.0
    }
    
    // MARK: - Functions for steady state calculations
    func g(x01: Double, x0: Double, kappa: Double, m: Double, chi: Double, rho: Double, theta: Double, d: Double, alpha: Double, r: Double, layer: Int) -> Double {
        guard x0 < chi else {
            return 1.0
        }
        return max(0.5 * (tanh(m) + tanh(q(x01: x01, x0: x0, kappa: kappa, chi: chi, rho: rho, theta: theta, d: d, m: m, alpha: alpha, r: r, layer: layer))), 0.0)
    }
    func g(x0: Double, kappa: Double, m: Double, chi: Double, rho: Double, theta: Double, d: Double, alpha: Double, r: Double, layer: Int) -> Double {
        return g(x01: x0, x0: x0, kappa: kappa, m: m, chi: chi, rho: rho, theta: theta, d: d, alpha: alpha, r: r, layer: layer)
    }
    
    private func q(x01: Double, x0: Double, kappa: Double, chi: Double, rho: Double, theta: Double, d: Double, m: Double, alpha: Double, r: Double, layer: Int) -> Double {
        return kappa * theta / d * x01 / (chi - x0) - m
    }
    

}
