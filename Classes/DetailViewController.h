//
//  DetailViewController.h
//  Test
//
//  Created by t on 10/08/15.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EdhitaAccessoryView.h"
#import <MessageUI/MessageUI.h>

@interface DetailViewController : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate, UIWebViewDelegate, MFMailComposeViewControllerDelegate> {
    
    UIPopoverController *popoverController;
    UIToolbar *toolbar;
    
    id detailItem;
    UILabel *detailDescriptionLabel;
	
	UITextView *textView_;
	BOOL isKeyboardShown;
	
	NSString *path_;
	UILabel *pathLabel_;
	
	UIWebView *webView_;
	BOOL webViewReloaded;
	
	UISegmentedControl *segment_;	
	
	EdhitaAccessoryView *accessoryView_;
}

//@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) UIToolbar *toolbar;

@property (nonatomic, retain) id detailItem;
//@property (nonatomic, retain) IBOutlet UILabel *detailDescriptionLabel;
@property (nonatomic, retain) UILabel *detailDescriptionLabel;

@property (nonatomic, retain) NSString *path;

@property (nonatomic, retain) UIPopoverController *popoverController;

- (void)keyboardWasShown:(NSNotification *)aNotification;
- (void)keyboardWasHidden:(NSNotification *)aNotification;
- (void)enableButton_;
- (void)disableButton_;

- (void)saveContents;
- (UIColor *)getColorWithIndex:(NSInteger)index;

- (void)undoDidPush;
- (void)redoDidPush;

- (void)leftDidPush;
- (void)rightDidPush;

//- (void)escapeDidPush;

- (void)segmentDidPush:(UISegmentedControl *)sender;
- (void)changeUrl;
//- (void)safariDidPush;

- (void)webViewDidFinishLoad:(UIWebView *)webView;
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;

- (void)mailDidPush;

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error;

@end
