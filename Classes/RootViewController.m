//
//  RootViewController.m
//  Test
//
//  Created by t on 10/08/15.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "RootViewController.h"

#import "GADBannerView.h"

@implementation RootViewController {
    GADBannerView *bannerView_;
}

@synthesize detailViewController;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

	NSError *error;
	[items_ release];
	items_ = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:path_ error:&error] mutableCopy];
	[self.tableView reloadData];
    
    [self.navigationController setToolbarHidden:NO animated:YES];
}

// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [items_ count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    
    // Dequeue or create a cell of the appropriate type.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    
    // Configure the cell.
	NSString *text = [items_ objectAtIndex:indexPath.row];
	cell.textLabel.text = text;
	BOOL isDir;
	NSString *path = [path_ stringByAppendingPathComponent:text];
	[[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir];
	cell.imageView.image = [images_ objectAtIndex:isDir];
	
	return cell;


}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
	// Cellが削除された時、ファイルとitemsからも削除する
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		
		detailViewController.path = [[NSBundle mainBundle] pathForResource:@"delete" ofType:@"txt"];

		NSString *path = [path_ stringByAppendingPathComponent:[items_ objectAtIndex:indexPath.row]];
		NSError* error;
		
		[[NSFileManager defaultManager] removeItemAtPath:path error:&error];
		
		// 配列からも消さないと落ちる
		[items_ removeObjectAtIndex:indexPath.row];
		
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];		
    }
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /*
     When a row is selected, set the detail view controller's detail item to the item associated with the selected row.
     */
	NSString *path = [path_ stringByAppendingPathComponent:[items_ objectAtIndex:indexPath.row]];

	BOOL isDir;

	[[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir];

	// ディレクトリだった場合、そのPathを設定したRootViewControllerを作成
	if (isDir) {		
		RootViewController *rootViewController = [[RootViewController alloc] initWithPath:path];
		// detailはrootがもつ必要ないんじゃ？（navあたりに持たせればいい）
		rootViewController.detailViewController = self.detailViewController;
		[self.navigationController pushViewController:rootViewController animated:YES];
		detailViewController.path = [[NSBundle mainBundle] pathForResource:@"direcotry" ofType:@"txt"];
	}
	// ファイルだった場合はDetailに内容を表示
	// popoverは非表示に
	else {
		detailViewController.path = path;
		if (detailViewController.popoverController && detailViewController.popoverController.popoverVisible) {
			[detailViewController.popoverController dismissPopoverAnimated:YES];
		}
	}
	
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [detailViewController release];
	[items_ release];
	[images_ release];
	[path_ release];
    [bannerView_ release];
    [super dealloc];
}

- (id)initWithPath:(NSString *)path {
	if (self = [super init]) {
		// 与えられたパスの一覧を配列にする
		path_ = [path retain];
		self.title = [path lastPathComponent];

		NSError *error;

		// retainしないとpopoverで開く時に落ちる
		// mutableCopyするとオーナーになるのでretain不要
		items_ = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:&error] mutableCopy];

		// 画像ボタンを2個作って、それぞれファイル・ディレクトリの作成用のボタンとする
		UIImage* fileImage = [UIImage imageNamed:@"file.png"];
		UIImage* dirImage = [UIImage imageNamed:@"dir.png"];
		images_ = [[NSArray arrayWithObjects:fileImage, dirImage, nil] retain];

		// 右寄せ
		UIBarButtonItem *space = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];

		// 画像＆文字ボタン
        UIBarButtonItem *newFile  = [[UIBarButtonItem alloc] initWithTitle:@"File＋" style:UIBarButtonItemStyleBordered target:self action:@selector(newFileDidPush)];
		UIBarButtonItem *newDir  = [[UIBarButtonItem alloc] initWithTitle:@"Dir＋" style:UIBarButtonItemStyleBordered target:self action:@selector(newDirDidPush)];

		// HTTP 
		//UIBarButtonItem *downloadButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"download.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(downloadDidPush)];
		UIBarButtonItem *downloadButton = [[UIBarButtonItem alloc] initWithTitle:@"DL" style:UIBarButtonItemStyleBordered target:self action:@selector(downloadDidPush)];
				
		NSArray *items = [NSArray arrayWithObjects:downloadButton/*, ftpButton*/, space, newFile, newDir, nil];
		[self setToolbarItems:items];

		// 編集ボタンの表示（selfのeditButtonを設定してやるだけでいい）
		self.navigationItem.rightBarButtonItem = [self editButtonItem];
		
		
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
		
		// download
		downloadView_ = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
		downloadView_.backgroundColor = [UIColor grayColor];
		downloadView_.opaque = NO;
		
		urlField_ = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 245, 30)];
		urlField_.borderStyle = UITextBorderStyleRoundedRect;
		urlField_.placeholder = @"url";
		urlField_.text = @"http://";
		urlField_.keyboardType = UIKeyboardTypeURL;
		urlField_.clearButtonMode = UITextFieldViewModeWhileEditing;
        urlField_.autocorrectionType = UITextAutocorrectionTypeNo;
        urlField_.autocapitalizationType = UITextAutocapitalizationTypeNone;
		
		UIButton *dlButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[dlButton setTitle:@"DL" forState:UIControlStateNormal];
		[dlButton sizeToFit];
		dlButton.frame = CGRectMake(265, 10, 45, 30);
		[dlButton addTarget:self action:@selector(dlDidPush) forControlEvents:UIControlEventTouchUpInside];
		
		messageLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 300, 20) ];
		messageLabel_.backgroundColor = [UIColor clearColor];
		messageLabel_.textAlignment = UITextAlignmentCenter;
		
		[downloadView_ addSubview:urlField_];
		[downloadView_ addSubview:dlButton];
		[downloadView_ addSubview:messageLabel_];

	}
	return self;
}

// 新しいファイルの作成
- (void)newFileDidPush {
	
	NSError *error;

	// 連番のファイル名を取得
	NSString *fileName = [self nextFileName:@"untitled" withExtension:@"txt"];
	NSString *fileContents = @"";

	NSString *filePath = [path_ stringByAppendingPathComponent:fileName];
	[fileContents writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];

	[items_ addObject:fileName];
	[self.tableView reloadData];
}

// 新しいディレクトリの作成
- (void)newDirDidPush {

	NSError *error;
	
	// 連番のディレクトリ名を取得
	NSString *dirName = [self nextFileName:@"untitled" withExtension:@"d"];

	NSString *dirPath = [path_ stringByAppendingPathComponent:dirName];
	[[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:NO attributes:nil error:&error];
	
	[items_ addObject:dirName];
	[self.tableView reloadData];
}

- (NSString *)nextFileName:fileName withExtension:(NSString *)extenstion {
	// ちゃんとNSNotFoundと比較しないとうまくうごかん（!とかBOOLでやっちゃダメ）
	if ([items_ indexOfObject:[fileName stringByAppendingFormat:@".%@", extenstion]] != NSNotFound) {
		
		int i = 2;		
		NSString *newFileName;
		
		while (i < 1024) {
			newFileName = [fileName stringByAppendingFormat:@"(%d).%@", i, extenstion];
			if([items_ indexOfObject:newFileName] == NSNotFound) {
				return newFileName;
			}
			i++;
		}
	}
	return [fileName stringByAppendingFormat:@".%@", extenstion];
}

// アクセサリボタンがタップされた時はファイル情報表示画面に遷移する
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {

	NSString *path = [path_ stringByAppendingPathComponent: [items_ objectAtIndex:indexPath.row]];
	EdhitaFileViewController *tableViewController = [[EdhitaFileViewController alloc] initWithPath:path];
	tableViewController.detailViewController = self.detailViewController;
	[self.navigationController pushViewController:tableViewController animated:YES];
	[tableViewController release];	
}

// 勝手にサイズが変わらないようにkeyboad（日本語）表示状態のheightで固定
- (CGSize)contentSizeForViewInPopover {
	return CGSizeMake(320, 527);
}

- (void)downloadDidPush {

	if (self.tableView.tableHeaderView == nil) {
		self.tableView.tableHeaderView = downloadView_;
//		[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
	} else {
		self.tableView.tableHeaderView = nil;
		downloadView_.frame = CGRectMake(0, 0, 320, 50);
		messageLabel_.text = @"";
		self.tableView.tableHeaderView = downloadView_;
//		[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
	}
	
}

- (void)dlDidPush {
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

	self.tableView.tableHeaderView = nil;
	downloadView_.frame = CGRectMake(0, 0, 320, 80);
	self.tableView.tableHeaderView = downloadView_;
	
	NSURL *url = [NSURL URLWithString:[self encodeURI:urlField_.text]];
	NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30.0];
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];

	if (connection) {
//		NSLog(@"connected.");
	} else {
		messageLabel_.textColor = [UIColor orangeColor];	
		messageLabel_.text = @"Can't Connect";		
	}
}

// Start Download
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	downloadBuffer_ = [[NSMutableData data] retain];
}

// Progress
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[downloadBuffer_ appendData: data];
}

// Finish
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

	NSString *name = [urlField_.text lastPathComponent];
	BOOL success = [downloadBuffer_ writeToFile:[path_ stringByAppendingPathComponent:name] atomically:YES];

	if (success) {
		if ([items_ containsObject:name] != YES) {
			[items_ addObject:name];
			[self.tableView reloadData];
//			[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:items_.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];

			messageLabel_.textColor = [UIColor cyanColor];	
			messageLabel_.text = [NSString stringWithFormat:@"Saved as \"%@\"", name];
		} else {
			messageLabel_.textColor = [UIColor cyanColor];	
			messageLabel_.text = [NSString stringWithFormat:@"\"%@\" is overwritten", name];
		}
	}
	else {
		messageLabel_.textColor = [UIColor orangeColor];	
		messageLabel_.text = @"Donwload Error";		
	}
}

// error
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [connection release];
    [downloadBuffer_ release];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	messageLabel_.textColor = [UIColor orangeColor];	
	messageLabel_.text = [error localizedDescription];		
}

- (NSString *)encodeURI:(NSString *)string {
	NSString *escaped = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)string, NULL, NULL, kCFStringEncodingUTF8);
    [escaped autorelease];
	return escaped;
}

@end

