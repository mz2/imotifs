/*
 *  gen_dirch_mix.c	generating random vectors 
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
/* This is a source file for a random number generator
 * that generates probability vectors according to a 
 * mixture of Dirichlet distributions.
 *
 * Kevin Karplus
 * 7 Nov 2000
 *
 * The functions here are made to look as much like a C++ class as
 * is possible in ANSI C.
 */


#include "gen_dirch_mix.h"
#include <assert.h>
#include <stdlib.h>
/* pick which underlying uniform random number generator to use. */
#define DRAND() ((random()+0.5)/ 2147483648.0)

void gen_dirch_mix_initialize(gen_dirch_mix_param *gen, 
                              int alphabet_size,
                              int num_components,
                              const double *mix,
                              const double **comps)
/* alpha values are in comp[c][1..alphabet_size]
 *	comp[c][0] should be sum of alphas for the component
 */
{
    int c;
    double sum=0.;
    gen->num_comp = num_components;
    gen->mix_coeff_cum = (double*)calloc(num_components, 
                                         sizeof(double));
    gen->comp = (gen_dirch_param*)calloc(num_components, 
                                         sizeof(gen_dirch_param));
    
    for (c=0; c<num_components; c++)
    {   sum += mix[c];
       	assert (mix[c] >=0);
        gen->mix_coeff_cum[c] = sum;
    	gen_dirch_initialize(&(gen->comp[c]), alphabet_size,
                             comps[c]+1);
    }
    assert(sum>0);
    for (c=0; c<num_components; c++)
    {	gen->mix_coeff_cum[c] /= sum;
    }    
}

/* generate a probability vector according to the distribution and
 * store it in probs
 */
void gen_dirch_mix(const gen_dirch_mix_param *gen, double *probs)
{
    double x;
    int clo=-1, chi=gen->num_comp-1;
    int cmid;
    x = DRAND();
    /* do binary search to determine component */
    while (clo<chi-1)
    {   /* invariant: 
	 *    gen->mix_coeff_cum[clo] < x <=  gen->mix_coeff_cum[chi]
	 */
        assert (x <= gen->mix_coeff_cum[chi]);
        cmid = (clo+chi+1)/2;
        if (x > gen->mix_coeff_cum[cmid]) clo=cmid;
        else chi=cmid;
    }
    gen_dirch(&(gen->comp[chi]), probs);
}


/* free the storage internal to gen, but not gen itself */
void gen_dirch_mix_free(gen_dirch_mix_param *gen)
{
    int c;
    for (c=gen->num_comp-1; c>=0; c--)
    {    gen_dirch_free(&(gen->comp[c]));
    }
    free(gen->comp);
    free(gen->mix_coeff_cum);
}
