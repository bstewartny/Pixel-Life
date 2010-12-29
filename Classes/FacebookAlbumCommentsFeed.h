//
//  FacebookAlbumCommentsFeed.h
//  PhotoExplorer
//
//  Created by Robert Stewart on 12/28/10.
//  Copyright 2010 Evernote. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FacebookFeed.h"

@class Album;
@interface FacebookAlbumCommentsFeed : FacebookFeed {
	Album * album;
}
@property(nonatomic,assign) Album * album;

- (id) initWithFacebook:(Facebook*)facebook album:(Album*)album;

@end
