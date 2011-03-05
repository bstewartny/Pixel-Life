#import "Item.h"
#import "User.h"

@implementation Item
@synthesize uid;
@synthesize url;
@synthesize name;
@synthesize user;
@synthesize created_date;
@synthesize updated_date;


- (NSComparisonResult)compare:(Item *)p
{
	if(p.updated_date==nil || self.updated_date==nil)
	{
		return [[p created_date] compare:[self created_date]];
	}
	else 
	{
		return [[p updated_date] compare:[self updated_date]];
	}
}

- (void) dealloc
{
	[uid release];
	[url release];
	[name release];
	[user release];
	[created_date release];
	[updated_date release];
	[super dealloc];
}

@end
