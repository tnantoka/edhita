//
//  EdhitaTableViewController.m
//  Edhita
//
//  Created by t on 10/08/21.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EdhitaFileViewController.h"

#import "GADBannerView.h"

@implementation EdhitaFileViewController {
    GADBannerView *bannerView_;
}


@synthesize detailViewController;

#pragma mark -
#pragma mark View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setToolbarHidden:YES animated:YES];
}

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
		UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(cell.frame.size.width * 0.3, 0, cell.frame.size.width * 0.6, cell.frame.size.height)] autorelease];
		label.textAlignment = UITextAlignmentRight;
		label.backgroundColor = [UIColor clearColor];
		[cell.contentView addSubview:label];

		if(indexPath.row == 1) {
			NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
			[dateFormatter setDateFormat:@"Y-MM-dd HH:mm:ss"];
			label.text = [dateFormatter stringFromDate:[attributes objectForKey:NSFileModificationDate]];						
		}
		else if(indexPath.row == 2) {
			label.text = [NSString stringWithFormat:@"%@ bytes", [attributes objectForKey:NSFileSize]];
		}
	}

    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
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
    [bannerView_ release];
    [super dealloc];
}

- (id)initWithPath:(NSString *)path {
	if (self = [super initWithStyle:UITableViewStyleGrouped]) {
		items_ = [[NSArray arrayWithObjects: @"Name", @"Modified", @"Size", nil] retain];
		path_ = [path retain];
		self.title = [path_ lastPathComponent];
		textField_ = [[UITextField alloc] init];
		
        // AdMob
		srand(time(NULL));

        bannerView_ = nil;
        switch (rand() % 2) {
			case 0:
                bannerView_ = [[GADBannerView alloc]
                               initWithAdSize:kGADAdSizeMediumRectangle];
                bannerView_.frame = CGRectOffset(bannerView_.frame, 10.0f, 0);
				break;
			case 1:
                bannerView_ = [[GADBannerView alloc]
                               initWithAdSize:kGADAdSizeBanner];
				break;
		}
        bannerView_.adUnitID = kPublisherId;
        bannerView_.rootViewController = self;
        
        GADRequest *request = [GADRequest request];
#ifdef DEBUG
        NSLog(@"debug");
        request.testing = YES;
#endif
        [bannerView_ loadRequest:request];
        
		self.tableView.tableFooterView = bannerView_;

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


@end

