//
//  FacebookAlbumPictureFeed.h
//  PhotoExplorer
//
//  Created by Robert Stewart on 12/6/10.
//  Copyright 2010 Evernote. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FacebookFeed.h"
@class Album;
@interface FacebookAlbumPictureFeed : FacebookFeed {
	Album * album;
}
@property(nonatomic,retain) Album * album;

- (id) initWithFacebook:(Facebook*)facebook album:(Album*)album;

@end
