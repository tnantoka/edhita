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

	[super viewWillAppear:animated];

	// FTPからの復帰のタイミングでファイル更新を反映
	UIViewController *root = [self.viewControllers objectAtIndex:0];
	[root viewWillAppear:animated];

}


@end
