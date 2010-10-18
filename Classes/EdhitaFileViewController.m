//
//  EdhitaTableViewController.m
//  Edhita
//
//  Created by t on 10/08/21.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EdhitaFileViewController.h"

@implementation EdhitaFileViewController

@synthesize detailViewController;

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

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/

- (void)viewWillDisappear:(BOOL)animated {
	[self renameFile];
    [super viewWillDisappear:animated];
}

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
    return [items_ count];
}

// ファイル情報をCellに表示する。
// かなり汚いのでリファクタリング必要
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

	// Configure the cell...
	cell.textLabel.text = [items_ objectAtIndex:indexPath.row];
	
	
	NSError *error;
	NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path_ error:&error];
	
	// switch内では変数宣言できないからif文の方が楽。
	// 嘘。ブロックで囲えば変数宣言できる。いずれ直す
    if (indexPath.row == 0) {
		textField_ = [[UITextField alloc] initWithFrame:CGRectMake(cell.frame.size.width * 0.3, 0, cell.frame.size.width * 0.6, cell.frame.size.height)];
		textField_.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		textField_.textAlignment = UITextAlignmentRight;
		textField_.delegate = self;
		textField_.text = [path_ lastPathComponent];
		textField_.returnKeyType = UIReturnKeyDone;
		textField_.clearButtonMode = UITextFieldViewModeWhileEditing;
		[textField_ becomeFirstResponder];		
		[cell.contentView addSubview:textField_];
		textField_.autocorrectionType = UITextAutocorrectionTypeNo;
		textField_.autocapitalizationType = UITextAutocapitalizationTypeNone;
	}
	else {
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.size.width * 0.3, 0, cell.frame.size.width * 0.6, cell.frame.size.height)];
		label.textAlignment = UITextAlignmentRight;
		label.backgroundColor = [UIColor clearColor];
		[cell.contentView addSubview:label];

		if(indexPath.row == 1) {
// timezoneが入ってくるので却下
//			textField.text = [[attributes objectForKey:NSFileModificationDate] description];
//			textField.text = [[attributes objectForKey:NSFileModificationDate] descriptionWithLocale:nil];

// documentに載ってるくせに。
//			textField.text = [[attributes objectForKey:NSFileModificationDate] descriptionWithCalendarFormat:@"%Y-%m-%d %H:%M:%S" timeZone:nil locale:nil];

			NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
			[dateFormatter setDateFormat:@"Y-MM-dd HH:mm:ss"];
			label.text = [dateFormatter stringFromDate:[attributes objectForKey:NSFileModificationDate]];						
		}
		else if(indexPath.row == 2) {
			label.text = [NSString stringWithFormat:@"%@ bytes", [attributes objectForKey:NSFileSize]];
		}
	}

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
	if (self = [super initWithStyle:UITableViewStyleGrouped]) {
		items_ = [[NSArray arrayWithObjects: @"Name", @"Modified", @"Size", nil] retain];
		path_ = [path retain];
		self.title = [path_ lastPathComponent];
		textField_ = [[UITextField alloc] init];
		
		srand(time(NULL));
		AdMobView *adMobView;
		
		switch (rand() % 2) {
			case 0:
				adMobView = [AdMobView requestAdOfSize:ADMOB_SIZE_320x270 withDelegate:self];				
				break;
			case 1:
				adMobView = [AdMobView requestAdOfSize:ADMOB_SIZE_320x48 withDelegate:self];
		}
		
		self.tableView.tableFooterView = adMobView;
		
		
	}
	return self;
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
	[self renameFile];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return NO;
}

// ファイル名変更（textField編集完了時と、Viewの非表示化の際に呼ばれる）
- (void)renameFile {
	NSError *error;
	NSString *dstPath = [[path_ stringByDeletingLastPathComponent] stringByAppendingPathComponent:textField_.text];
	[[NSFileManager defaultManager] moveItemAtPath:path_ toPath:dstPath error:&error];
}

// 勝手にサイズが変わらないようにkeyboad（日本語）表示状態のheightで固定
- (CGSize)contentSizeForViewInPopover {
	return CGSizeMake(320, 527);
}


#pragma mark -
#pragma mark AdMobDelegate methods

- (NSString *)publisherIdForAd:(AdMobView *)adView {
	return kPublisherId; // this should be prefilled; if not, get it from www.admob.com
}

- (UIViewController *)currentViewControllerForAd:(AdMobView *)adView {
	// Return the top level view controller if possible. In this case, it is
	// the split view controller
	return self.splitViewController;
	//	return self.navigationController.parentViewController;
}

- (void)willPresentFullScreenModalFromAd:(AdMobView *)adView {
	// IMPORTANT!!! IMPORTANT!!!
	// If we are about to get a full screen modal and we have a popover controller, dimiss it.
	// Otherwise, you may see the popover on top of the landing page.
	if (detailViewController.popoverController && detailViewController.popoverController.popoverVisible) {
		[detailViewController.popoverController dismissPopoverAnimated:YES];
	}
}

- (NSArray *)testDevices {
	return [NSArray arrayWithObjects: ADMOB_SIMULATOR_ID, kTestIPadId, nil];
}


@end

