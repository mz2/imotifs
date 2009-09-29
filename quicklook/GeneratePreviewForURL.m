#import <CoreFoundation/CoreFoundation.h>
#import <CoreServices/CoreServices.h>
#import <QuickLook/QuickLook.h>
#import <Cocoa/Cocoa.h>
#import <math.h>
#import <MotifViewCell.h>
#import <MotifSetParser.h>
#import <MotifPainter.h>

/* -----------------------------------------------------------------------------
 Generate a preview for file
 
 This function's job is to create preview for designated file
 ----------------------------------------------------------------------------- */

OSStatus GeneratePreviewForURL(void *thisInterface, 
                               QLPreviewRequestRef preview, 
                               CFURLRef url, 
                               CFStringRef contentTypeUTI, 
                               CFDictionaryRef options) {
	MotifSet *motifSet = [MotifSetParser motifSetFromURL:(NSURL*)url];
	int numMotifsToDraw = [motifSet count];
	numMotifsToDraw = fmin(IMQuickLoockMaxMotifsPerPage,numMotifsToDraw);
	
	CGRect mediaBox;
    mediaBox = CGRectMake (0, 0, 
                           IMDefaultColWidth * [motifSet columnCountWithOffsets] + (IMDefaultColWidth * 5), 
                           IMDefaultColHeight * numMotifsToDraw);	
	NSRect nsMediaRect = NSRectFromCGRect(mediaBox);
    
    NSMutableDictionary* auxInfo = [NSMutableDictionary dictionary];
	[ auxInfo setObject:@"Matias Piipari (mp4@sanger.ac.uk)" forKey: (id)kCGPDFContextAuthor ];
	[ auxInfo setObject:@"xmslook" forKey: (id)kCGPDFContextCreator ];
	
	CFStringRef urlStr = CFURLGetString(url);
	CFRetain(urlStr);
	
	[ auxInfo setObject:(NSString*)urlStr forKey: (id)kCGPDFContextTitle ];
	
	CGContextRef pdfContext = QLPreviewRequestCreatePDFContext(preview,&mediaBox,(CFDictionaryRef)auxInfo, options);
	CGPDFContextBeginPage(pdfContext,NULL);
	
    NSGraphicsContext* context = [NSGraphicsContext graphicsContextWithGraphicsPort:(void *)pdfContext flipped:YES];
    
    if (context) {
        [NSGraphicsContext saveGraphicsState];
        [NSGraphicsContext setCurrentContext:context];
        
        [MotifPainter drawMotifSet:motifSet
                              rect:nsMediaRect 
                           context:context];
    
        [NSGraphicsContext restoreGraphicsState];
    } 
    
    CGPDFContextEndPage(pdfContext);
    QLPreviewRequestFlushContext(preview, pdfContext);
    
    CFRelease(pdfContext);
    pdfContext = nil;
    CFRelease(urlStr);
    urlStr = nil;
    
    return noErr; 
}

void CancelPreviewGeneration(void* thisInterface, QLPreviewRequestRef preview)
{
    // implement only if supported
}
