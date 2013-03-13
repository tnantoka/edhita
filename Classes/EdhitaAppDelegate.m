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

	// サンプルファイル作成
	NSUserDefaults* settings = [NSUserDefaults standardUserDefaults];
	if ([settings boolForKey:@"initialized"] != YES) {

		[settings setBool:YES forKey:@"initialized"];
		
		NSError *error;

		NSString *examples = [path stringByAppendingPathComponent:@"Examples"];
		[[NSFileManager defaultManager] createDirectoryAtPath:examples withIntermediateDirectories:NO attributes:nil error:&error];

		NSString *index = [examples stringByAppendingPathComponent:@"index.html"];
		[[NSFileManager defaultManager] copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"] toPath:index error:&error];
		NSString *style = [examples stringByAppendingPathComponent:@"style.css"];
		[[NSFileManager defaultManager] copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"style" ofType:@"css"] toPath:style error:&error];
		NSString *script = [examples stringByAppendingPathComponent:@"script.js"];
		[[NSFileManager defaultManager] copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"script" ofType:@"js"] toPath:script error:&error];
	}

	RootViewController *rootViewController = [[RootViewController alloc] initWithPath:path];
	// tableview単体じゃ仕方ないのでnavviewでwrap
//	rootViewController.title = @"Documents";
	EdhitaNavigationController* navigationController = [[EdhitaNavigationController alloc] initWithRootViewController:rootViewController];
	
	DetailViewController *detailViewController = [[DetailViewController alloc] init];

	rootViewController.detailViewController = detailViewController;

	splitViewController_ = [[EditorSplitViewController alloc] init];
	splitViewController_.viewControllers = [NSArray arrayWithObjects:navigationController, detailViewController, nil];
	splitViewController_.delegate = detailViewController;
	
	[window addSubview:splitViewController_.view];
	[rootViewController release];
	[navigationController release];
	[detailViewController release];
	
    [self rootViewChangesEditor];
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

- (void) rootViewChangesEditor {
	//[window addSubview:splitViewController_.view];
    window.rootViewController = splitViewController_;
	//[splitViewController_ setupViewWithOrientation:ftpViewController_.interfaceOrientation];
}


@end
