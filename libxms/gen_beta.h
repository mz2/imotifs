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
 *  gen_beta.h	generating beta-distributed random numbers
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
/* This is a header file for a random number generator
 * that generates numbers according to a Beta(aa,bb) distribution.
 *
 * Kevin Karplus 3 November 2000
 * 
 * The functions here are made to look as much like a C++ class as
 * is possible in ANSI C.
 */

#ifndef GENBETAH
#define GENBETAH 1


typedef struct _gen_beta_param
{   double a,b;		/* the parameters of the beta distribution */
    /* The remaining fields are precomputed values that can
	 * save some computation when many numbers are drawn from the
	 * same distribution.
	 */
	double min_ab, max_ab;  /* min(a,b) and max(a,b) */
    double sum_ab;		/* a+b */
	double param[3];	/* various precomputed parameters,
     * different for each generation method
     */
} gen_beta_param;

/* Initialize the variables of the already allocated generator in gen .
 * This must be called before gen can be used.
 */
void gen_beta_initialize(gen_beta_param *gen, double a, double b);


/* Generate one number from the distribution specified by gen */
double gen_beta(const gen_beta_param *gen);


#endif
