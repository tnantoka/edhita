//
//  EdhitaTableViewController.h
//  Edhita
//
//  Created by t on 10/08/21.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EdhitaTableViewController : UITableViewController <UITextFieldDelegate> {
	NSArray *items_;
	NSString *path_;
	UITextField *textField_;
}

- (id)initWithPath:(NSString *)path;

- (void)textFieldDidEndEditing:(UITextField *)textField;
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
	
- (void)renameFile;

- (CGSize)contentSizeForViewInPopover;

@end
