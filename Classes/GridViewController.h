//
//  GridViewController.h
//  PhotoExplorer
//
//  Created by Robert Stewart on 12/5/10.
//  Copyright 2010 Evernote. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQGridView.h"
@class Feed;

@interface GridViewController : UIViewController <AQGridViewDelegate, AQGridViewDataSource> {
	IBOutlet AQGridView * gridView;
	UIView *loadingView;
	NSArray * items;
	Feed * feed;
}
@property(nonatomic,retain)Feed * feed;
@property(nonatomic,retain)NSArray * items;
@property (nonatomic, retain) IBOutlet AQGridView * gridView;

- (void)reloadGrid;
- (id)initWithFeed:(Feed*)feed title:(NSString*)title;

@end
