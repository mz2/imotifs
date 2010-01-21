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


