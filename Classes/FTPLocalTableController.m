//
//  FTPLocalTableController.m
//  Edhita
//
//  Created by t on 10/09/28.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FTPLocalTableController.h"


@implementation FTPLocalTableController

@synthesize remoteController = remoteController_, items = items_;

#pragma mark -
#pragma mark Initialization

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
    }
    return self;
}
*/


#pragma mark -
#pragma mark View lifecycle

/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self refresh];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Override to allow orientations other than the default portrait orientation.
    return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return items_.count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	NSString *text = [items_ objectAtIndex:indexPath.row];
	cell.textLabel.text = text;
	BOOL isDir;
	NSString *path = [path_ stringByAppendingPathComponent:text];
	[[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir];
	cell.imageView.image = [images_ objectAtIndex:isDir];
	
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
	NSString *path = [path_ stringByAppendingPathComponent:[items_ objectAtIndex:indexPath.row]];
	FTPRemoteTableController *tableController = (FTPRemoteTableController *)remoteController_.topViewController;
	BOOL isDir;
	[[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir];
	if (isDir) {		
		FTPLocalTableController *localViewController = [[FTPLocalTableController alloc] initWithPath:path];
		localViewController.remoteController = remoteController_;
		[localViewController refresh];
		[self.navigationController pushViewController:localViewController animated:YES];
		tableController.localFile = @"";
		tableController.localPath = path;
	}
	else {
		tableController.localFile = [path lastPathComponent];
	}
	
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

- (id)initWithPath:(NSString *)path {
	if (self = [super init]) {
		
		path_ = [path retain];
		self.title = [path lastPathComponent];

		NSError *error;
		items_ = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:&error] mutableCopy];
		
		// toolbar
		EdhitaAppDelegate *appDelegate = (EdhitaAppDelegate *)[UIApplication sharedApplication].delegate;
		UIBarButtonItem *editorButton  = [[UIBarButtonItem alloc] initWithTitle:@"Editor" style:UIBarButtonItemStyleBordered target:appDelegate action:@selector(rootViewChangesEditor)];
		UIBarButtonItem *putButton  = [[UIBarButtonItem alloc] initWithTitle:@"PUT" style:UIBarButtonItemStyleBordered target:self action:@selector(putDidPush)];
		UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

		NSArray *items = [NSArray arrayWithObjects:editorButton, flexible, putButton, nil];
		[self setToolbarItems:items];

		// 編集はいらん
//		self.navigationItem.rightBarButtonItem = [self editButtonItem];
		
		UIImage* fileImage = [UIImage imageNamed:@"file.png"];
		UIImage* dirImage = [UIImage imageNamed:@"dir.png"];
		images_ = [[NSArray arrayWithObjects:fileImage, dirImage, nil] retain];
		
	}
	return self;
}

- (void)putDidPush {
	FTPRemoteTableController *tableController = (FTPRemoteTableController *)remoteController_.topViewController;
	[tableController putByFtp];
}

- (void)refresh {
	NSError *error;
	items_ = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:path_ error:&error] mutableCopy];
	[self.tableView reloadData];

	FTPRemoteTableController *tableController = (FTPRemoteTableController *)remoteController_.topViewController;

	tableController.localItems = items_;
	tableController.localTableView = self.tableView;
	tableController.localPath = path_;
	tableController.localFile = @"";
}

@end

