#import <Foundation/Foundation.h>
#import "FacebookFriendFeed.h"
#import "Facebook.h"

@class FriendList;
@interface FacebookFriendListFriendFeed : FacebookFriendFeed {
	FriendList * friendList;
}
@property(nonatomic,retain) FriendList * friendList;
	
- (id) initWithFacebook:(Facebook*)facebook friendList:(FriendList*)friendList;


@end
