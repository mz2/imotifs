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
