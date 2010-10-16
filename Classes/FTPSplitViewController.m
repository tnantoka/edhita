//
//  FTPSplitViewController.m
//  Edhita
//
//  Created by t on 10/10/09.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FTPSplitViewController.h"


@implementation FTPSplitViewController

- (void) viewWillAppear:(BOOL)animated {
	if (self.interfaceOrientation == UIInterfaceOrientationPortrait|| 
		self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
		
		UIViewController *root = [self.viewControllers objectAtIndex:0];
		UIViewController *detail = [self.viewControllers objectAtIndex:1];
		[self keepRootInPortrait:root detail:detail];
	}	
//	NSLog(@"show ftp");

	// FTP表示のタイミングでファイル更新を反映
	UIViewController *root = [self.viewControllers objectAtIndex:0];
	[root viewWillAppear:animated];
	
}


// Portrailの時も2ペインで
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
										 duration:(NSTimeInterval)duration {

	UIViewController *root = [self.viewControllers objectAtIndex:0];
	UIViewController *detail = [self.viewControllers objectAtIndex:1];

	if (interfaceOrientation == UIInterfaceOrientationPortrait ||
		interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
		
		[self keepRootInPortrait:root detail:detail];
		
	}
	else {
		// 高さを調整しないとtoolbarがずれる
		root.view.frame = CGRectMake(0, 0, 320, 768 - 20);
		detail.view.frame = CGRectMake(321, 0, 704, 768 - 20);
		[super willAnimateRotationToInterfaceOrientation:interfaceOrientation
												duration:duration];	
	}
}

- (void)keepRootInPortrait:(UIViewController *)root detail:(UIViewController *)detail {
	// 高さを調整しないとtoolbarがずれる
	root.view.frame = CGRectMake(0, 0, 320, 1024 - 48);
	detail.view.frame = CGRectMake(321, 0, 448, 1024 -48);
}


@end
