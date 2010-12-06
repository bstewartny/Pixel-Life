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
	
	return self;
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

- (ASIHTTPRequest*)createFetchRequest
{

	NSString* escaped_token = (NSString *)CFURLCreateStringByAddingPercentEscapes(
																				  NULL, /* allocator */
																				  (CFStringRef)facebook.accessToken,
																				  NULL, /* charactersToLeaveUnescaped */
																				  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
																				  kCFStringEncodingUTF8);
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
	[super dealloc];
}


@end
