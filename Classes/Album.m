#import "Album.h"
#import "Feed.h"
#import "Picture.h"

@implementation Album
@synthesize pictureFeed,picture;
@synthesize description;
@synthesize location;
@synthesize count;
@synthesize commentCount;


- (void) dealloc
{
	[picture release];
	[pictureFeed release];
	[description release];
	[location release];
	[super dealloc];
}
@end
