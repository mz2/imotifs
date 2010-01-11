#import <CoreFoundation/CoreFoundation.h>
#import <CoreServices/CoreServices.h>
#import <QuickLook/QuickLook.h>
#import <Cocoa/Cocoa.h>
#import <math.h>

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
	CGRect mediaBox;
    mediaBox = CGRectMake (0, 0, 512,512);	
	NSRect nsMediaRect = NSRectFromCGRect(mediaBox);
    
	CGContextRef thumbContext = QLThumbnailRequestCreateContext(thumbnail, *(CGSize*)&nsMediaRect.size, false, nil);
    NSGraphicsContext* context = [NSGraphicsContext graphicsContextWithGraphicsPort:(void *)thumbContext flipped:YES];
    
    if (context) {
        [NSGraphicsContext saveGraphicsState];
        [NSGraphicsContext setCurrentContext:context];
        
        [[NSColor redColor] setFill];
        [NSBezierPath fillRect:nsMediaRect];
                
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
