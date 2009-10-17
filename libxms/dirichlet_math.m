/*
 *  dirichlet_math.c
 *  iMotifs
 *
 *  Created by Matias Piipari on 27/05/2009.
 *  Copyright 2009 Wellcome Trust Sanger Institute. All rights reserved.
 *
 */

#include <stdlib.h>
#import <math.h>
#import <Cocoa/Cocoa.h>
#include "dirichlet_math.h"


double drand() {
    return ((double)rand() / ((double)(RAND_MAX)+(double)(1)));
}

double drandMax(double maxVal) {
    return drand() * maxVal;
}

double sampleGamma(double k, double theta) {
    BOOL accept = NO;
    if (k < 1) {
        // Weibull algorithm
        double c = (1 / k);
        double d = ((1 - k) * pow(k, (k / (1 - k))));
        double u, v, z, e, x;
        do {
            u = drand();
            v = drand();
            z = -log(u);
            e = -log(v);
            x = pow(z, c);
            if ((z + e) >= (d + x)) {
                accept = YES;
            }
        } while (!accept);
        return (x * theta);
    } else {
        // Cheng's algorithm
        double b = (k - log(4));
        double c = (k + sqrt(2 * k - 1));
        double lam = sqrt(2 * k - 1);
        double cheng = (1 + log(4.5));
        double u, v, x, y, z, r;
        do {
            u = drand();
            v = drand();
            y = ((1 / lam) * log(v / (1 - v)));
            x = (k * exp(y));
            z = (u * v * v);
            r = (b + (c * y) - x);
            if ((r >= ((4.5 * z) - cheng)) ||
                (r >= log(z))) {
                accept = true;
            }
        } while (!accept);
        return (x * theta);
    }
}

double betaf(double alpha, double beta) {
    return tgamma(alpha) * tgamma(beta) / tgamma(alpha + beta);
}

double pbeta(double x, double alpha, double beta) {
    return 1.0 / betaf(alpha, beta) * pow(x,alpha - 1.0) * pow((1.0 - x), beta - 1.0);
}

double cbeta(double x, double alpha, double beta) {
    return betai(x, alpha, beta);
}

double betam(double alpha, double beta) {
    return alpha / (alpha + beta);
}

double betam2(double alpha, double beta) {
    return (alpha * (alpha + 1.0)) / ((alpha + beta) * (alpha + beta + 1.0));
}

double betav(double alpha, double beta) {
    return (alpha + beta) / pow((alpha + beta), 2.0) * (alpha + beta + 1.0);
}


/*********************************************************************
 Returns the incomplete beta function, I_x(a,b).
 I_x(a,b) = (int_0^x t^(a-1) * (1-t)^(b-1)  dt)/B(a,b),
 where B(a,b) is the betafunction
 B(a,b) = int_0^1 t^(a-1) * (1-t)^(b-1) dt
 = Gamma(a) * Gamma (b) / Gamma(a+b)	
 C.A. Bertulani        May/16/2000
 *********************************************************************/
double betai(double x, double alpha, double beta)
{
	double betacf(double x, double a, double b);
	double gamma_ln(double xx);
	double bt;
    
	if (x < 0.0 || x > 1.0) fprintf(stderr,"Bad x in routine betai");
	if (x == 0.0 || x == 1.0) bt=0.0;
	else		/* Factors in front of the continued fraction. */
		bt=exp(gamma_ln(alpha+beta)-gamma_ln(alpha)-gamma_ln(beta)+alpha*log(x)+beta*log(1.0-x));
	if (x < (alpha+1.0)/(alpha+beta+2.0))		/* Use continued fraction directly. */
		return bt*betacf(x,alpha,beta)/alpha;	
	else			/* Use continued faction after making */
		return 1.0-bt*betacf(1.0-x,beta,alpha)/beta;		/* the symmetry transformation. */
}

/*********************************************************************
 Continued fraction evaluation routine needed for the incomplete beta 
 function, I_x(a,b).	
 C.A. Bertulani        May/16/2000
 *********************************************************************/
#define MAXIT 100
#define EPS 3.0e-7
#define FPMIN 1.0e-30

double betacf(double x, double a, double b)
/* Used by betai: Evaluates continued fraction for incomplete beta function 
 by modified Lentz's method.   */
{
	void nrerror(char error_text[]);
	int m,m2;
	double aa,c,d,del,h,qab,qam,qap;
    
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
	if (m > MAXIT) {
        fprintf(stderr,"a or b too big, or MAXIT too small in betacf");
    }
	return h;
}
#undef MAXIT
#undef EPS
#undef FPMIN
/********************************************************************
 Returns the value of ln[Gamma(xx)] for xx > 0
 ********************************************************************/

double gamma_ln(double xx)
{
	double x,y,tmp,ser;
	static double cof[6]={
        76.18009172947146,-86.50532032941677,
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
