//
//  AlbumGridViewController.h
//  PhotoExplorer
//
//  Created by Robert Stewart on 12/28/10.
//  Copyright 2010 Evernote. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "PictureFeedGridViewController.h"
#define kAlbumLikeActionSheet 1
#define kAlbumActionActionSheet 2
@class Album;
@interface AlbumGridViewController : PictureFeedGridViewController<MFMailComposeViewControllerDelegate> {
	Album * album;
	UIBarButtonItem * showCommentsButton;
	UIPopoverController * showCommentsPopover;
	UIPopoverController * addCommentPopover;
}
@property(nonatomic,retain) Album * album;

- (id) initWithAlbum:(Album*)album;

@end
