//
//  LinearG.swift
//  BalticBoxModel
//
//  Created by Bo Gustafsson on 2019-07-08.
//  Copyright © 2019 Bo Gustafsson. All rights reserved.
//

import Foundation

struct LinearG: GFunction {
    // MARK: - Functions for the FeP content
    func g(p: Double, x: Double, c: Double, kappa: Double, m: Double, alpha: Double, r: Double, layer: Int) -> Double {
        if layer == 1 {
            return max(q(x: x, c: c, kappa: kappa, m: m, alpha: 1.0, r: r), 0.0)
        }
        return max(q(x: x, c: c, kappa: kappa, m: m, alpha: alpha, r: r), 0.0)
    }
    func dgdp(p: Double, x: Double,c: Double, kappa: Double, m: Double, alpha: Double, r: Double, layer: Int) -> Double {
        return 0.0
    }
    func dgdx(p: Double, x: Double,c: Double, kappa: Double, m: Double, alpha: Double, dalphadx: Double, r: Double, layer: Int) -> Double {
        guard layer == 2 else {
            return 0.0
        }
        return dqdx(x: x, c: c, kappa: kappa, alpha: alpha, dalphadx: dalphadx, r: r)
    }
    func dgdc(p: Double, x: Double,c: Double, kappa: Double, m: Double, alpha: Double, r: Double, layer: Int) -> Double {
        if layer == 1 {
            return dqdc(x: x, c: c, kappa: kappa, alpha: 1.0, r: r)
        }
        return dqdc(x: x, c: c, kappa: kappa, alpha: alpha, r: r)
    }
    
    private func q(x: Double, c: Double, kappa: Double, m: Double, alpha: Double, r: Double) -> Double {
        return kappa * x / (alpha * r * c)
    }
    //    private func dqdp(p: Double, x: Double, c: Double, kappa: Double, alpha: Double, r: Double) -> Double {
    //        return 0.0
    //    }
    
    private func dqdx(x: Double, c: Double, kappa: Double, alpha: Double, dalphadx: Double, r: Double) -> Double {
        return kappa / (alpha * r * c) - kappa * x / (alpha * alpha * r * c) * dalphadx
    }
    private func dqdc(x: Double, c: Double, kappa: Double, alpha: Double, r: Double) -> Double {
        return -kappa * x / (alpha * r * c * c)
    }
    
    // MARK: - Functions for steady state calculations
    func g(x01: Double, x0: Double, kappa: Double, m: Double, chi: Double, rho: Double, theta: Double, d: Double, alpha: Double, r: Double, layer: Int) -> Double {
        guard x0 < chi else {
            return 1.0
        }
        return q(x01: x01, x0: x0, kappa: kappa, chi: chi, rho: rho, theta: theta, d: d, m: m, layer: layer)
    }
    func g(x0: Double, kappa: Double, m: Double, chi: Double, rho: Double, theta: Double, d: Double, alpha: Double, r: Double, layer: Int) -> Double {
        return g(x01: x0, x0: x0, kappa: kappa, m: m, chi: chi, rho: rho, theta: theta, d: d, alpha: alpha, r: r, layer: layer)
    }
    
    private func q(x01: Double, x0: Double, kappa: Double, chi: Double, rho: Double, theta: Double, d: Double, m: Double, layer: Int) -> Double {
        if layer == 1 {
            return kappa * theta / rho / d * x01 / (chi - x0)
        }
        return kappa / d * x0 / (chi - x0)
    }
    
    
}
