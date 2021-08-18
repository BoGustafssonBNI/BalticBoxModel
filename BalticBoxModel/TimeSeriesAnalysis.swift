//
//  TimeSeriesAnalysis.swift
//  BalticBoxModel
//
//  Created by Bo Gustafsson on 2017-01-16.
//  Copyright © 2017 Bo Gustafsson. All rights reserved.
//

import Foundation


class TimeSeriesAnalysis {
    var numberOfLags = 512
    
    func variance(forSingleTimeSeries timeSeries: [Double]) -> [Double] {
        let numberOfData = timeSeries.count
        numberOfLags = min(Int(pow(2.0,Double(Int(log(Double(numberOfData))/log(2)) - 2))), numberOfLags)
        var variance = [Double]()
        for i in 0...numberOfLags {
            var vsum = 0.0
            for n in 0..<numberOfData - i {
                vsum += timeSeries[n] * timeSeries[n+i]
            }
            variance.append(vsum/Double(numberOfData - i))
        }
        return variance
    }
    // Provides spectral density Amplitude^2/dt -> integral = amplitude^2
    func spectra(singleVariance variance: [Double], timeStep: Double) -> (period: [Double], power: [Double]) {
        let pi = Double.pi
        let omega = pi/Double(numberOfLags)
        var cost = [Double]()
        var sint = [Double]()
        var power = [Double]()
        var period = [Double]()
        for i in 0...2 * numberOfLags - 1 {
            cost.append(cos(omega * Double(i)))
            sint.append(sin(omega * Double(i)))
        }
        var i = numberOfLags
        repeat {
            var ch = variance[0]
            for k in 1...numberOfLags {
                let window = 0.5 * (1.0 + cost[k])
                ch += window * 2.0 * variance[k] * cost[i * k % (2 * numberOfLags)]
            }
            power.append(sqrt(ch * ch) * 2.0 / pi / (Double(numberOfLags) * timeStep))
            print("numberOfLags \(numberOfLags), timestep=\(timeStep)")
            period.append(2.0 * Double(numberOfLags)/Double(i > 1 ? i : 1) * timeStep)
            i -= 1
        } while i > 1
        return (period, power)
    }

    
/*
    536       SUBROUTINE SPECTRA(C,LD,NV,R,FI)
    537       INTEGER LD,I,K,NV,MMAX,N,J
    538       PARAMETER (MMAX=60000)
    539       REAL*8 C(NV,NV,-LD:LD),R(NV,NV,0:LD),FI(NV,NV,0:LD),PI
    540       REAL*8 OMEGA,CH,QH,LK,COST(0:2*MMAX),SINT(0:2*MMAX)
    541
    542       PI=4.0D0*DATAN(1.D0)
    543
    544       OMEGA=PI/DBLE(LD)
    545       DO I=0,2*LD-1
    546          COST(I)=DCOS(OMEGA*DBLE(I))
    547          SINT(I)=DSIN(OMEGA*DBLE(I))
    548       END DO
    549
    550       DO N=1,NV
    551          DO J=1,NV
    552             write(*,99) 'Spectrum of ',j,' and ',N
    553 99          format('+',a12,i1,a5,i1)
    554             DO I=0,LD
    555                QH=0.0D0
    556                CH=C(N,J,0)
    557                DO K=1,LD
    558                   LK=0.5D0*(1.0D0+COST(K))
    559                   CH=CH+LK*(C(N,J,K)+C(N,J,-K))*COST(MOD(I*K,2*LD))
    560                   QH=QH+LK*(C(N,J,K)-C(N,J,-K))*SINT(MOD(I*K,2*LD))
    561                END DO
    562                CH=CH/PI
    563                QH=QH/PI
    564                R(N,J,I)=DSQRT(CH*CH+QH*QH)
    565                IF (CH.NE.0.0D0) THEN
    566                   FI(N,J,I)=DATAN2(-QH,CH)
    567                END IF
    568             END DO
    569          END DO
    570       END DO
   */
 
 
}
