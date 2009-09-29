#import <CoreFoundation/CoreFoundation.h>
#import <CoreServices/CoreServices.h>
#import <QuickLook/QuickLook.h>
#import <Cocoa/Cocoa.h>
#import <math.h>
#import <MotifSet.h>
#import <Motif.h>
#import <MotifPainter.h>
#import <MotifSetParser.h>
#import <MotifViewCell.h>

/* -----------------------------------------------------------------------------
    Generate a thumbnail for file

   This function's job is to create thumbnail for designated file as fast as possible
   ----------------------------------------------------------------------------- */


OSStatus GenerateThumbnailForURL(
                                 void *thisInterface, 
                                 QLThumbnailRequestRef thumbnail, 
                                 CFURLRef url, 
                                 CFStringRef contentTypeUTI, 
                                 CFDictionaryRef options, 
                                 CGSize maxSize) {	
    MotifSet *motifSet = [MotifSetParser motifSetFromURL:(NSURL*)url];
	int numMotifsToDraw = [motifSet count];
	numMotifsToDraw = fmin(50,numMotifsToDraw);
	
	CGRect mediaBox;
    mediaBox = CGRectMake (0, 0, 
                           IMDefaultColWidth * [motifSet columnCountWithOffsets] + (IMDefaultColWidth * 5), 
                           IMDefaultColHeight * numMotifsToDraw);	
	NSRect nsMediaRect = NSRectFromCGRect(mediaBox);
    
	CGContextRef thumbContext = QLThumbnailRequestCreateContext(thumbnail, *(CGSize*)&nsMediaRect.size, false, nil);
    NSGraphicsContext* context = [NSGraphicsContext graphicsContextWithGraphicsPort:(void *)thumbContext flipped:YES];
    
    if (context) {
        [NSGraphicsContext saveGraphicsState];
        [NSGraphicsContext setCurrentContext:context];
        
        [[NSColor whiteColor] setFill];
        [NSBezierPath fillRect:nsMediaRect];
        
        [MotifPainter drawMotifSet:motifSet
                              rect:nsMediaRect 
                           context:context];
        
        [NSGraphicsContext restoreGraphicsState];
    } 
    
    QLThumbnailRequestFlushContext(thumbnail, thumbContext);
    CFRelease(thumbContext);
    thumbContext = nil;
    
    return noErr; 
}

void CancelThumbnailGeneration(void* thisInterface, QLThumbnailRequestRef thumbnail)
{
    // implement only if supported
}
