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