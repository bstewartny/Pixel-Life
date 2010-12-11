//
//  FacebookFriendFeed.m
//  PhotoExplorer
//
//  Created by Robert Stewart on 12/6/10.
//  Copyright 2010 Evernote. All rights reserved.
//

#import "FacebookFriendFeed.h"
#import "FBConnect.h"
#import "JSON.h"
#import "Friend.h"
#import "Picture.h"
#import "FacebookFriendAlbumFeed.h"
#import "ASIHTTPRequest.h"
@implementation FacebookFriendFeed

/*
- (NSString*) graphPath
{
	return @"me/friends?fields=id,name,first_name,last_name,birthday,location,picture";
}
*/

- (ASIHTTPRequest*)createFetchRequest
{
	NSLog(@"createFetchRequest");
	
	NSString * friend_query=@"SELECT uid,first_name,last_name,middle_name,name,pic_big,pic_small,pic,birthday_date FROM user WHERE uid in (select uid2 from friend where uid1=me())";
	
	NSString * escaped_query=[self escapeQueryValue:friend_query];
	
	NSString* escaped_token = [self escapeQueryValue:facebook.accessToken];
	
	NSString * url=[NSString stringWithFormat:@"https://api.facebook.com/method/fql.query?format=JSON&access_token=%@&query=%@",escaped_token,escaped_query];

	ASIHTTPRequest * request=[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
	
	request.requestMethod=@"GET";
	
	return request;
}

- (NSArray*) getItemsFromJson:(NSDictionary*)json
{
	NSMutableArray * friends=[[[NSMutableArray alloc] init] autorelease];
	
	for (NSDictionary * d in json) {
		
		Friend * friend=[[Friend alloc] init];
		
		friend.uid=[d objectForKey:@"uid"];
		friend.name=[d objectForKey:@"name"];
		friend.first_name=[d objectForKey:@"first_name"];
		friend.last_name=[d objectForKey:@"last_name"];
		
		Picture * picture=[[Picture alloc] init];
		
		picture.thumbnailURL=[d objectForKey:@"pic"];
		picture.imageURL=[d objectForKey:@"pic_big"];
		
		picture.user=friend;
		
		if([friend.first_name length]>0)
		{
			picture.name=friend.first_name;
			picture.description=friend.last_name;
		}
		else 
		{
			picture.description=friend.name;
		}
		
		//picture.name=friend.name;
		
		FacebookFriendAlbumFeed * albumFeed=[[FacebookFriendAlbumFeed alloc] initWithFacebook:facebook friend:friend];
		
		friend.albumFeed=albumFeed;
		
		[albumFeed release];
		
		friend.picture=picture;
		
		[picture release];
		
		[friends addObject:friend];
		
		[friend release];
	}
	
	
	return friends;
}

- (NSArray*) getItemsFromJsonOLD:(NSDictionary*)json
{
	NSMutableArray * friends=[[[NSMutableArray alloc] init] autorelease];
	/*
	 {
	 "data": [
	 {
	 "id": "688152358",
	 "name": "Sue Roth Stewart",
	 "first_name": "Sue",
	 "last_name": "Stewart",
	 "birthday": "10/11",
	 "location": {
	 "id": "107745065915449",
	 "name": "Huntington, New York"
	 },
	 "picture": "http://profile.ak.fbcdn.net/hprofile-ak-snc4/hs458.snc4/50109_688152358_53882_q.jpg"
	 }
	 ]
	 }
	 */
	
	//NSLog(@"json=%@",[json description]);
	
	NSArray * a=[json objectForKey:@"data"];
	
	for (NSDictionary * d in a) {
		
		Friend * friend=[[Friend alloc] init];
		
		friend.uid=[d objectForKey:@"id"];
		friend.name=[d objectForKey:@"name"];
		friend.first_name=[d objectForKey:@"first_name"];
		friend.last_name=[d objectForKey:@"last_name"];
		
		Picture * picture=[[Picture alloc] init];
		
		picture.thumbnailURL=[d objectForKey:@"picture"];
		
		picture.user=friend;
		
		if([friend.first_name length]>0)
		{
			picture.name=friend.first_name;
			picture.description=friend.last_name;
		}
		else 
		{
			picture.description=friend.name;
		}
		
		//picture.name=friend.name;
		
		FacebookFriendAlbumFeed * albumFeed=[[FacebookFriendAlbumFeed alloc] initWithFacebook:facebook friend:friend];
		
		friend.albumFeed=albumFeed;
		
		[albumFeed release];
		
		friend.picture=picture;
		
		[picture release];
		
		[friends addObject:friend];
		
		[friend release];
	}
	
	return friends;	
}


@end
