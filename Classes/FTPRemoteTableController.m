//
//  FTPRemoteTableController.m
//  Edhita
//
//  Created by t on 10/09/28.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FTPRemoteTableController.h"

@implementation FTPRemoteTableController

@synthesize popoverController, localPath = localPath_, localItems = localItems_, localTableView = localTableView_, urlString = urlString_, localFile = localFile_;

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
	[self listByFTP];
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
	NSDictionary *item = [items_ objectAtIndex:indexPath.row];
	cell.textLabel.text = [item objectForKey:(id)kCFFTPResourceName];
	cell.imageView.image = [images_ objectForKey:[item objectForKey:(id)kCFFTPResourceType]];
	
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
	
	NSDictionary *item = [items_ objectAtIndex:indexPath.row];
	NSString *name = [item objectForKey:(id)kCFFTPResourceName];
	NSInteger type = [(NSNumber *)[item objectForKey:(id)kCFFTPResourceType] integerValue];

	// isDirectory
	if (type == 4) {
		FTPRemoteTableController *remoteViewController = [[FTPRemoteTableController alloc] initWithUrlString:[urlString_ stringByAppendingPathComponent:name]];

		remoteViewController.localPath = localPath_;
		remoteViewController.localItems = localItems_;
		remoteViewController.localTableView = localTableView_;
		remoteViewController.localFile = localFile_;
		
		[self.navigationController pushViewController:remoteViewController animated:YES];
	}
	// isFile
	else if (type == 8) {
		file_ = name;
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

- (id)initWithUrlString:(NSString *)urlString {
	if (self = [super init]) {
		
		urlString_ = [urlString retain];
		self.title = [urlString lastPathComponent];	
		
		items_ = [[NSMutableArray array] retain];
		
		messageLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 48)];
		messageLabel_.backgroundColor = [UIColor grayColor];
		messageLabel_.textAlignment = UITextAlignmentCenter;
		messageLabel_.font = [UIFont systemFontOfSize:20];
		
		UIImage* fileImage = [UIImage imageNamed:@"file.png"];
		UIImage* dirImage = [UIImage imageNamed:@"dir.png"];
		images_ = [[NSMutableDictionary dictionary] retain];
		[images_ setObject:fileImage forKey:[NSNumber numberWithInteger:8]];
		[images_ setObject:dirImage forKey:[NSNumber numberWithInteger:4]];		
		
		UIBarButtonItem *getButton  = [[UIBarButtonItem alloc] initWithTitle:@"GET" style:UIBarButtonItemStyleBordered target:self action:@selector(getDidPush)];
		
		NSArray *items = [NSArray arrayWithObjects:getButton, nil];
		[self setToolbarItems:items];
		
		file_ = @"";
	}

	return self;
}


#pragma mark -
#pragma mark Split view support

- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc {
	
	/* popover使わないことにした
	barButtonItem.title = @"Local";
	self.navigationItem.rightBarButtonItem = barButtonItem;
	self.popoverController = pc;
	*/
}


// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController: (UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {

	/* popover使わないことにした
	self.navigationItem.rightBarButtonItem = nil;
	self.popoverController = nil;
	*/
}


- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode {

	switch (eventCode) {
			
		case NSStreamEventOpenCompleted:
//			[self updateMessage_:@"Connection Opened"];
			NSLog(@"open");
			break;
			
		case NSStreamEventHasBytesAvailable:{

			// 1行目に変数宣言が来るとエラーになるので括弧で囲む（他の文があればエラーにならない？）
			// [self updateMessage_:@"Data Receiving..."];
			NSLog(@"Receiving...");
			
			uint8_t buffer[32768];
			NSInteger bytesRead = [nwInputStream_ read:buffer maxLength:sizeof(buffer)];
			
			if (bytesRead < 0) {
				[self stopFTP_:@"Receive Error"];
			}
			else if (bytesRead == 0) {
				[self stopFTP_:nil];
				
				NSLog(@"Received!!");
				
				if (ftpMode_ == kEdhitaFTPModeGET) {
				
					if ([localItems_ containsObject:file_] != YES) {
						[localItems_ addObject:file_];
						[localTableView_ reloadData];
						[localTableView_ scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:localItems_.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
					}					
				}
			}
			else {
				
				switch (ftpMode_) {
					case kEdhitaFTPModeLIST:
						[listData_ appendBytes:buffer length:bytesRead];
						[self parseListData_];
						break;
					case kEdhitaFTPModeGET: {
						NSInteger   bytesWritten;
						NSInteger   bytesWrittenSoFar;
						
						bytesWrittenSoFar = 0;
						while (bytesWrittenSoFar != bytesRead) {
							bytesWritten = [fileOutputStream_ write:&buffer[bytesWrittenSoFar] maxLength:bytesRead - bytesWrittenSoFar];
							if (bytesWritten == -1) {
								[self stopFTP_:@"File write error"];
								break;
							} else {
								bytesWrittenSoFar += bytesWritten;
							}
						}
					} break;

					default:
						break;
				}
			}
		} break;

		// Sends a data for PUT
		case NSStreamEventHasSpaceAvailable: {

			NSLog(@"Sending...");

			if (bufferOffset_ == bufferLimit_) {
				NSInteger bytesRead = [fileInputStream_ read:buffer_ maxLength:kSendBufferSize];
				
				if (bytesRead == -1) {
					[self stopFTP_:@"File read error"];
				} else if (bytesRead == 0) {
					[self stopFTP_:nil];
						
					NSLog(@"Succeeded!");

					/* だめだ、itemsがDictionaryのArrayなの忘れてた。
					if ([items_ containsObject:localFile_] != YES) {
						[items_ addObject:localFile_];
						[self.tableView reloadData];
						[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:items_.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
					}
					*/
					[self listByFTP];
					
					NSLog(@"added!!!");
						
				} else {
					bufferOffset_ = 0;
					bufferLimit_ = bytesRead;
				}
			}
				
			if (bufferOffset_ != bufferLimit_) {
				NSInteger bytesWritten;
				bytesWritten = [nwOutputStream_ write:&buffer_[bufferOffset_] maxLength:bufferLimit_ - bufferOffset_];
				if (bytesWritten == -1) {
					[self stopFTP_:@"Network write error"];
				} else {
					bufferOffset_ += bytesWritten;
				}
			}
				
		} break;
			
		case NSStreamEventErrorOccurred:
			[self stopFTP_:@"Connection Error"];
			break;
		default:
			break;
	}

}

- (void)parseListData_ {

	NSMutableArray *newEntries = [NSMutableArray array];
    NSUInteger offset = 0;

	while(YES) {
		CFIndex bytesConsumed;
		CFDictionaryRef thisEntry;	
		
		thisEntry = NULL;
		bytesConsumed = CFFTPCreateParsedResourceListing(NULL, &((const uint8_t *) listData_.bytes)[offset], listData_.length - offset, &thisEntry);

		if (bytesConsumed > 0) {
            if (thisEntry != NULL) {
                NSDictionary *  entryToAdd;
                entryToAdd = [self entryByReencodingNameInEntry_:(NSDictionary *) thisEntry encoding:NSUTF8StringEncoding];                
                [newEntries addObject:entryToAdd]; 
			}
			offset += bytesConsumed;
		}
		
        if (thisEntry != NULL) {
            CFRelease(thisEntry);
        }

        if (bytesConsumed == 0) {
            break;
        } else if (bytesConsumed < 0) {
			[self stopFTP_:@"Parse Error"];
            break;
        }		
	}

	if (newEntries.count != 0) {
		NSLog(@"%@", [newEntries description]);
        [items_ addObjectsFromArray:newEntries];
		[self.tableView reloadData];
    }
    if (offset != 0) {
        [listData_ replaceBytesInRange:NSMakeRange(0, offset) withBytes:NULL length:0];
    }
	
}

- (NSDictionary *)entryByReencodingNameInEntry_:(NSDictionary *)entry encoding:(NSStringEncoding)newEncoding {

    NSDictionary *result;
    NSString *name;
    NSData *nameData;
    NSString *newName;
    
    newName = nil;
    
    name = [entry objectForKey:(id)kCFFTPResourceName];
    if (name != nil) {
        nameData = [name dataUsingEncoding:NSMacOSRomanStringEncoding];
        if (nameData != nil) {
            newName = [[[NSString alloc] initWithData:nameData encoding:newEncoding] autorelease];
        }
    }
    
    if (newName == nil) {
        result = (NSDictionary *)entry;
    } else {
        NSMutableDictionary *newEntry;
        
        newEntry = [[entry mutableCopy] autorelease];
        
        [newEntry setObject:newName forKey:(id)kCFFTPResourceName];
        
        result = newEntry;
    }
    
    return result;
}


- (void)stopFTP_:(NSString *)message {
	// LIST(& GET)
	if (nwInputStream_ != nil) {
		[nwInputStream_ removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
		nwInputStream_.delegate = nil;
		[nwInputStream_ close];
		nwInputStream_ = nil;
	}
	[self updateMessage_:message];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	listData_ = nil;

	// GET
    if (fileOutputStream_ != nil) {
        [fileOutputStream_ close];
        fileOutputStream_ = nil;
    }
	// PUT
	if (nwOutputStream_ != nil) {
        [nwOutputStream_ removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        nwOutputStream_.delegate = nil;
        [nwOutputStream_ close];
        nwOutputStream_ = nil;
    }
    if (fileInputStream_ != nil) {
        [fileInputStream_ close];
        fileInputStream_ = nil;
    }	
}

- (void)updateMessage_:(NSString *)message {
	if (message == nil) {
//		message = @"Suceeded";
		self.tableView.tableHeaderView = nil;
//		messageLabel_.textColor = [UIColor cyanColor];
//		self.tableView.tableHeaderView = messageLabel_;
	}
	else {
		NSLog(message);
		messageLabel_.textColor = [UIColor orangeColor];
		self.tableView.tableHeaderView = messageLabel_;
//		[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
	}
	messageLabel_.text = message;
}

- (void)getDidPush {
//	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"test" message:@"test" delegate:nil cancelButtonTitle:@"test" otherButtonTitles:nil];
//	[alert show];
	[self getByFTP];	
}

- (void)listByFTP {

	if (items_ != nil) {
		[items_ release];
		items_ = [[NSMutableArray array] retain];
	}
	
	ftpMode_ = kEdhitaFTPModeLIST;

	if (listData_) {
		[listData_ release];
	}
	listData_ = [[NSMutableData data] retain];
		
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"ftp://%@/", urlString_]];
	NSLog([url description]);
	CFReadStreamRef ftpStream = CFReadStreamCreateWithFTPURL(NULL, (CFURLRef) url);
	
	nwInputStream_ = (NSInputStream *)ftpStream;
	nwInputStream_.delegate = self;
	[nwInputStream_ scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	[nwInputStream_ open];
	//	[self updateMessage_:@"Connecting..."];
	[self updateMessage_:nil];
	
	CFRelease(ftpStream);	
}

- (void)getByFTP {

	ftpMode_ = kEdhitaFTPModeGET;
	
	NSString *remotePath = [NSString stringWithFormat:@"ftp://%@", [urlString_ stringByAppendingPathComponent:file_]];
	NSString *localPath = [localPath_ stringByAppendingPathComponent:file_];
	
	fileOutputStream_ = [[NSOutputStream outputStreamToFileAtPath:localPath append:NO] retain];
	[fileOutputStream_ open];	
	
	CFReadStreamRef ftpStream = CFReadStreamCreateWithFTPURL(NULL, (CFURLRef)[NSURL URLWithString:remotePath]);
	
	nwInputStream_ = (NSInputStream *)ftpStream;
	nwInputStream_.delegate = self;
	[nwInputStream_ scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];

	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	[nwInputStream_ open];

	[self updateMessage_:nil];

	CFRelease(ftpStream);
}

- (void)putByFtp {
	
	ftpMode_ = kEdhitaFTPModePUT;
	
	// Direcotry選んでる時はそこにUploadしたほうがいいか？
	NSString *remotePath = [NSString stringWithFormat:@"ftp://%@", [urlString_ stringByAppendingPathComponent:localFile_]];
	NSString *localPath = [localPath_ stringByAppendingPathComponent:localFile_];
	
	NSLog(localPath);
	fileInputStream_ = [[NSInputStream inputStreamWithFileAtPath:localPath] retain];
	[fileInputStream_ open];	
	
	CFWriteStreamRef ftpStream = CFWriteStreamCreateWithFTPURL(NULL, (CFURLRef)[NSURL URLWithString:remotePath]);
	
	nwOutputStream_ = (NSOutputStream *)ftpStream;
	nwOutputStream_.delegate = self;
	[nwOutputStream_ scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[nwOutputStream_ open];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	[self updateMessage_:nil];
	
	CFRelease(ftpStream);
}


@end

