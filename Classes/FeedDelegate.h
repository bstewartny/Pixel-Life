//
//  FeedDelegate.h
//  PhotoExplorer
//
//  Created by Robert Stewart on 12/5/10.
//  Copyright 2010 Evernote. All rights reserved.
//

#import <UIKit/UIKit.h>


@class Feed;
@protocol FeedDelegate

@required
- (void)feed:(Feed *)feed didFindItems:(NSArray *)items;
- (void)feed:(Feed *)feed didFailWithError:(NSString *)errorMsg;

@end
