//
//  PictureFeed.h
//  PhotoExplorer
//
//  Created by Robert Stewart on 12/4/10.
//  Copyright 2010 Evernote. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PictureFeedDelegate.h"

@interface PictureFeed : Feed {
	NSObject<PictureFeedDelegate> *delegate;
	
}
@property (nonatomic, assign) NSObject<PictureFeedDelegate> *delegate;

- (void) fetch;



@end
