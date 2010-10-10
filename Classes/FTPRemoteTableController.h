//
//  FTPRemoteTableController.h
//  Edhita
//
//  Created by t on 10/09/28.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTPSplitViewController.h"

//#include <sys/socket.h>
//#include <sys/dirent.h>
#import <CFNetwork/CFNetwork.h>

enum kEdhitaFTPMode {
	kEdhitaFTPModeGET = 0,
	kEdhitaFTPModeLIST = 1
};

@interface FTPRemoteTableController : UITableViewController <UISplitViewControllerDelegate> {
	UIPopoverController *popoverController;
	NSMutableData *listData_;
	NSInputStream *inputStream_;
	NSMutableArray *items_;
	UILabel *messageLabel_;
	NSMutableDictionary *images_;
	int ftpMode_;
	NSOutputStream *fileStream_;
	NSString* localPath_;
	NSMutableArray *localItems_;
	UITableView *localTableView_;
	NSString* urlString_;
	NSString* file_;
}

@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) NSString *localPath;
@property (nonatomic, retain) NSMutableArray *localItems;
@property (nonatomic, retain) UITableView *localTableView;
@property (nonatomic, retain) NSString *urlString;

- (void)parseListData_;
- (NSDictionary *)entryByReencodingNameInEntry_:(NSDictionary *)entry encoding:(NSStringEncoding)newEncoding;
- (void)stopReceive_:(NSString *)statusString;
- (void)updateMessage_:(NSString *)message;

- (void)getDidPush;

- (void)listByFTP;
- (void)getByFTP;

- (id)initWithUrlString:(NSString *)urlString;

@end
