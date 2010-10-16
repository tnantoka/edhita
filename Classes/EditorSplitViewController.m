    //
//  EditorSplitViewController.m
//  Edhita
//
//  Created by t on 10/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EditorSplitViewController.h"


@implementation EditorSplitViewController

- (void) viewWillAppear:(BOOL)animated {
/*	
	NSLog(@"split show");
	[super viewWillAppear:animated];
	
	if (self.interfaceOrientation == UIInterfaceOrientationPortrait|| 
		self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {

		UIViewController *detail = [self.viewControllers objectAtIndex:1];
		detail.view.frame = CGRectMake(0, 0, 768, 1024 - 48);
		NSLog(@"detail:w=%f, h=%f", detail.view.frame.size.width, detail.view.frame.size.height);
		NSLog(@"split:w=%f, h=%f", self.view.frame.size.width, self.view.frame.size.height);
		
	}
	else {

		UIViewController *root = [self.viewControllers objectAtIndex:0];
		UIViewController *detail = [self.viewControllers objectAtIndex:1];
		root.view.frame = CGRectMake(0, 0, 320, 500 - 20);
		detail.view.frame = CGRectMake(321, 0, 704, 768 - 20);
		NSLog(@"root:w=%f, h=%f", root.view.frame.size.width, root.view.frame.size.height);
		NSLog(@"detail:w=%f, h=%f", detail.view.frame.size.width, detail.view.frame.size.height);
		NSLog(@"split:w=%f, h=%f", self.view.frame.size.width, self.view.frame.size.height);
	}
*/
 /*
	[super viewWillAppear:animated];
//	[super willAnimateRotationToInterfaceOrientation:self.interfaceOrientation
//											duration:0];	
	
	NSLog(@"self=%d", self.interfaceOrientation);
	NSLog(@"ftp=%d", ftpViewController_.interfaceOrientation);
	[super willAnimateRotationToInterfaceOrientation:ftpViewController_.interfaceOrientation
											duration:0];	
*/	
	[super viewWillAppear:animated];

	// FTPからの復帰のタイミングでファイル更新を反映
	UIViewController *root = [self.viewControllers objectAtIndex:0];
	[root viewWillAppear:animated];

}


// FTPから復帰したときにorientaionを反映する
- (void)setupViewWithOrientation:(UIInterfaceOrientation)orientation {

	if (orientation == UIInterfaceOrientationPortrait|| 
		orientation == UIInterfaceOrientationPortraitUpsideDown) {
		
		UIViewController *detail = [self.viewControllers objectAtIndex:1];
		detail.view.frame = CGRectMake(0, 0, 768, 1024 - 48);
//		NSLog(@"detail:w=%f, h=%f", detail.view.frame.size.width, detail.view.frame.size.height);
//		NSLog(@"split:w=%f, h=%f", self.view.frame.size.width, self.view.frame.size.height);
		
	}
	else {
		
		UIViewController *root = [self.viewControllers objectAtIndex:0];
		UIViewController *detail = [self.viewControllers objectAtIndex:1];
		root.view.frame = CGRectMake(0, 0, 320, 768 - 20);
		detail.view.frame = CGRectMake(321, 0, 704, 768 - 20);
//		NSLog(@"root:w=%f, h=%f", root.view.frame.size.width, root.view.frame.size.height);
//		NSLog(@"detail:w=%f, h=%f", detail.view.frame.size.width, detail.view.frame.size.height);
//		NSLog(@"split:w=%f, h=%f", self.view.frame.size.width, self.view.frame.size.height);
	}
}



@end
