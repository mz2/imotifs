#include <math.h>
#include <assert.h>
#include "gen_norm.h"

/*
 *  gen_norm.c	generating random numbers from a standard normal distribution
 *  Copyright (C) 2000	Kevin Karplus
 *
 *  This library is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU Lesser General Public
 *  License as published by the Free Software Foundation; 
 *  version 2.1 of the License.
 *
 *  This library is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *  Lesser General Public License for more details.
 *
 *  See http://www.gnu.org/copyleft/lesser.html for the license details,
 *  or write to the Free Software Foundation, Inc., 59 Temple Place, Suite
 *  330, Boston, MA 02111-1307 USA
 */

/* This code was written by Kevin Karplus  7 Nov 2000
 */


/* pick which underlying uniform random number generator to use. */
#define DRAND() ((random()+0.5)/ 2147483648.0)



/*   Generate one number from the standard normal distribution.
 
 Method: Ratio of uniforms, as improved by Knuth.  The ratio of
 uniforms was chosen because of the simplicity of the method.  The
 popular "polar Box-Mueller" method may make fewer than half as
 many calls to DRAND, but to do so it requires almost twice ans
 many calls to log() and requires saving state between calls to
 the method.  I prefer the stateless ratio-of-uniforms method.
 
 Method taken from on pages 99-101 in 
 Dagpunar, John.
 Principles of Random Variate Generation.
 Oxford University Press, 1988.
 */

#define SQRT_2_OVER_E	0.857763884961	/* sqrt(2/e) */
#define EXP_135	0.259240260646		/* exp(-1.35) */

double gen_norm(void)
{
    double r1, r2, x, w;
    
    do
    {	r1=DRAND();
    	r2=DRAND();
        x = SQRT_2_OVER_E * (r2+r2-1)/ r1;
        w = 0.25 * x * x;
        if (1-r1 >= w) return x;
    } while ( EXP_135 < (w-0.35)*r1
             || log(r1) > -w);
    return x;
}
