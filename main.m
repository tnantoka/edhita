//
//  main.m
//  Edhita
//
//  Created by t on 10/08/08.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[]) {
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
//    int retVal = UIApplicationMain(argc, argv, nil, nil);
    int retVal = UIApplicationMain(argc, argv, nil, @"EdhitaAppDelegate");
    [pool release];
    return retVal;
}
