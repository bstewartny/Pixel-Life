#import <Foundation/Foundation.h>
#import "FacebookFriendFeed.h"
#import "Facebook.h"

@class FriendList;
@interface FacebookFriendListFriendFeed : FacebookFriendFeed {
	FriendList * friendList;
}
@property(nonatomic,assign) FriendList * friendList;
	
- (id) initWithFacebookAccount:(FacebookAccount*)account friendList:(FriendList*)friendList;


@end
