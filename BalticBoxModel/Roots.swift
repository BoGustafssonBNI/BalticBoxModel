//
//  Roots.swift
//  RootFinder
//
//  Created by Bo Gustafsson on 31/08/16.
//  Copyright © 2016 BNI. All rights reserved.
//

// Naming convention 
// coefficient[j] x^(j) j = 0...m

import Foundation

class Roots
{
    var coefficients = [Complex]()
    var polish = true
//    var eps = 1.0e-6
    var eps = 1.0e-15
    
    
    func zroots() -> [Complex] {
        let zero = Complex(real: 0.0, imaginary: 0.0)
        var roots = [Complex]()
        var coeffCopy = coefficients
        let m = coefficients.count - 1
        var j = m - 1
        while j >= 0 {
            var x = zero
            x = laguer(coeffCopy, m: j + 1, xOld: x)
            if abs(x.imaginary) < 2.0 * eps * abs(x.real) { x = Complex(real: x.real, imaginary: 0.0)}
            roots.append(x)
            var b = coeffCopy[j + 1]
            var jj = j
            while jj >= 0 {
                let c = coeffCopy[jj]
                coeffCopy[jj] = b
                b = x * b + c
                jj -= 1
            }
            j -= 1
        }
        if polish {
            for j in 0...m-1 {
                roots[j] = laguer(coefficients, m: m, xOld: roots[j])
            }
        }
/*        for j in 1..<m {
            let x = roots[j]
            var k = j-1
            for i in j-1...0 {
                k = i
                if roots[i].real <= x.real {break}
                roots[i+1] = roots[i]
            }
            roots[k+1] = x
        } */
        
        return roots
        /*
         1       SUBROUTINE ZROOTS(A,M,ROOTS,POLISH)
         2       !Coefficients A so that A(m)x^(m-1), m=1..M+1
         3       PARAMETER (EPS=1.E-6,MAXM=101)
         4       COMPLEX A(*),ROOTS(M),AD(MAXM),X,B,C
         5       LOGICAL POLISH
         6       DO 11 J=1,M+1
         7         AD(J)=A(J)
         8 11    CONTINUE
         9       DO 13 J=M,1,-1
         10         X=CMPLX(0.,0.)
         11         CALL LAGUER(AD,J,X,EPS,.FALSE.)
         12         IF(ABS(AIMAG(X)).LE.2.*EPS**2*ABS(REAL(X))) X=CMPLX(REAL(X),0.)
         13         ROOTS(J)=X
         14         B=AD(J+1)
         15         DO 12 JJ=J,1,-1
         16           C=AD(JJ)
         17           AD(JJ)=B
         18           B=X*B+C
         19 12      CONTINUE
         20 13    CONTINUE
         21       IF (POLISH) THEN
         22         DO 14 J=1,M
         23           CALL LAGUER(A,M,ROOTS(J),EPS,.TRUE.)
         24 14      CONTINUE
         25       ENDIF
         26       DO 16 J=2,M
         27         X=ROOTS(J)
         28         DO 15 I=J-1,1,-1
         29           IF(REAL(ROOTS(I)).LE.REAL(X))GO TO 10
         30           ROOTS(I+1)=ROOTS(I)
         31 15      CONTINUE
         32         I=0 
         33 10      ROOTS(I+1)=X
         34 16    CONTINUE
         35       RETURN
         36       END

 */
    }
    
    fileprivate func laguer(_ a : [Complex], m : Int, xOld : Complex) -> Complex {
        let zero = Complex(real: 0.0, imaginary: 0.0)
//        let epss = 6.0e-8
        let epss = 6.0e-15
        let maxIter = 100
        var dx = zero
        var x = xOld
        var dxOld = abs(xOld)
        var iter = 0
        while iter < maxIter {
            var b = a[m]
            var err = abs(b)
            var d = zero
            var f = zero
            let abx = abs(x)
            var j = m - 1
            while j >= 0 {
                f = x * f + d
                d = x * d + b
                b = x * b + a[j]
                err = abs(b) + abx * err
                j -= 1
            }
            err = epss * err
            if abs(b) < err {
                return x
            } else {
                 let g = d/b
                let g2 = g * g
                let h = g2 - 2.0 * f/b
                let sq = sqrt(Double(m - 1)*(Double(m) * h - g2))
                var gp = g + sq
                let gm = g - sq
                if abs(gp) < abs(gm) {gp = gm}
                dx = Double(m)/gp
            }
            let x1 = x - dx
            if x == x1 {return x}
            x = x1
            let cdx = abs(dx)
            if iter > 6 && cdx > dxOld {return x}
            dxOld = cdx
            if !polish { if abs(dx) <= eps * abs(x) { return x}}
            iter += 1
        }
/*
         1       SUBROUTINE LAGUER(A,M,X,EPS,POLISH)
         2       COMPLEX A(*),X,DX,X1,B,D,F,G,H,SQ,GP,GM,G2,ZERO
         3       LOGICAL POLISH
         4       PARAMETER (ZERO=(0.,0.),EPSS=6.E-8,MAXIT=100)
         5       DXOLD=CABS(X)
         6       DO 12 ITER=1,MAXIT
         7         B=A(M+1)
         8         ERR=CABS(B)
         9         D=ZERO
         10         F=ZERO
         11         ABX=CABS(X)
         12         DO 11 J=M,1,-1
         13           F=X*F+D
         14           D=X*D+B
         15           B=X*B+A(J)
         16           ERR=CABS(B)+ABX*ERR
         17 11      CONTINUE
         18         ERR=EPSS*ERR
         19         IF(CABS(B).LE.ERR) THEN
         20           DX=ZERO
         21           RETURN
         22         ELSE
         23           G=D/B
         24           G2=G*G
         25           H=G2-2.*F/B
         26           SQ=CSQRT((M-1)*(M*H-G2))
         27           GP=G+SQ
         28           GM=G-SQ
         29           IF(CABS(GP).LT.CABS(GM)) GP=GM
         30           DX=M/GP
         31         ENDIF
         32         X1=X-DX
         33         IF(X.EQ.X1)RETURN
         34         X=X1
         35         CDX=CABS(DX)
         36         IF(ITER.GT.6.AND.CDX.GE.DXOLD)RETURN
         37         DXOLD=CDX
         38         IF(.NOT.POLISH)THEN
         39           IF(CABS(DX).LE.EPS*CABS(X))RETURN
         40         ENDIF
         41 12    CONTINUE
         42       PAUSE 'too many iterations'
         43       RETURN
         44       END 
         
 */
        return x
    }
}
