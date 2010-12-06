//
//  FacebookFriendAlbumFeed.h
//  PhotoExplorer
//
//  Created by Robert Stewart on 12/6/10.
//  Copyright 2010 Evernote. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FacebookFeed.h"
@class Friend;
@interface FacebookFriendAlbumFeed : FacebookFeed {
	Friend * friend;
}
@property(nonatomic,retain) Friend * friend;

- (id) initWithFacebook:(Facebook*)facebook friend:(Friend*)friend;

@end
