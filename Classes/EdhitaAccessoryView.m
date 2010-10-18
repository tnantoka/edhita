//
//  EdhitaAccessoryView.m
//  Edhita
//
//  Created by t on 10/08/29.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EdhitaAccessoryView.h"


@implementation EdhitaAccessoryView


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    [super dealloc];
}

- (id)initWithTextView:(UITextView *)textView {
	if (self = [super init]) {
		
		textView_ = textView;

		NSArray *titles = [NSArray arrayWithObjects:
// あんまりボタンを表示すると小さくせざるをえないので、使用頻度が高そうで入力しづらいやつを
//							@"{", @"}" ,@"<", @">", @"[", @"]", @"+", @"*", @"%", @"=", @"~", @"^", @"_", @"#", @"|", @"¥", @"\\", nil];		
//							@"{", @"}" ,@"<", @">", @"[", @"]", @"+", @"*", @"=", @"_", @"#", @"|", @"\\", nil];		
		
						   
							// 一番入力しづらい（17）
//							@"[", @"]", @"{", @"}", @"#", @"%", @"^", @"*", @"+", @"=", 
//							@"_", @"\\", @"|", @"~", @"<", @">", @"¥",
							// タブ（1）
//							@"\t", 
							// わりと入力しやすい（11）
//						    @"-", @"/", @":", @";", @"(", @")", @"$", @"&", @"@", @"'", @"\"", 
						    // 1ページ目にあるのでいらん（4）
//							@",", @".", @"!", @"?", 

						   
						   // ¥をボツにしてこれぐらいか
						   @"-", @"/", @":", @";", @"(", @")", @"$", @"&", @"@", @"'", @"\"", @"<", @">",
						   @"\\t", 
						   @"[", @"]", @"{", @"}", @"#", @"%", @"^", @"*", @"+", @"=", @"_", @"\\", @"|", @"~",  
							nil];
		
		
		NSInteger padding = 8;
		NSInteger margin = 8;
		NSInteger size = 46;
		
		self.frame = CGRectMake(0, 0, 768, size + padding * 2);
		self.backgroundColor = [UIColor lightGrayColor];
		// 横スクロール
		self.contentSize = CGSizeMake(768 * 2, 0);

		NSInteger i = 0;
		for (NSString *title in titles) {

			UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
			button.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;

			if (i < 14) {
				button.frame = CGRectMake((size + margin) * i + padding, padding, size, size);
			}
			else {
				button.frame = CGRectMake((size + margin) * i + padding + padding + padding, padding, size, size);
			}
			
			
			button.titleLabel.font = [UIFont systemFontOfSize: 20];
			[button setTitle:title forState:UIControlStateNormal];
			
			if ([title isEqualToString:@"\\t"] != YES) {
				[button addTarget:self action:@selector(insertDidPush:) forControlEvents:UIControlEventTouchUpInside];				
			} 
			else {
				[button addTarget:self action:@selector(tabDidPush) forControlEvents:UIControlEventTouchUpInside];
			}
			
			[self addSubview:button];
			i++;
		}


		//なんかうまくいかんし、必須じゃないのでescapeは後回しｚ
		/*
		NSInteger biggerWidth = 52;
		 
		button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		button.frame = CGRectMake((size + margin) * i++ + padding, padding, biggerWidth, size);
		[button setTitle:@"&amp;" forState:UIControlStateNormal];
		[button addTarget:self action:@selector(escapeDidPush) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:button];

		button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		button.frame = CGRectMake((size + margin) * i++ + padding + biggerWidth - size, padding, biggerWidth, size);
		[button setTitle:@"&" forState:UIControlStateNormal];
		[button addTarget:self action:@selector(unescapeDidPush) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:button];
		*/
		

	}
	return self;
}

- (void)insertDidPush:(UIButton *)button {
	[self insertString:button.titleLabel.text];
}

- (void)tabDidPush {
	[self insertString:@"\t"];
}

- (void)insertString:(NSString *)string {

	NSMutableString *text = [textView_.text mutableCopy];

	NSRange range = textView_.selectedRange;
	[text replaceCharactersInRange:range withString:string];

	// これだと末尾に追加されるだけ
	//	[text appendString:button.titleLabel.text];

	// カーソルが最後に行っちゃうので選択しなおす
//	NSLog(@"before %@", textView_.text);
	textView_.text = text;
//	NSLog(@"after %@", textView_.text);
	textView_.selectedRange = NSMakeRange(range.location + 1, 1);
//	NSLog(@"after %@", textView_.text);

	// undo登録
	[[textView_ undoManager] registerUndoWithTarget:self selector:@selector(backSpace:) object:string];
}

- (void)backSpace:(NSString *)string {
	
	NSMutableString *text = [textView_.text mutableCopy];
	
	// 手前にカーソルを戻して空文字で1文字分置換
	NSRange range = textView_.selectedRange;
	textView_.selectedRange = NSMakeRange(range.location - 1, 1);
	[text replaceCharactersInRange:textView_.selectedRange withString:@""];
	textView_.text = text;
	
	textView_.selectedRange = NSMakeRange(range.location - 1, 0);
	
	// redo登録
	[[textView_ undoManager] registerUndoWithTarget:self selector:@selector(insertString:) object:string];
}

/*
- (void)escapeDidPush {
	NSRange range = textView_.selectedRange;
	NSString *text = [textView_.text substringWithRange:range];
	
	text = [text stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
	text = [text stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
	text = [text stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];

	NSMutableString *mutable = [textView_.text mutableCopy];
	[mutable replaceCharactersInRange:range withString:text];	
	textView_.text = mutable;
}

- (void)unescapeDidPush {
	NSRange range = textView_.selectedRange;
	NSString *text = [textView_.text substringWithRange:range];
	text = [text stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
	text = [text stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
	text = [text stringByReplacingOccurrencesOfString:@"&gt" withString:@">"];	
	textView_.text = text;
}
*/


@end
