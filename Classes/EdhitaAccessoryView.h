//
//  EdhitaAccessoryView.h
//  Edhita
//
//  Created by t on 10/08/29.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EdhitaAccessoryView : UIScrollView {
	UITextView *textView_;
}

- (id)initWithTextView:(UITextView *)textView;

- (void)insertDidPush:(UIButton *)button;
- (void)tabDidPush;
- (void)insertString:(NSString *)string;
- (void)backSpace:(NSString *)string;

//TODO
//- (void)escapeDidPush;
//- (void)unescapeDidPush;

@end
