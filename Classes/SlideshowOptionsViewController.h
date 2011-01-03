//
//  SlideshowOptionsViewController.h
//  PhotoExplorer
//
//  Created by Robert Stewart on 1/3/11.
//  Copyright 2011 Evernote. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
	SlideshowOrderByDate,
	SlideshowOrderByRandom,
	SlideshowOrderBySequential
} SlideshowSortOrder;



@interface SlideshowOptionsViewController : UIViewController {
	id delegate;
	IBOutlet UITableView * tableView;
	BOOL fillScreen;
	NSInteger delaySeconds;
	SlideshowSortOrder sortOrder;
	UIButton * startSlideshowButton;
}

@property(nonatomic,assign) id delegate;
@property(nonatomic,retain) IBOutlet UITableView * tableView;
@property(nonatomic) BOOL fillScreen;
@property(nonatomic) NSInteger delaySeconds;
@property(nonatomic) SlideshowSortOrder sortOrder;

- (IBAction) startSlideshow:(id)sender;

@end
