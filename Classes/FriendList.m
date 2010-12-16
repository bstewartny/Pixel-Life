#import "FriendList.h"
#import "Feed.h"
#import "Picture.h"

@implementation FriendList
@synthesize uid,name,friendFeed,picture,count;

- (void) dealloc
{
	[uid release];
	[name release];
	[picture release];
	[friendFeed release];
	[super dealloc];
}

@end
