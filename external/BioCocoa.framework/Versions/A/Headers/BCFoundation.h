//
//  BCFoundation.h
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
@abstract Import this header file to use the BioCocoa Foundation framework. 
@discussion Import this header
*/

////////////////////////////////////////////////////////////////////////////
//  BCFOUNDATION HEADER FILES
////////////////////////////////////////////////////////////////////////////

// Defines
#import <BioCocoa/BCFoundationDefines.h>

// General Classes

// BCGeneticCode
#import <BioCocoa/BCCodon.h>
#import <BioCocoa/BCCodonDNA.h>
#import <BioCocoa/BCCodonRNA.h>
#import <BioCocoa/BCGeneticCode.h>

// BCSequence
#import <BioCocoa/BCSequence.h>
#import <BioCocoa/BCSequenceCodon.h>
#import <BioCocoa/BCAnnotation.h>
#import <BioCocoa/BCSequenceArray.h>

// BCSequenceIO
#import <BioCocoa/BCSequenceReader.h>
#import <BioCocoa/BCSequenceWriter.h>
#import <BioCocoa/BCCachedSequenceFile.h>

// BCSymbol
#import <BioCocoa/BCAminoAcid.h>
#import <BioCocoa/BCNucleotideDNA.h>
#import <BioCocoa/BCNucleotideRNA.h>
#import <BioCocoa/BCSymbol.h>
#import <BioCocoa/BCSymbolSet.h>

// BCTools
#import <BioCocoa/BCSequenceTool.h>
#import <BioCocoa/BCToolMassCalculator.h>
#import <BioCocoa/BCToolHydropathyCalculator.h>
#import <BioCocoa/BCToolTranslator.h>
#import <BioCocoa/BCToolSequenceFinder.h>
#import <BioCocoa/BCToolSymbolCounter.h>
#import <BioCocoa/BCToolComplement.h>
#import <BioCocoa/BCSuffixArray.h>
#import <BioCocoa/BCMCP.h>

// BCUtils
#import <BioCocoa/BCUtilStrings.h>
#import <BioCocoa/BCUtilData.h>

// BCSequenceAlignment
#import <BioCocoa/BCSequenceAlignment.h>
#import <BioCocoa/BCScoreMatrix.h>

// BCProteinStructure
#import <BioCocoa/BCAtom.h>
#import <BioCocoa/BCChain.h>
#import <BioCocoa/BCProteinStructure.h>
#import <BioCocoa/BCResidue.h>
#import <BioCocoa/BCSecondaryStructure.h>
#import <BioCocoa/BCSequenceStructure.h>
