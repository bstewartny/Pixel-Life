#import "FacebookAccount.h"

@implementation FacebookAccount
@synthesize name,accessToken,expirationDate,uid;

- (void)encodeWithCoder:(NSCoder *)aCoder
{
	//NSLog(@"encodeWithCoder...");
	[aCoder encodeObject:name forKey:@"name"];
	[aCoder encodeObject:accessToken forKey:@"accessToken"];
	[aCoder encodeObject:expirationDate forKey:@"expirationDate"];
	[aCoder encodeObject:uid forKey:@"uid"];
	
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	//NSLog(@"initWithCoder...");
	[super init];
	name=[[aDecoder decodeObjectForKey:@"name"] retain];
	accessToken=[[aDecoder decodeObjectForKey:@"accessToken"] retain];
	expirationDate=[[aDecoder decodeObjectForKey:@"expirationDate"] retain];
	uid=[[aDecoder decodeObjectForKey:@"uid"] retain];
	 
	return self;
}

- (NSString *) pictureUrl
{
	return [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture",uid];
}

- (BOOL)isSessionValid 
{
	return (self.accessToken != nil && self.expirationDate != nil
			&& NSOrderedDescending == [self.expirationDate compare:[NSDate date]]);
}

- (void) dealloc
{
	[name release];
	[accessToken release];
	[expirationDate release];
	[uid release];
	 
	[super dealloc];
}
@end
