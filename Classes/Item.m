#import "Item.h"
#import "User.h"

@implementation Item
@synthesize uid;
@synthesize url;
@synthesize name;
@synthesize user;
@synthesize created_date;
@synthesize short_created_date;

- (NSComparisonResult)compare:(Item *)p
{
	return [[p created_date] compare:[self created_date]];
}

- (void) dealloc
{
	[uid release];
	[url release];
	[name release];
	[user release];
	[created_date release];
	[short_created_date release];
	[super dealloc];
}

@end
