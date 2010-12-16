#import <Foundation/Foundation.h>

@class Feed;
@class Picture;
@interface FriendList : NSObject {
	NSString * uid;
	NSString * name;
	Feed * friendFeed;
	Picture * picture;
	NSInteger count;
}
@property(nonatomic,retain) NSString * uid;
@property(nonatomic,retain) NSString * name;
@property(nonatomic,retain) Feed * friendFeed;
@property(nonatomic,retain) Picture * picture;
@property(nonatomic) NSInteger count;
	


@end
