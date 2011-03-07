#import "FacebookAccountInfoFeed.h"
#import "FacebookAccount.h"
@implementation FacebookAccountInfoFeed

- (NSString*) graphPath
{
	return @"me?fields=id,name";
}

- (NSArray*) getItemsFromJson:(NSDictionary*)json
{
	if(![json isKindOfClass:[NSDictionary class]])
	{
		//NSLog(@"json object is not a dictionary: %@",[json description]);
		return nil;
	}
	
	account.uid=[json objectForKey:@"id"];
	account.name=[json objectForKey:@"name"];
	
	return [NSMutableArray arrayWithObject:account];
}

@end
