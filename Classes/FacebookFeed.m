#import "FacebookFeed.h"
#import "ASIHTTPRequest.h"
#import "FBConnect.h"
#import "JSON.h"
#import "FacebookAccount.h"

@implementation FacebookFeed
@synthesize account;

- (id) initWithFacebookAccount:(FacebookAccount*)account
{
	self=[super init];
	
	self.account=account;
	
	formatter = [[NSDateFormatter alloc] init];
	[formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
	
	NSLocale *enUS = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
	
	[formatter setLocale:enUS];
	[enUS release];
	
	[formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];//2010-11-30T21:05:41+0000
	
	return self;
}

- (NSDate*) dateFromString:(NSString*)date
{
	NSLog(@"dateFromString:%@",date);
	return [formatter dateFromString:date];
}

- (NSString*) createGraphUrl:(NSString*)path
{
	NSString* escaped_token = (NSString *)CFURLCreateStringByAddingPercentEscapes(
																				  NULL, /* allocator */
																				  (CFStringRef)account.accessToken,
																				  NULL, /* charactersToLeaveUnescaped */
																				  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
																				  kCFStringEncodingUTF8);
	NSString * seperator=@"?";
	
	if([path rangeOfString:@"?"].location!=NSNotFound)
	{
		seperator=@"&";
	}
	
	return [NSString stringWithFormat:@"https://graph.facebook.com/%@%@access_token=%@",path,seperator,escaped_token];
}

- (NSString*) graphPath
{
	// subclass... return facebook graph path such as: "me/friends?fields=id,name"
}

- (NSArray*) getItemsFromJson:(NSDictionary*)json
{
	// subclass
}

- (NSString*) escapeQueryValue:(NSString*)value
{
	return (NSString *)CFURLCreateStringByAddingPercentEscapes(
													NULL, /* allocator */
													(CFStringRef)value,
													NULL, /* charactersToLeaveUnescaped */
													(CFStringRef)@"!*'();:@&=+$,/?%#[]",
													kCFStringEncodingUTF8);
}

- (ASIHTTPRequest*)createFetchRequest
{
	NSString* escaped_token = [self escapeQueryValue:account.accessToken];
	
	NSString * seperator=@"?";
	
	NSString * path=[self graphPath];
	
	if([path rangeOfString:@"?"].location!=NSNotFound)
	{
		seperator=@"&";
	}
	
	NSString * url=[NSString stringWithFormat:@"https://graph.facebook.com/%@%@access_token=%@",path,seperator,escaped_token];
	
	ASIHTTPRequest * request=[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
	[request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
	[request setSecondsToCache:60*60*24*3]; // Cache for 3 days
	
	request.requestMethod=@"GET";
	
	return request;
}

- (NSArray*)getItemsFromResponseData:(NSData*)data
{
	return [self getItemsFromJson:[[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease] JSONValue]];
}

- (void) dealloc
{
	[account release];
	[formatter release];
	[super dealloc];
}


@end
