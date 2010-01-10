//
//  BCSequenceView.h
//  BioCocoa
//
//  Created by Koen van der Drift on Sat May 01 2004.
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

#import <Cocoa/Cocoa.h>
#import	"BCAppKitDefines.h"

/*!
@class      BCSequenceView
@abstract   Subclass of NSTextView to display a BCSequence
@discussion This class can be used to display a BCSequence, and has several extensions
* compared to a plain NSTextView. It shows a margin on the left-side of the view
* where linenumbers or symbol numbers can be displayed. Also, the cursor will show the 
* selection of symbols.

* BCSequenceView implements the following delegate methods
* - (void)copy:(id)sender;
* - (void)didClickInTextView: (id)sender location: (NSPoint)thePoint character: (int)c;
* - (void)didDragInTextView: (id)sender location: (NSPoint)thePoint character: (int)c;
* - (void)didMoveInTextView: (id)sender location: (NSPoint)thePoint character: (int)c;
* - (void)didDragSelectionInTextView: (id)sender range: (NSRange)aRange;
* - (NSMenu *)menuForTextView: (id)sender;
* - (void)didDragFilesWithPaths: (NSArray *)paths textView: (id)sender;
* - (NSMenu *)menuForTextView: (id)sender;
* - (NSString *)filterInputString: (NSString *) input textView: (id)sender;
*/

@interface BCSequenceView : NSTextView
{
	BOOL				filter;
    BOOL                drawNumbersInMargin;
    BOOL                drawLineNumbers;
	BOOL				drawOverlay;
	BOOL				drawMarking;
	BCSequenceViewCase	symbolCase;
    NSMutableDictionary *marginAttributes;
	NSMutableDictionary *selectionAttributes;
	
	int					symbolsPerColumn;
	NSString			*unit;
	NSRange				markingRange;
}

-(void)initLineMargin:(NSRect)frame;

- (BOOL)filter;
- (void)setFilter:(BOOL)newFilter;

- (BOOL)drawNumbersInMargin;
- (void)setDrawNumbersInMargin:(BOOL)newDrawNumbersInMargin;

- (BOOL)drawLineNumbers;
- (void)setDrawLineNumbers:(BOOL)newDrawLineNumbers;

- (BOOL)drawOverlay;
- (void)setDrawOverlay:(BOOL)newDrawOverlay;

- (BOOL)drawMarking;
- (void)setDrawMarking:(BOOL)newDrawMarking;

- (BCSequenceViewCase)symbolCase;
- (void)setSymbolCase:(BCSequenceViewCase)newCase;

- (NSRange)markingRange;
- (void)setMarkingRange:(NSRange)newMarkingRange;

- (NSString *)unit;
- (void)setUnit:(NSString *)newUnit;

- (int)symbolsPerColumn;
- (void)setSymbolsPerColumn:(int)newNumber;

-(void)updateMargin;
-(void)updateLayout;

-(void)drawEmptyMargin:(NSRect)aRect;
-(void)drawNumbersInMargin:(NSRect)aRect;
-(void)drawOneNumberInMargin:(unsigned) aNumber inRect:(NSRect)aRect;
-(void)drawMarkingInTextview: (NSRect)rect;
-(void)drawSelectionOverlayInTextview: (NSRect)rect;
-(void)drawOverlayInTextview: (NSRect)rect;

-(NSRect)marginRect;
-(int)charactersPerColumn;

@end

@interface BCSequenceViewContainer : NSTextContainer
{
	float columnWidth;
}

- (float) columnWidth;
- (void) setColumnWidth:(float) width;

@end

@interface BCSequenceViewLayoutManager : NSLayoutManager
{
	int	symbolsPerColumn;
}

- (void)setSymbolsPerColumn:(int)newNumber;

@end
