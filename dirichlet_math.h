/*
 *  dirichlet_math.h
 *  iMotifs
 *
 *  Created by Matias Piipari on 27/05/2009.
 *  Copyright 2009 Wellcome Trust Sanger Institute. All rights reserved.
 *
 */


double drand();
double drandMax(double maxVal);
double sampleGamma(double k, double theta);

double betaf(double alpha, double beta); // beta function
double betai(double x, double alpha, double beta); //incomplete Beta function
//double gamma(double x);

//double pgamma(double x, double alpha, double beta);
double pbeta(double x, double alpha, double beta); //prob density for Beta distribution
double cbeta(double x, double alpha, double beta); //cumulative distribution

//moments
double betam(double alpha, double beta); //expected value for Beta distribution
double betam2(double alpha, double beta); // second moment
double betav(double alpha, double beta); //variance for Beta distribution


