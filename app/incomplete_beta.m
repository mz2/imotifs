/*
 *  incomplete_beta.cpp
 *  iMotifs
 *
 *  Created by Matias Piipari on 12/05/2009.
 *  Copyright 2009 Wellcome Trust Sanger Institute. All rights reserved.
 *
 */

#include "incomplete_beta.h"

/*
 int main(){
 Number betai(Number, Number, Number);
 Number x, a, b;
 int j;
 j=1;
 cout << "If an event occurs with probability p, the probability P of its\n";
 cout << "occurring k, or more, times in n trials is\n";
 cout << "P = Sum_(j=k)^n  (n   j) * p^j * (1-p)^(n-j) = I(k,n-k+1)\n";
 cout << "To ease input we use p = x, k = a, and n = b";
 cout << "\n\n Enter x, a, and b.\n";
 cout << "\nWanna check? Note that I_0(a,b) = 0, and I_1(a,b) = 1, \n";
 cout << "Check the symmetry relation: I_x(a,b) = 1 - I_(1-x) (b,a)\n\n";
 cin >>  x >> a >> b;
 for(;;){
 if(j>10){ cout << "\n My patience is over. Stop, please!\n";
 break;
 }
 if(j!=1){
 cout << "\n\n Enter x, a, and b.\n";
 cin >>  x >> a >> b;
 }
 cout << "\n I_x(a,b): " << betai(a,b,x);
 cout << "\n P: " << betai(a,b-a+1,x);
 j=j+1;
 }
 return 0;
 }
 */
/*********************************************************************
 Returns the incomplete beta function, I_x(a,b).
 I_x(a,b) = (int_0^x t^(a-1) * (1-t)^(b-1)  dt)/B(a,b),
 where B(a,b) is the betafunction
 B(a,b) = int_0^1 t^(a-1) * (1-t)^(b-1) dt
 = Gamma(a) * Gamma (b) / Gamma(a+b)	
 C.A. Bertulani        May/16/2000
 *********************************************************************/
Number ibetai(Number a, Number b, Number x)
{
	Number ibetacf(Number a, Number b, Number x);
	Number igamma_ln(Number xx);
	Number bt;
    
	if (x < 0.0 || x > 1.0) fprintf(stderr,"Bad x in routine betai\n");
	if (x == 0.0 || x == 1.0) bt=0.0;
	else		/* Factors in front of the continued fraction. */
		bt=exp(igamma_ln(a+b)-igamma_ln(a)-igamma_ln(b)+a*log(x)+b*log(1.0-x));
	if (x < (a+1.0)/(a+b+2.0))		/* Use continued fraction directly. */
		return bt*ibetacf(a,b,x)/a;	
	else			/* Use continued faction after making */
		return 1.0-bt*ibetacf(b,a,1.0-x)/b;		/* the symmetry transformation. */
}
/*********************************************************************
 Continued fraction evaluation routine needed for the incomplete beta 
 function, I_x(a,b).	
 C.A. Bertulani        May/16/2000
 *********************************************************************/
#define MAXIT 100
#define EPS 3.0e-7
#define FPMIN 1.0e-30

Number ibetacf(Number a, Number b, Number x)
/* Used by betai: Evaluates continued fraction for incomplete beta function 
 by modified Lentz's method.   */
{
	void nrerror(char error_text[]);
	int m,m2;
	Number aa,c,d,del,h,qab,qam,qap;
    
	qab=a+b;
	qap=a+1.0;	
	qam=a-1.0;	
	c=1.0;		/* First step of Lentz's method.  */
	d=1.0-qab*x/qap;
	if (fabs(d) < FPMIN) d=FPMIN;
	d=1.0/d;
	h=d;
	for (m=1;m<=MAXIT;m++) {
		m2=2*m;
		aa=m*(b-m)*x/((qam+m2)*(a+m2));
		d=1.0+aa*d;		/* One step (the even one) of the recurrence. */
		if (fabs(d) < FPMIN) d=FPMIN;
		c=1.0+aa/c;
		if (fabs(c) < FPMIN) c=FPMIN;
		d=1.0/d;
		h *= d*c;
		aa = -(a+m)*(qab+m)*x/((a+m2)*(qap+m2));
		d=1.0+aa*d;		/* Next step of the recurence the odd one) */
		if (fabs(d) < FPMIN) d=FPMIN;
		c=1.0+aa/c;
		if (fabs(c) < FPMIN) c=FPMIN;
		d=1.0/d;
		del=d*c;
		h *= del;
		if (fabs(del-1.0) < EPS) break;   /* Are we done? */
	}
	if (m > MAXIT) fprintf(stderr,"a or b too big, or MAXIT too small in betacf");
	return h;
}
#undef MAXIT
#undef EPS
#undef FPMIN
/********************************************************************
 Returns the value of ln[Gamma(xx)] for xx > 0
 ********************************************************************/

Number igamma_ln(Number xx)
{
	Number x,y,tmp,ser;
	static Number cof[6]={76.18009172947146,-86.50532032941677,
		24.01409824083091,-1.231739572450155,
    0.1208650973866179e-2,-0.5395239384953e-5};
	int j;
    
	y=x=xx;
	tmp=x+5.5;
	tmp -= (x+0.5)*log(tmp);
	ser=1.000000000190015;
	for (j=0;j<=5;j++) ser += cof[j]/++y;
	return -tmp+log(2.5066282746310005*ser/x);
}
/********************************************************************/
