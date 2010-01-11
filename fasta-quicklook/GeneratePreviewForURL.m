#import <CoreFoundation/CoreFoundation.h>
#import <CoreServices/CoreServices.h>
#import <QuickLook/QuickLook.h>
#import <Cocoa/Cocoa.h>
#import <math.h>
#import <MotifViewCell.h>
#import <MotifSetParser.h>

#import "BCSequenceReader.h"
#import "BCSequenceArray.h"
/* -----------------------------------------------------------------------------
 Generate a preview for file
 
 This function's job is to create preview for designated file
 ----------------------------------------------------------------------------- */

OSStatus GeneratePreviewForURL(void *thisInterface, 
                               QLPreviewRequestRef preview, 
                               CFURLRef url, 
                               CFStringRef contentTypeUTI, 
                               CFDictionaryRef options) {
    
    
    NSString *path = [(NSURL*)url path];
    BCSequenceReader *sequenceReader = [[[BCSequenceReader alloc] init] autorelease];
    BCSequenceArray *sequenceArray = [sequenceReader readFileUsingPath: path 
                                                                format: BCFastaFileFormat];
    NSLog(@"Reading from %@", path);
    /*
	CGRect mediaBox;
    mediaBox = CGRectMake(0, 0, 512, 512);	
	NSRect nsMediaRect = NSRectFromCGRect(mediaBox);
    
	CGContextRef pdfContext = QLPreviewRequestCreatePDFContext(preview,&mediaBox,nil, options);
	CGPDFContextBeginPage(pdfContext,NULL);
    NSGraphicsContext* context = [NSGraphicsContext graphicsContextWithGraphicsPort:(void *)pdfContext flipped:YES];
    
    if (context) {
        [NSGraphicsContext saveGraphicsState];
        [NSGraphicsContext setCurrentContext:context];
        
        [[NSColor redColor] setFill];
        [NSBezierPath fillRect:nsMediaRect];
        
        
        [NSGraphicsContext restoreGraphicsState];
    } 
    
    CGPDFContextEndPage(pdfContext);
    QLPreviewRequestFlushContext(preview, pdfContext);
    
    CFRelease(pdfContext);
    pdfContext = nil;
    //CFRelease(urlStr);
    //urlStr = nil;

    return noErr; */
    
    NSAutoreleasePool *pool;
    NSMutableDictionary *props;
    NSMutableString *html;
    
    pool = [[NSAutoreleasePool alloc] init];

    if (QLPreviewRequestIsCancelled(preview))
        return noErr;
    
    props=[[[NSMutableDictionary alloc] init] autorelease];
    [props setObject:@"UTF-8" forKey:(NSString *)kQLPreviewPropertyTextEncodingNameKey];
    [props setObject:@"text/html" forKey:(NSString *)kQLPreviewPropertyMIMETypeKey];
    
    html=[[[NSMutableString alloc] init] autorelease];
    [html appendString:@"<html><body bgcolor=white>"];
    [html appendString:@"<h2>Sequence count:"];
    [html appendString:@"FOOBAR"];
    [html appendString:@"<br><h2>End Date:</h2><br>"];
    [html appendString:@"BARFOO"];
    [html appendString:@"</body></html>"];
             
    QLPreviewRequestSetDataRepresentation(preview,
                                          (CFDataRef)[html dataUsingEncoding:NSUTF8StringEncoding],
                                          kUTTypeHTML,
                                          (CFDictionaryRef)props);
    
    [pool release];
    return noErr;
}

void CancelPreviewGeneration(void* thisInterface, QLPreviewRequestRef preview)
{
    // implement only if supported
}
