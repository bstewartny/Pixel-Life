#import "User.h"

@implementation User
@synthesize uid,name;

- (void) dealloc
{
	[uid release];
	[name release];
	[super dealloc];
}
@end
