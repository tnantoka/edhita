//
//  DetailViewController.m
//  Test
//
//  Created by t on 10/08/15.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
//プライベートメソッドの解除（AdMobから使うので）
//@property (nonatomic, retain) UIPopoverController *popoverController;
- (void)configureView;
@end


@implementation DetailViewController

@synthesize toolbar, popoverController, detailItem, detailDescriptionLabel, path = path_;

#pragma mark -
#pragma mark Managing the detail item

/*
 When setting the detail item, update the view and dismiss the popover controller if it's showing.
 */
- (void)setDetailItem:(id)newDetailItem {
    if (detailItem != newDetailItem) {
        [detailItem release];
        detailItem = [newDetailItem retain];
        
        // Update the view.
        [self configureView];
    }

//    if (popoverController != nil) {
//        [popoverController dismissPopoverAnimated:YES];
//    }        
}


- (void)configureView {
    // Update the user interface for the detail item.
//    detailDescriptionLabel.text = [detailItem description];   
}


#pragma mark -
#pragma mark Split view support

- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc {

    barButtonItem.title = @"Documents";
    NSMutableArray *items = [[toolbar items] mutableCopy];
    [items insertObject:barButtonItem atIndex:0];
    [toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = pc;
}


// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController: (UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    
    NSMutableArray *items = [[toolbar items] mutableCopy];
    [items removeObjectAtIndex:0];
    [toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = nil;
}


#pragma mark -
#pragma mark Rotation support

// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


#pragma mark -
#pragma mark View lifecycle

/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
 */

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	[self disableButton_];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/

- (void)viewWillDisappear:(BOOL)animated {
	// FTPから復帰したときにもPopoverが追加されちゃうので消しとく
	if (self.popoverController != nil) {
		NSMutableArray *items = [[toolbar items] mutableCopy];
		[items removeObjectAtIndex:0];
		[toolbar setItems:items animated:YES];
		[items release];
	}

	[self saveContents];
    [super viewWillDisappear:animated];
}

/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/

- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.popoverController = nil;
}


#pragma mark -
#pragma mark Memory management

/*
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
*/

- (void)dealloc {
    [popoverController release];
    [toolbar release];
    
    [detailItem release];
    [detailDescriptionLabel release];
    [super dealloc];
}

- (id)init {
	if (self = [super init]) {
		self.view.backgroundColor = [UIColor whiteColor];
		
		toolbar = [[UIToolbar alloc] init];
//		toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
		[toolbar sizeToFit];		
		[self.view addSubview:toolbar];
		// これやっとかないとpopview出すボタンが追加できない（[toolbar items]がnullになるから）
//		[toolbar setItems:[NSArray array]];
		
		// heightはdefaultのfontsizeに合わせて17
//		detailDescriptionLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, self.view.bounds.size.height * 0.5, self.view.bounds.size.width, 17)];
		// 常に上下中央
//		detailDescriptionLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
//		detailDescriptionLabel.textAlignment = UITextAlignmentCenter;

//		detailDescriptionLabel.text = @"Detail view content goes here";
//		[self.view addSubview:detailDescriptionLabel];		
		
		textView_ = [[UITextView alloc] initWithFrame:CGRectMake(0, toolbar.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height - toolbar.bounds.size.height)];
		// サイズの微調整とかはautoresize設定してからじゃないと意味無い。width,heightがportrait基準になっちゃうから？
		textView_.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//		textView_.backgroundColor = [UIColor lightGrayColor];
		textView_.text = @"";
		[self.view addSubview:textView_];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
		
//		textView_.font = [UIFont fontWithName:@"AmericanTypewriter" size:20];
		

		
		/* font一覧
		NSMutableArray *result = [NSMutableArray array];
		NSArray *families = [UIFont familyNames];
		
		for (NSString *family in families) {
			NSArray *names = [UIFont fontNamesForFamilyName: family];
			[result addObjectsFromArray:names];
		}
		[result sortUsingSelector:@selector(compare:)];
		NSLog([result description]);
		*/
		
		NSUserDefaults* settings = [NSUserDefaults standardUserDefaults];

		// defaultを設定してもnullが返ってくるので、0やNOがdefaultじゃない場合処理が必要。
		NSInteger textColor = [settings integerForKey:@"textColor"];
		NSInteger backgroundColor = [settings objectForKey: @"backgroundColor"] != NULL ? [settings integerForKey:@"backgroundColor"] : 3;
		NSString *fontName = [settings objectForKey: @"fontName"] != NULL ? [settings stringForKey:@"fontName"] : @"Helvetica";
		NSInteger fontSize = [settings objectForKey: @"fontSize"] != NULL ? [settings integerForKey:@"fontSize"] : 16;
				
		textView_.font = [UIFont fontWithName:fontName size:fontSize];
		textView_.textColor = [self getColorWithIndex:textColor];
		textView_.backgroundColor = [self getColorWithIndex:backgroundColor];
		
		// targetとactionをnilにしたら勝手にundo,redoしてくれるっぽいけど保証されるかわからんのでやめとく
		UIBarButtonItem *undoButton_ = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemUndo target:self action:@selector(undoDidPush)];
		UIBarButtonItem *redoButton_ = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRedo target:self action:@selector(redoDidPush)];

		UIBarButtonItem *fixed = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
		fixed.width = 25;
		UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
		
		UIBarButtonItem *leftButton_  = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrow_left.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(leftDidPush)];
		UIBarButtonItem *rightButton_  = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrow_right.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(rightDidPush)];

//		UIBarButtonItem *escapeButton  = [[UIBarButtonItem alloc] initWithTitle:@"&amp;" style:UIBarButtonItemStyleBordered target:self action:@selector(escapeDidPush)];

		segment_ = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Source", @"Browser", nil]];
		segment_.segmentedControlStyle = UISegmentedControlStyleBar;
		segment_.selectedSegmentIndex = 1;
//		segment.frame = CGRectMake(0, 0, 130, 30);
		[segment_ addTarget:self action:@selector(segmentDidPush:) forControlEvents:UIControlEventValueChanged];
		UIBarButtonItem *segmentButton = [[UIBarButtonItem alloc] initWithCustomView:segment_];
		
//		UIBarButtonItem *safariButton  = [[UIBarButtonItem alloc] initWithTitle:@"Safari" style:UIBarButtonItemStyleBordered target:self action:@selector(safariDidPush)];
		UIBarButtonItem *mailButton  = [[UIBarButtonItem alloc] initWithTitle:@"Mail" style:UIBarButtonItemStyleBordered target:self action:@selector(mailDidPush)];

		NSArray *items = [NSArray arrayWithObjects:flexible, undoButton_, redoButton_, fixed, leftButton_, rightButton_, flexible, segmentButton, fixed, mailButton, nil];
		[toolbar setItems:items];
		
		if ([settings objectForKey:@"accessoryView"] == NULL || [settings boolForKey:@"accessoryView"]) {
			accessoryView_ = [[EdhitaAccessoryView alloc] initWithTextView:textView_];
			textView_.inputAccessoryView = accessoryView_;
		}
		
		// ファイル名表示用ラベル
//		pathLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 10, self.view.frame.size.height - 40, self.view.frame.size.width / 2 - 10, 20)];
		pathLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height - 40, self.view.frame.size.width - 40, 20)];
		pathLabel_.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
		pathLabel_.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
		pathLabel_.textAlignment = UITextAlignmentRight;
		pathLabel_.lineBreakMode = UILineBreakModeMiddleTruncation;

//		pathLabel_.textColor = [UIColor whiteColor];
//		pathLabel_.text = @"test";
		[self.view addSubview:pathLabel_];

		// WebView for Preview
		webView_ = [[UIWebView alloc] initWithFrame:CGRectMake(textView_.frame.origin.x, textView_.frame.origin.y, textView_.frame.size.width, textView_.frame.size.height)];
		webView_.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		webView_.delegate = self;
		[self.view addSubview:webView_];
		webView_.hidden = YES;
		
//		textView_.text = @"Hello, Edhita!\n\n(c) 2010 bornneet.com";
		webView_.hidden = NO;

//		UIView *splash = [[UIView alloc] initWithFrame:self.view.bounds];
//		splash.backgroundColor = [UIColor grayColor];
//		[self.view addSubview:splash];

		NSString *welcome = [[NSBundle mainBundle] pathForResource:@"welcome" ofType:@"html"];
		self.path = welcome;
		segment_.selectedSegmentIndex = 1;
		webView_.hidden = NO;
	}
	return self;
}

- (void)keyboardWasShown:(NSNotification *)aNotification {

	if (!isKeyboardShown) {

		CGRect frameEnd = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
		frameEnd = [self.view convertRect:frameEnd fromView:nil];
		
		CGRect textFrame = textView_.frame;
		textFrame.size.height -= frameEnd.size.height;
		textView_.frame = textFrame;
		
		isKeyboardShown = YES;
	}
	else {
			
		CGRect frameBegin = [[[aNotification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
		CGRect frameEnd = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
		frameBegin = [self.view convertRect:frameBegin fromView:nil];
		frameEnd = [self.view convertRect:frameEnd fromView:nil];

		CGFloat heightDiff = (frameEnd.size.height - frameBegin.size.height);

		if (heightDiff != 0) {
			CGRect textFrame = textView_.frame;
			textFrame.size.height -= heightDiff;

		}		
	}
	
	[self enableButton_];
}

- (void)keyboardWasHidden:(NSNotification *)aNotification {
	CGRect frameEnd = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	frameEnd = [self.view convertRect:frameEnd fromView:nil];
	
	CGRect textFrame = textView_.frame;
	textFrame.size.height += frameEnd.size.height;
	textView_.frame = textFrame;
	
	isKeyboardShown = NO;
	[self disableButton_];
}

- (void)enableButton_ {
    NSArray *items = [toolbar items];
	((UIBarButtonItem *)[items objectAtIndex:1]).enabled = YES;
	((UIBarButtonItem *)[items objectAtIndex:2]).enabled = YES;
	((UIBarButtonItem *)[items objectAtIndex:3]).enabled = YES;
	((UIBarButtonItem *)[items objectAtIndex:4]).enabled = YES;
	((UIBarButtonItem *)[items objectAtIndex:5]).enabled = YES;
	((UIBarButtonItem *)[items objectAtIndex:6]).enabled = YES;
} 

- (void)disableButton_ {
    NSArray *items = [toolbar items];
	((UIBarButtonItem *)[items objectAtIndex:1]).enabled = NO;
	((UIBarButtonItem *)[items objectAtIndex:2]).enabled = NO;
	((UIBarButtonItem *)[items objectAtIndex:3]).enabled = NO;
	((UIBarButtonItem *)[items objectAtIndex:4]).enabled = NO;
	((UIBarButtonItem *)[items objectAtIndex:5]).enabled = NO;
	((UIBarButtonItem *)[items objectAtIndex:6]).enabled = NO;
}


// pathプロパティが変化した時にTextViewの内容を変更する
- (void)setPath:(NSString *)path {
	
	[self saveContents];

	path_ = [path retain];
	NSError *error;
	textView_.text = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
	
	NSString *homeDir = NSHomeDirectory();
//	NSString *docDir = [homeDir stringByAppendingPathComponent:@"Documents"];
	NSArray *components = [path componentsSeparatedByString:homeDir];
	pathLabel_.text = [components objectAtIndex:1];

	/*
	if (segment_.selectedSegmentIndex == 1) {
		[self changeUrl];		
	}
	*/
	
	segment_.selectedSegmentIndex = 0;
	webView_.hidden = YES;
}

- (void)saveContents {
	
	NSError *error;
	[textView_.text writeToFile:path_ atomically:YES encoding:NSUTF8StringEncoding error:&error];

}

- (UIColor *)getColorWithIndex:(NSInteger)index {
	
	switch (index) {
		case 0:
			return [UIColor blackColor];
			break;
		case 1:
			return [UIColor darkGrayColor];
			break;
		case 2:
			return [UIColor lightGrayColor];
			break;
		case 3:
			return [UIColor whiteColor];
			break;
		case 4:
			return [UIColor grayColor];
			break;
		case 5:
			return [UIColor redColor];
			break;
		case 6:
			return [UIColor greenColor];
			break;
		case 7:
			return [UIColor blueColor];
			break;
		case 8:
			return [UIColor cyanColor];
			break;
		case 9:
			return [UIColor yellowColor];
			break;
		case 10:
			return [UIColor magentaColor];
			break;
		case 11:
			return [UIColor orangeColor];
			break;
		case 12:
			return [UIColor purpleColor];
			break;
		case 13:
			return [UIColor brownColor];
			break;
		default:
			return [UIColor blackColor];
			break;
	}
}

- (void)undoDidPush {
	[[textView_ undoManager] undo];
}

- (void)redoDidPush {
	[[textView_ undoManager] redo];	
}

- (void)leftDidPush {
	NSRange range = textView_.selectedRange;
	textView_.selectedRange = NSMakeRange(range.location - 1, range.length);
	[[textView_ undoManager] registerUndoWithTarget:self selector:@selector(rightDidPush) object:nil];
}

- (void)rightDidPush {
	NSRange range = textView_.selectedRange;
	textView_.selectedRange = NSMakeRange(range.location + 1, range.length);
	[[textView_ undoManager] registerUndoWithTarget:self selector:@selector(leftDidPush) object:nil];
}

//- (void)escapeDidPush {

	/*
	 
	&gt;,&lt;が内部で<>に戻されちゃってる・・・ 
	 
	 
	NSMutableString *text = [textView_.text mutableCopy];
	
	[text replaceOccurrencesOfString:@"&" withString:@"&amp;" options:NSLiteralSearch range:NSMakeRange(0, [text length])];
	[text replaceOccurrencesOfString:@"<" withString:@"&lt;" options:NSLiteralSearch range:NSMakeRange(0, [text length])];
	[text replaceOccurrencesOfString:@">" withString:@"&gt;" options:NSLiteralSearch range:NSMakeRange(0, [text length])];
	
	NSLog(@"%d", textView_.dataDetectorTypes);
	textView_.dataDetectorTypes = UIDataDetectorTypeNone;
	NSLog(@"%d", textView_.dataDetectorTypes);
	
	
	NSLog(@"before: %@", textView_.text);
	NSLog(@"before text: %@", text);	
	NSString *test = [NSString stringWithFormat:@"%@ %@", @"%26lt%3B", @"\&&amp;\gt\;"];
	textView_.text = test;
	NSLog(test);
	NSLog(@"after: %@", textView_.text);
	NSLog(@"after text: %@", text);

	[[textView_ undoManager] registerUndoWithTarget:self selector:@selector(rightDidPush) object:nil];
*/
/*
	NSMutableString *text = [textView_.text mutableCopy];
	NSRange range = textView_.selectedRange;
	NSMutableString *selectedString = [[text substringWithRange:range] mutableCopy];
	
	[selectedString replaceOccurrencesOfString:@"&" withString:@"&amp;" options:NSLiteralSearch range:NSMakeRange(0, [text length])];
	[selectedString replaceOccurrencesOfString:@"<" withString:@"&lt;" options:NSLiteralSearch range:NSMakeRange(0, [text length])];
	[selectedString replaceOccurrencesOfString:@">" withString:@"&gt;" options:NSLiteralSearch range:NSMakeRange(0, [text length])];
	
	NSLog(@"before: %@", textView_.text);
	NSLog(@"before text: %@", text);
	[text replaceCharactersInRange:range withString:selectedString];
	textView_.text = text;
	NSLog(@"after: %@", textView_.text);
	NSLog(@"after text: %@", text);
*/
	
/*
 表示されるけどtextView_.textに反映されない
 
	NSRange range = textView_.selectedRange;
	NSLog(@"0: %d, %d : %d", range.location, range.length, [textView_.text length]);
	NSMutableString *text = [[textView_.text substringWithRange:range] mutableCopy];
	NSLog(@"1: %@", text);

	[text replaceOccurrencesOfString:@"&" withString:@"&amp;" options:NSLiteralSearch range:NSMakeRange(0, [text length])];
	[text replaceOccurrencesOfString:@"<" withString:@"&lt;" options:NSLiteralSearch range:NSMakeRange(0, [text length])];
	[text replaceOccurrencesOfString:@">" withString:@"&gt;" options:NSLiteralSearch range:NSMakeRange(0, [text length])];
	NSLog(@"2: %@", text);
	
	NSMutableString *text2 = [textView_.text mutableCopy];
	[text2 replaceCharactersInRange:range withString:text];	
	textView_.text = text2;
	NSLog(@"3: %@", text2);
	NSLog(textView_.text);
	NSLog(@"%d, %d", [textView_.text length], [text2 length]);
	
	textView_.selectedRange = NSMakeRange([textView_.text length], 0);
*/
/*	 
	text = [text stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
	text = [text stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
	text = [text stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];

	NSMutableString *mutable = [textView_.text mutableCopy];
	[mutable replaceCharactersInRange:range withString:text];	
	textView_.text = mutable;
*/
//}

- (void)segmentDidPush:(UISegmentedControl *)sender {
	
	if (0 == sender.selectedSegmentIndex) {
		
//		[UIView beginAnimations:nil context:NULL];
//		[UIView setAnimationDuration:0.5];
//		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];

		webView_.hidden = YES;

//		[UIView commitAnimations];

	}
	else if (1 == sender.selectedSegmentIndex) {
		
//		[UIView beginAnimations:nil context:NULL];
//		[UIView setAnimationDuration:0.5];
//		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];

		// 実行する前に保存
		[self saveContents];
		[self changeUrl];
		
		webView_.hidden = NO;
		
//		[UIView commitAnimations];
	}
	
}

- (void)changeUrl {

	webViewReloaded = NO;
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	// <meta charset="UTF-8" />しないと文字化けする
	NSURL *url = [NSURL fileURLWithPath:path_];
	NSURLRequest *req = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30.0];
	[webView_ loadRequest:req];

}

// MobileSafariでローカルファイルは開けない！
// iphoneでは開ける謎。
/*
- (void)safariDidPush {

	NSURL *url = [NSURL fileURLWithPath:path_];
	[[UIApplication sharedApplication] openURL:url];
	NSLog(@"test"); 
}
*/

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	
	// cachePolicy指定してもJSやCSSをキャッシュしちゃうっぽいので、強制reload
	// ちゃんとキャッシュしないようになってるっぽいので、とりあえずコメントアウト
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
/*
	if (!webViewReloaded) {
		webViewReloaded = YES;
//		[webView_ reload];
	}
	else {
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	}
*/
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;	
}

- (void)mailDidPush {
	
	if ([MFMailComposeViewController canSendMail]) {
		MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];

		// delegateじゃなくmailComposeDelegate
		// delegateにするとUINavigationViewControllerDelegateを実装してないって怒られる
		mailViewController.mailComposeDelegate = self;

		NSData *data = [NSData dataWithContentsOfFile:path_];
		[mailViewController setSubject:[path_ lastPathComponent]];
		[mailViewController setMessageBody:textView_.text isHTML:NO];
		// とりあえず全部plain textとして扱っちゃう
		[mailViewController addAttachmentData:data mimeType:@"text/plain" fileName:[path_ lastPathComponent]];
		
		[self presentModalViewController:mailViewController animated:YES];
	}
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[controller dismissModalViewControllerAnimated:YES];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
										 duration:(NSTimeInterval)duration {
	[super willAnimateRotationToInterfaceOrientation:interfaceOrientation
											duration:duration];
	if (interfaceOrientation == UIInterfaceOrientationPortrait ||
		interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
		accessoryView_.contentSize = CGSizeMake(768 * 2, 0);
	}
	else {
		accessoryView_.contentSize = CGSizeMake(1024 * 2, 0);
	}
}

@end
