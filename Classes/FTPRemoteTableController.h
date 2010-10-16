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

enum {
	kEdhitaFTPModeLIST = 0,
	kEdhitaFTPModeGET = 1,
	kEdhitaFTPModePUT = 2
};
#define kSendBufferSize 32768

@interface FTPRemoteTableController : UITableViewController <UISplitViewControllerDelegate> {
	UIPopoverController *popoverController;
	NSMutableArray *items_;
	UILabel *messageLabel_;
	NSMutableDictionary *images_;
	int ftpMode_;
	NSString* localPath_;
	NSMutableArray *localItems_;
	UITableView *localTableView_;
	NSString* urlString_;
	NSString* file_;

	// LIST(& GET)
	NSInputStream *nwInputStream_;
	NSMutableData *listData_;

	// GET
	NSOutputStream *fileOutputStream_;

	// PUT
	NSOutputStream *nwOutputStream_;
	NSInputStream *fileInputStream_;
	
	uint8_t buffer_[kSendBufferSize];
	size_t bufferOffset_;
	size_t bufferLimit_;
	
	NSString *localFile_;
}

@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) NSString *localPath;
@property (nonatomic, retain) NSMutableArray *localItems;
@property (nonatomic, retain) UITableView *localTableView;
@property (nonatomic, retain) NSString *urlString;
@property (nonatomic, retain) NSString *localFile;

- (void)parseListData_;
- (NSDictionary *)entryByReencodingNameInEntry_:(NSDictionary *)entry encoding:(NSStringEncoding)newEncoding;
- (void)stopFTP_;
- (void)updateMessage_:(NSString *)message success:(BOOL)success;

- (void)getDidPush;

- (void)listByFTP;
- (void)getByFTP;
- (void)putByFtp;

- (id)initWithUrlString:(NSString *)urlString;

- (NSString *)encodeURI:(NSString *)string;

@end
