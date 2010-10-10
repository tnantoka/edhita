//
//  EdhitaTableViewController.h
//  Edhita
//
//  Created by t on 10/08/21.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdMobDelegateProtocol.h"
#import "AdMobView.h"
#import "EdhitaPrivateCommon.h"
#import "DetailViewController.h"

@interface EdhitaFileViewController : UITableViewController <UITextFieldDelegate, AdMobDelegate> {
	NSArray *items_;
	NSString *path_;
	UITextField *textField_;
	DetailViewController *detailViewController;
}

@property (nonatomic, retain) DetailViewController *detailViewController;

- (id)initWithPath:(NSString *)path;

- (void)textFieldDidEndEditing:(UITextField *)textField;
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
	
- (void)renameFile;

- (CGSize)contentSizeForViewInPopover;

@end
