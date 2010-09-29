//
//  EdhitaAppDelegate.m
//  Edhita
//
//  Created by t on 10/08/08.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "EdhitaAppDelegate.h"

@implementation EdhitaAppDelegate

// @synthesize window;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	
    // Override point for customization after application launch.
	
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

	NSString *homeDir = NSHomeDirectory();
	NSString *path = [homeDir stringByAppendingPathComponent:@"Documents"];
	RootViewController *rootViewController = [[RootViewController alloc] initWithPath:path];
	// tableview単体じゃ仕方ないのでnavviewでwrap
//	rootViewController.title = @"Documents";
	EdhitaNavigationController* navigationController = [[EdhitaNavigationController alloc] initWithRootViewController:rootViewController];
	
	DetailViewController *detailViewController = [[DetailViewController alloc] init];

	rootViewController.detailViewController = detailViewController;

	splitViewController_ = [[UISplitViewController alloc] init];
	splitViewController_.viewControllers = [NSArray arrayWithObjects:navigationController, detailViewController, nil];
	splitViewController_.delegate = detailViewController;
	
	[window addSubview:splitViewController_.view];
	[rootViewController release];
	[navigationController release];
	[detailViewController release];
	
	// FTP

	/* 生のままだと回転対応ができない
	UITableViewController *ftpTableViewController = [[UITableViewController alloc] init];
	UINavigationController *ftpNavViewController = [[EdhitaNavigationController alloc] initWithRootViewController:ftpTableViewController];	
	UIViewController *ftpDetailViewController = [[UIViewController alloc] init];
	ftpDetailViewController.view.backgroundColor = [UIColor grayColor];
	
	ftpViewController_ = [[UISplitViewController alloc] init];
	ftpViewController_.viewControllers = [NSArray arrayWithObjects:ftpNavViewController, ftpDetailViewController, nil];
	ftpViewController_.delegate = detailViewController;
	*/
	
	FTPLocalTableController *localTable = [[FTPLocalTableController alloc] init];
	FTPLocalNavigationController *localNav = [[FTPLocalNavigationController alloc] initWithRootViewController:localTable];

	FTPRemoteTableController *remoteTable = [[FTPRemoteTableController alloc] init];
	FTPLocalNavigationController *remoteNav = [[FTPLocalNavigationController alloc] initWithRootViewController:remoteTable];
	
	ftpViewController_ = [[UISplitViewController alloc] init];
	ftpViewController_.viewControllers = [NSArray arrayWithObjects:localNav, remoteNav, nil];
	ftpViewController_.delegate = remoteNav;
	 
	[window addSubview:ftpViewController_.view];
//	[ftpViewController_.view removeFromSuperview];
	ftpViewController_.view.hidden = YES;

    [window makeKeyAndVisible];
	
	return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [window release];
    [super dealloc];
}

- (void) rootViewChangesFtp {

	// 初めから表示しとかないとlandscapeで表示した時にportraitになる
	[splitViewController_.view removeFromSuperview];
//	splitViewController_.view.hidden = YES;
//	[window addSubview:ftpViewController_.view];
	ftpViewController_.view.hidden = NO;
	
//	splitViewController_.view.hidden = YES;
//	ftpViewController_.view.hidden = NO;

	// もどるとき
/*
	[ftpViewController_.view removeFromSuperview];
	[window addSubview:splitViewController_.view];
	[window addSubview:ftpViewController_.view];
	ftpViewController_.view.hidden = YES;
*/	
	
}


@end
