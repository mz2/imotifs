//
//  BCFoundationDefines.h
//  BioCocoa
//
//  Created by Alexander Griekspoor on 9/12/04.
//  Copyright 2004 The BioCocoa Project. All rights reserved.
//
//  This code is covered by the Creative Commons Share-Alike Attribution license.
//	You are free:
//	to copy, distribute, display, and perform the work
//	to make derivative works
//	to make commercial use of the work
//
//	Under the following conditions:
//	You must attribute the work in the manner specified by the author or licensor.
//	If you alter, transform, or build upon this work, you may distribute the resulting work only under a license identical to this one.
//
//	For any reuse or distribution, you must make clear to others the license terms of this work.
//	Any of these conditions can be waived if you get permission from the copyright holder.
//
//  For more info see: http://creativecommons.org/licenses/by-sa/2.5/

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

