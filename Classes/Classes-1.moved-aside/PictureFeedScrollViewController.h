//
//  PictureFeedScrollViewController.h
//  PhotoExplorer
//
//  Created by Robert Stewart on 12/4/10.
//  Copyright 2010 Evernote. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PictureFeed;

@interface PictureFeedScrollViewController : UIViewController {
	PictureFeed * pictureFeed;
	NSArray * pictures;
	IBOutlet UIScrollView * scrollView;
	UIView *loadingView;
}
@property(nonatomic,retain) PictureFeed * pictureFeed;
@property(nonatomic,retain) NSArray * pictures;
@property(nonatomic,retain) IBOutlet UIScrollView * scrollView;
- (void)reloadFeed;

@end
