//
//  FeedViewController.h
//  PhotoExplorer
//
//  Created by Robert Stewart on 12/21/10.
//  Copyright 2010 Evernote. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Feed;

@interface FeedViewController : UIViewController {
	UIView *loadingView;
	NSArray * items;
	Feed * feed;
	UIActivityIndicatorView * spinningWheel; 
}
@property(nonatomic,retain)Feed * feed;
@property(nonatomic,retain)NSArray * items;

- (void)reloadFeed;
- (void)reloadData;
- (id)initWithFeed:(Feed*)feed title:(NSString*)title withNibName:(NSString*)nibName;


@end
