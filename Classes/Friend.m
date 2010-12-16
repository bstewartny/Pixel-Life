#import "Friend.h"
#import "Picture.h"
#import "Feed.h"

@implementation Friend

@synthesize first_name;
@synthesize last_name;
@synthesize url;
@synthesize about;
@synthesize birthday;
@synthesize location;
@synthesize albumFeed;
@synthesize picture;

- (NSComparisonResult)compareFriend:(Friend *)p
{
    return [[NSString stringWithFormat:@"%@, %@", 
			 [self last_name], [self first_name]]
            compare:
            [NSString stringWithFormat:@"%@, %@", 
			 [p last_name], [p first_name]]];
}

- (void) dealloc
{
	[first_name release];
	[last_name release];
	[url release];
	[about release];
	[birthday release];
	[location release];
	[albumFeed release];
	[picture release];
	[super dealloc];
}

@end
