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
//
//  IMConstants.h
//  iMotifs
//
//  Created by Matias Piipari on 05/06/2009.
//  Copyright 2009 Wellcome Trust Sanger Institute. All rights reserved.
//

#import <Cocoa/Cocoa.h>

const static NSInteger IMMaxAdvisedSeqCountForNMInfer = 100;
const static NSInteger IMAdviseableNumMotifsForNMInfer = 10;

const static CGFloat const IMSequenceCellMargin = 4.0;

extern NSString * const IMSymbolWidthKey;
extern NSString * const IMSequenceFocusAreaHalfLengthKey;

const static CGFloat IMDefaultSymbolWidth = 2.0; 
const static CGFloat IMSymbolWidthIncrement = 0.1;
const static NSUInteger IMSequenceFocusAreaHalfLength = 10;


typedef enum IMStrand {
    IMStrandPositive = 1,
    IMStrandNegative = -1,
    IMStrandNA = 0
} IMStrand;