#import <Foundation/Foundation.h>
#import "MotifSetParser.h";

NSString* const version = @"0.1";

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

    //NSUserDefaults *args = [NSUserDefaults standardUserDefaults];
    NSLog(@"XMSParser v. %@", version);

    if (argc < 2) {
        NSLog(@"USAGE: XMSParser foo.xms bar.xms");
        return 1;
    }
    int i;
    for (i = 1; i < argc; i++) {
        NSString *fname = [NSString stringWithUTF8String: argv[i]];
        NSURL *url = [NSURL fileURLWithPath:fname];
        MotifSet* mset = [MotifSetParser motifSetFromURL:url];
        NSLog(@"Motif set:%@",mset);
        
    }
    [pool drain];
    return 0;
}
