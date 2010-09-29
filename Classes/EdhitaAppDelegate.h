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
#import "FTPLocalTableController.h"
#import "FTPRemoteTableController.h"
#import "FTPLocalNavigationController.h"
#import "FTPRemoteNavigationController.h"


@interface EdhitaAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	
	UISplitViewController *splitViewController_;
	UISplitViewController *ftpViewController_;
}

//@property (nonatomic, retain) IBOutlet UIWindow *window;

- (void) rootViewChangesFtp;

@end

