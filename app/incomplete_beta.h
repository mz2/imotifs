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