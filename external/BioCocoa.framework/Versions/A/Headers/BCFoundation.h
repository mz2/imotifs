//
//  BCFoundation.h
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
@abstract Import this header file to use the BioCocoa Foundation framework. 
@discussion Import this header
*/

////////////////////////////////////////////////////////////////////////////
//  BCFOUNDATION HEADER FILES
////////////////////////////////////////////////////////////////////////////

// Defines
#import <BioCocoa/BCFoundationDefines.h>
#import <BioCocoa/BCPreferences.h>

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
#import <BioCocoa/BCDataMatrix.h>

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

// BCGeneExpression
#import <BioCocoa/BCSeries.h>
#import <BioCocoa/BCPlatform.h>
#import <BioCocoa/BCSample.h>
#import <BioCocoa/BCParseSOFT.h>

// BCWebServices
#ifndef GNUSTEP
#import <BioCocoa/BCGeneExpressionOmnibus.h>
#endif
