#import <Foundation/Foundation.h>
#import "FacebookFeed.h"

@class Friend;
@interface FacebookFriendAlbumFeed : FacebookFeed {
	Friend * friend;
}
@property(nonatomic,assign) Friend * friend;

- (id) initWithFacebook:(Facebook*)facebook friend:(Friend*)friend;

@end
