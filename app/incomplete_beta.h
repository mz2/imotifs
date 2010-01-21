/*
This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Library General Public
License as published by the Free Software Foundation; either
version 2 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Library General Public License for more details.

You should have received a copy of the GNU Library General Public
License along with this library; if not, write to the
Free Software Foundation, Inc., 51 Franklin St, Fifth Floor,
Boston, MA  02110-1301, USA.
*/
/*********************************************************************
 Returns the incomplete beta function, I_x(a,b), and the binomial 
 probability distribution P.
 I_x(a,b) = (int_0^x t^(a-1) * (1-t)^(b-1)  dt)/B(a,b),
 where B(a,b) is the betafunction
 B(a,b) = int_0^1 t^(a-1) * (1-t)^(b-1) dt
 = Gamma(a) * Gamma (b) / Gamma(a+b)	
 The Probability distribution function is given by
 P = Sum_(j=k)^n  (n   j) p^j (1-p)^(n-j) = I(k,n-k+1)
 C.A. Bertulani        May/16/2000
 *********************************************************************/

typedef double Number;

#include <math.h>
//#include <iostream.h>

#define MAXIT 100
#define EPS 3.0e-7
#define FPMIN 1.0e-30

Number ibetai(Number a, Number b, Number x);
Number ibetacf(Number a, Number b, Number x);
Number igamma_ln(Number xx);