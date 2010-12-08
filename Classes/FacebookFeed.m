//
//  FacebookFeed.m
//  PhotoExplorer
//
//  Created by Robert Stewart on 12/6/10.
//  Copyright 2010 Evernote. All rights reserved.
//

#import "FacebookFeed.h"
#import "ASIHTTPRequest.h"
#import "FBConnect.h"
#import "JSON.h"

@implementation FacebookFeed
@synthesize facebook;

- (id) initWithFacebook:(Facebook*)facebook
{
	self=[super init];
	
	self.facebook=facebook;
	
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
	return [formatter dateFromString:date];
}

- (NSString*) createGraphUrl:(NSString*)path
{
	NSString* escaped_token = (NSString *)CFURLCreateStringByAddingPercentEscapes(
																				  NULL, /* allocator */
																				  (CFStringRef)facebook.accessToken,
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
	NSString* escaped_token = [self escapeQueryValue:facebook.accessToken];
	
	NSString * seperator=@"?";
	
	NSString * path=[self graphPath];
	
	if([path rangeOfString:@"?"].location!=NSNotFound)
	{
		seperator=@"&";
	}
	
	NSString * url=[NSString stringWithFormat:@"https://graph.facebook.com/%@%@access_token=%@",path,seperator,escaped_token];
	
	NSLog(@"FacebookFeed.createFetchRequest: %@",url);
	
	ASIHTTPRequest * request=[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
	
	//ASIHTTPRequest * request=[ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
	
	request.requestMethod=@"GET";
	
	return request;
}

- (NSArray*)getItemsFromResponseData:(NSData*)data
{
	return [self getItemsFromJson:[[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease] JSONValue]];
}

- (void) dealloc
{
	[facebook release];
	[formatter release];
	[super dealloc];
}


@end
