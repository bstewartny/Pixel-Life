//
//  FacebookFriendsPhotosFeed.m
//  PhotoExplorer
//
//  Created by Robert Stewart on 12/7/10.
//  Copyright 2010 Evernote. All rights reserved.
//

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
	NSLog(@"createFetchRequest");
	
	NSString * friend_query=@"SELECT uid,first_name,last_name,name FROM user WHERE uid in (select uid2 from friend where uid1=me())";
	
	NSString * photo_query=@"SELECT pid,aid,owner,src_small,src_big,src_big_height,src_big_width,caption,created,modified FROM photo WHERE aid in (select aid from album where owner in (select uid from #friends)) ORDER BY created DESC limit 200";
	
	NSDictionary * queries=[NSDictionary dictionaryWithObjectsAndKeys:friend_query,@"friends",photo_query,@"photos",nil];
	
	
	//NSString * escaped_query=[self escapeQueryValue:@"SELECT pid,owner,src_small,src_big,src_big_height,src_big_width,caption,created,modified FROM photo WHERE aid in (select aid from album where owner in (select uid2 from friend where uid1=me())) ORDER BY created DESC limit 200"];
	
	NSString* escaped_token = [self escapeQueryValue:facebook.accessToken];
	
	//NSString * url=[NSString stringWithFormat:@"https://api.facebook.com/method/fql.query?format=JSON&access_token=%@&query=%@",escaped_token,escaped_query];
	
	NSString * json_queries=[queries JSONRepresentation];
	
	NSLog(@"json=%@",json_queries);
	
	NSString * escaped_queries=[self escapeQueryValue:json_queries];
	
	NSString * url=[NSString stringWithFormat:@"https://api.facebook.com/method/fql.multiquery?format=JSON&access_token=%@&queries=%@",escaped_token,escaped_queries];
	
	NSLog(@"FacebookFriendsPhotosFeed.createFetchRequest: %@",url);
	
	ASIHTTPRequest * request=[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
	
	
	
	
	
	
	
	
	
	//ASIHTTPRequest * request=[ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
	
	request.requestMethod=@"GET";
	
	return request;
}

- (NSArray*) getItemsFromJson:(NSDictionary*)json
{
	NSMutableArray * photos=[[[NSMutableArray alloc] init] autorelease];
	
	NSLog(@"json=%@",[json description]);
	
	/*
	 (
	 {
	 "fql_result_set" =         (
	 {
	 "first_name" = Sue;
	 "last_name" = Stewart;
	 name = "Sue Roth Stewart";
	 uid = 688152358;
	 }
	 );
	 name = query1;
	 },
	 {
	 "fql_result_set" =         {
	 };
	 name = query2;
	 }
	 )
	*/
	
	
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
	
	NSLog(@"friend_map=%@",[friend_map description]);
	
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
	/*
	 json=(
	 {
	 caption = "";
	 created = 1291496803;
	 modified = 1291496841;
	 owner = 688152358;
	 pid = 2955591872282520300;
	 "src_big" = "http://sphotos.ak.fbcdn.net/hphotos-ak-ash2/hs600.ash2/155243_10150089230127359_688152358_7236332_154537_n.jpg";
	 "src_big_height" = 720;
	 "src_big_width" = 540;
	 "src_small" = "http://photos-g.ak.fbcdn.net/hphotos-ak-ash2/hs600.ash2/155243_10150089230127359_688152358_7236332_154537_t.jpg";
	 },
	 {
	 caption = "";
	 created = 1291496786;
	 modified = 1291496841;
	 owner = 688152358;
	 pid = 2955591872282520296;
	 "src_big" = "http://sphotos.ak.fbcdn.net/hphotos-ak-ash2/hs595.ash2/154720_10150089229907359_688152358_7236328_3367832_n.jpg";
	 "src_big_height" = 720;
	 "src_big_width" = 540;
	 "src_small" = "http://photos-b.ak.fbcdn.net/hphotos-ak-ash2/hs595.ash2/154720_10150089229907359_688152358_7236328_3367832_t.jpg";
	 },
	 
	 
	 
	 */
	NSLog(@"json=%@",[json description]);
	
	for (NSDictionary * d in json) {
		
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
	NSLog(@"Got %d friends photos",[photos count]);
	return photos;
}
 


@end
