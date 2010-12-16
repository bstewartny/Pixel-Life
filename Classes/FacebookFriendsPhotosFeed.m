#import "FacebookFriendsPhotosFeed.h"
#import "ASIHTTPRequest.h"
#import "FBConnect.h"
#import "JSON.h"
#import "Album.h"
#import "Friend.h"
#import "Picture.h"

@implementation FacebookFriendsPhotosFeed

- (ASIHTTPRequest*)createFetchRequest
{
	NSString * friend_query=@"SELECT uid,first_name,last_name,name FROM user WHERE uid in (select uid2 from friend where uid1=me())";
	
	NSString * photo_query=@"SELECT pid,aid,owner,src_small,src_big,src_big_height,src_big_width,caption,created,modified FROM photo WHERE aid in (select aid from album where owner in (select uid from #friends)) ORDER BY created DESC limit 200";
	
	NSDictionary * queries=[NSDictionary dictionaryWithObjectsAndKeys:friend_query,@"friends",photo_query,@"photos",nil];
	
	NSString* escaped_token = [self escapeQueryValue:facebook.accessToken];
	
	NSString * json_queries=[queries JSONRepresentation];
	
	NSString * escaped_queries=[self escapeQueryValue:json_queries];
	
	NSString * url=[NSString stringWithFormat:@"https://api.facebook.com/method/fql.multiquery?format=JSON&access_token=%@&queries=%@",escaped_token,escaped_queries];
	
	ASIHTTPRequest * request=[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
	
	request.requestMethod=@"GET";
	
	return request;
}

- (NSArray*) getItemsFromJson:(NSDictionary*)json
{
	NSMutableArray * photos=[[[NSMutableArray alloc] init] autorelease];
	
	NSArray * friends_results;
	NSArray * photos_results;
	
	for (NSDictionary * result_dict in json)
	{
		if([[result_dict objectForKey:@"name"] isEqualToString:@"friends"])
		{
			friends_results=[result_dict objectForKey:@"fql_result_set"];
		}
		if([[result_dict objectForKey:@"name"] isEqualToString:@"photos"])
		{
			photos_results=[result_dict objectForKey:@"fql_result_set"];
		}	
	}
	
	// put friends into map so we can lookup by id...
	NSMutableDictionary * friend_map=[[NSMutableDictionary alloc] init];
	
	for(NSDictionary * fr in friends_results)
	{
		[friend_map setObject:fr forKey:[[fr objectForKey:@"uid"] stringValue]];
	}
	
	for(NSDictionary * d in photos_results)
	{
		Picture * picture=[[Picture alloc] init];
		
		Friend * friend=[[Friend alloc] init];
		friend.uid=[d objectForKey:@"owner"];
		
		NSDictionary * fr=[friend_map objectForKey:friend.uid];
		
		if(fr)
		{
			friend.name=[fr objectForKey:@"name"];
			friend.first_name=[fr objectForKey:@"first_name"];
			friend.last_name=[fr objectForKey:@"last_name"];
		}
		else	
		{
			NSLog(@"no friend found for uid: %@",friend.uid);
			friend.name=friend.uid;
		}
		
		picture.user=friend;
		
		[friend release];
		
		picture.uid=[d objectForKey:@"pid"];
		picture.name=friend.name;
		picture.description=[d objectForKey:@"caption"];
		picture.thumbnailURL=[d objectForKey:@"src_small"];
		picture.imageURL=[d objectForKey:@"src_big"];
		picture.width=[[d objectForKey:@"src_big_width"] intValue];
		picture.height=[[d objectForKey:@"src_big_height"] intValue];
		
		picture.created_date=[NSDate dateWithTimeIntervalSince1970:[[d objectForKey:@"created"] intValue]];
		picture.updated_date=[NSDate dateWithTimeIntervalSince1970:[[d objectForKey:@"modified"] intValue]];
		
		[photos addObject:picture];
		
		[picture release];
	}
	
	return photos;
}

- (NSArray*) getItemsFromJson_OLD:(NSDictionary*)json
{
	NSMutableArray * photos=[[[NSMutableArray alloc] init] autorelease];
	
	for (NSDictionary * d in json) 
	{
		Picture * picture=[[Picture alloc] init];
		
		Friend * friend=[[Friend alloc] init];
		friend.uid=[d objectForKey:@"owner"];
		picture.user=friend;
		[friend release];
		
		picture.uid=[d objectForKey:@"pid"];
		picture.name=friend.name;
		picture.description=[d objectForKey:@"caption"];
		picture.thumbnailURL=[d objectForKey:@"src_small"];
		picture.imageURL=[d objectForKey:@"src_big"];
		picture.width=[[d objectForKey:@"src_big_width"] intValue];
		picture.height=[[d objectForKey:@"src_big_height"] intValue];
		
		picture.created_date=[NSDate dateWithTimeIntervalSince1970:[[d objectForKey:@"created"] intValue]];
		picture.updated_date=[NSDate dateWithTimeIntervalSince1970:[[d objectForKey:@"modified"] intValue]];
		
		[photos addObject:picture];
		
		[picture release];
	}
	return photos;
}
 


@end
