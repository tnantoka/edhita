//
//  FTPSplitViewController.h
//  Edhita
//
//  Created by t on 10/10/09.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTPSplitViewController : UISplitViewController {
}

- (void)keepRootInPortrait:(UIViewController *)root detail:(UIViewController *)detail;

@end
