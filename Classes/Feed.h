//
//  Feed.h
//  PhotoExplorer
//
//  Created by Robert Stewart on 12/5/10.
//  Copyright 2010 Evernote. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "FeedDelegate.h"

@interface Feed : NSObject {
	NSObject<FeedDelegate> *delegate;
	
}
@property (nonatomic, assign) NSObject<FeedDelegate> *delegate;

- (void) fetch;


@end
