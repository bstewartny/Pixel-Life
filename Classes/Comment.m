#import "Comment.h"

@implementation Comment
@synthesize message,picture;

- (void) dealloc
{
	[message release];
	[picture release];
	[super dealloc];
}
@end
