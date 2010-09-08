//
//  RootViewController.h
//  Test
//
//  Created by t on 10/08/15.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EdhitaTableViewController.h"
//#import "DetailViewController.h"
#import "AdMobDelegateProtocol.h"
#import "AdMobView.h"

@class DetailViewController;

@interface RootViewController : UITableViewController <AdMobDelegate> {
    DetailViewController *detailViewController;
	NSMutableArray *items_;
	NSArray *images_;
	NSString *path_;
}

//@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;
@property (nonatomic, retain) DetailViewController *detailViewController;

- (void)newFileDidPush;
- (void)newDirDidPush;
- (NSString *)nextFileName:fileName;

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath;
- (CGSize)contentSizeForViewInPopover;



@end
