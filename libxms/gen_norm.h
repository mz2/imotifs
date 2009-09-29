/*
 *  gen_norm.h	generating random numbers from a standard normal distribution
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
 * that generates numbers according to a standard normal distribution.
 *
 * Kevin Karplus 7 November 2000
 * 
 * The functions here are made to look as much like a C++ class as
 * is possible in ANSI C.
 */

#ifndef GENNORMH
#define GENNORMH 1


/* Generate one number from the standard normal distribution */
double gen_norm(void);


#endif
