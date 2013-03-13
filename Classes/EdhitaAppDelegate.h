//
//  EdhitaAppDelegate.h
//  Edhita
//
//  Created by t on 10/08/08.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RootViewController.h"
#import "DetailViewController.h"
#import "EdhitaNavigationController.h"
#import "EditorSplitViewController.h"

@interface EdhitaAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	
	EditorSplitViewController *splitViewController_;
}

//@property (nonatomic, retain) IBOutlet UIWindow *window;

- (void) rootViewChangesEditor;

@end

