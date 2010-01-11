//
//  BCFoundationDefines.h
//  BioCocoa
//
//  Created by Alexander Griekspoor on 9/12/04.
//  Copyright (c) 2003-2009 The BioCocoa Project.
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions
//  are met:
//  1. Redistributions of source code must retain the above copyright
//  notice, this list of conditions and the following disclaimer.
//  2. Redistributions in binary form must reproduce the above copyright
//  notice, this list of conditions and the following disclaimer in the
//  documentation and/or other materials provided with the distribution.
//  3. The name of the author may not be used to endorse or promote products
//  derived from this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
//  IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
//  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
//  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
//  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
//  NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
//  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
//  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
//  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

/*!
@header
@abstract Global macros, enumerations and data structure for BioCocoa Foundation.
@discussion This header declares global macros, enumerations and data structures
for the BioCocoa Foundation Framework.  Import the top-level header
file BCFoundation.h to get these definitions as well as the BioCocoa
Foundation classes.
*/

////////////////////////////////////////////////////////////////////////////
//  GLOBAL DEFINES
////////////////////////////////////////////////////////////////////////////

#define			hydrogenMonoisotopicMass	1.00782503
#define			oxygenMonoisotopicMass		15.99491463
#define			hydrogenAverageMass			1.01
#define			oxygenAverageMass			15.996

////////////////////////////////////////////////////////////////////////////
//  GLOBAL ENUMs
////////////////////////////////////////////////////////////////////////////

/*!
@enum       BCSequenceType
 @abstract   A list of sequence types, for readability
 @constant   BCSequenceTypeOther     something we haven't thought of yet
 @constant   BCSequenceTypeDNA       DNA
 @constant   BCSequenceTypeRNA       RNA
 @constant   BCSequenceTypeProtein   Protein
 @constant   BCSequenceTypeCodon     Codon
 */
typedef enum BCSequenceType {
    BCSequenceTypeOther = 0,
    BCSequenceTypeDNA = 1,
    BCSequenceTypeRNA = 2,
    BCSequenceTypeProtein = 3,
    BCSequenceTypeCodon = 4
} BCSequenceType;


/*!
@enum       BCGeneticCodeName
 @abstract   Provides an ordered list of possible genetic codes.  Allows for a lightweight, readable implementation.
 */
typedef enum BCGeneticCodeName {
    BCUniversalCode = 1,
    BCVertebrateMitochondrial = 2
    
} BCGeneticCodeName;



/*!
@enum       BCMassType
 @abstract   A list of mass types, for calculating molecular masses
 @constant   BCMonoisotopic 
 @constant   BCAverage
 */
typedef enum BCMassType {
    BCMonoisotopic = 1,
    BCAverage = 2
} BCMassType;


/*!
@enum       BCHydropathyType
 @abstract   A list of hydropathy types, for calculating hydropathy values
 @constant   BCKyteDoolittle 
 @constant   BCHoppWoods
 */
typedef enum BCHydropathyType {
    BCKyteDoolittle = 1,
    BCHoppWoods = 2
} BCHydropathyType;

/*!
@enum       BCSecondaryStructureType
 @abstract   A list of secondary structure types, for readability
 @constant   BCAnyStructure     something we haven't thought of yet
 @constant   BCHelix			Alpha helix
 @constant   BCSheet			Beta sheet
 @constant   BCTurn				Turn
 */
typedef enum BCSecondaryStructureType {
    BCAnyStructure = 0,
    BCHelix = 1,
    BCSheet = 2,
    BCTurn = 3
} BCSecondaryStructureType;

