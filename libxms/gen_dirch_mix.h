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
 *  gen_dirch_mix.h	generating random vectors 
 *			from a mixture Dirichlet densities
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
 * that generates probability vectors according to a 
 * mixture of Dirichlet distributions.
 *
 * Kevin Karplus
 * 7 Nov 2000
 *
 * The functions here are made to look as much like a C++ class as
 * is possible in ANSI C.
 */


#ifndef GENDIRCHMIXH
#define GENDIRCHMIXH

#include "gen_dirch.h"

typedef struct _gen_dirch_mix_param
{   int num_comp;	/* number of components */
	double *mix_coeff_cum;	/* cumulative sum of mixture coefficients */
	gen_dirch_param *comp;	/* components */
} gen_dirch_mix_param;



void gen_dirch_mix_initialize(gen_dirch_mix_param *gen, 
                              int alphabet_size,
                              int num_components,
                              const double *mix,
                              const double **comps);
/*
 * The mixture coefficients need not some to one, but must be >=0.
 * The generator will normalize internally.
 *
 * Alpha values are in comp[c][1..alphabet_size]
 *	comp[c][0] should be sum of alphas for the component
 * This slightly awkward format was chosen for compatibility with
 * existing datastructures that stored mixtures of Dirichlets.
 * Alpha values must be strictly positive.
 */


/* generate a probability vector according to the distribution and
 * store it in probs
 */
void gen_dirch_mix(const gen_dirch_mix_param *gen, double *probs);


/* free the storage internal to gen, but not gen itself */
void gen_dirch_mix_free(gen_dirch_mix_param *gen);

#endif

