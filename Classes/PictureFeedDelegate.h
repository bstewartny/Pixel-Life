//
//  PictureFeedDelegate.h
//  PhotoExplorer
//
//  Created by Robert Stewart on 12/4/10.
//  Copyright 2010 Evernote. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PictureFeed;

@protocol PictureFeedDelegate
	
@required
- (void)pictureFeed:(PictureFeed *)pictureFeed didFindPictures:(NSArray *)pictures;
- (void)pictureFeed:(PictureFeed *)pictureFeed didFailWithError:(NSString *)errorMsg;
	

@end
