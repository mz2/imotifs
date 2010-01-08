//
//  BCSequenceView.h
//  BioCocoa
//
//  Created by Koen van der Drift on Sat May 01 2004.
//  Copyright (c) 2005 The BioCocoa Project. All rights reserved.
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
