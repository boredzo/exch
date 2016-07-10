//
//  main.m
//  exch
//
//  Created by Peter Hosey on 2016-07-10.
//  Copyright © 2016 Peter Hosey. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <sysexits.h>

int main(int argc, const char * argv[]) {
	@autoreleasepool {
		NSArray <NSString *> *_Nonnull const args = [NSProcessInfo processInfo].arguments;
		if (args.count < 3) {
			fprintf(stderr, "usage: exch file1 file2\n");
			return EX_NOINPUT;
		}

		NSURL *URL1 = [NSURL fileURLWithPath:args[1]];
		NSURL *URL2 = [NSURL fileURLWithPath:args[2]];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
		FSRef ref1, ref2;
		if (CFURLGetFSRef((__bridge CFURLRef)URL1, &ref1)) {
			if (CFURLGetFSRef((__bridge CFURLRef)URL2, &ref2)) {
				OSStatus err = FSExchangeObjects(&ref1, &ref2);
				if (err != noErr) {
					NSLog(@"error: %s", GetMacOSStatusCommentString(err));
				}
				return err == noErr ? EXIT_SUCCESS : EX_OSERR;
			}
		}
#pragma clang diagnostic pop
	}
	return EXIT_FAILURE;
}
