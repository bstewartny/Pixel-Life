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

@implementation FacebookFriendFeed


- (NSString*) graphPath
{
	return @"me/friends?fields=id,name,first_name,last_name,birthday,location,picture";
}
- (NSArray*) getItemsFromJson:(NSDictionary*)json
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
	
	NSLog(@"json=%@",[json description]);
	
	NSArray * a=[json objectForKey:@"data"];
	
	for (NSDictionary * d in a) {
		
		Friend * friend=[[Friend alloc] init];
		
		friend.uid=[d objectForKey:@"id"];
		friend.name=[d objectForKey:@"name"];
		friend.first_name=[d objectForKey:@"first_name"];
		friend.last_name=[d objectForKey:@"last_name"];
		
		Picture * picture=[[Picture alloc] init];
		
		picture.imageURL=[d objectForKey:@"picture"];
		
		picture.user=friend;
		
		picture.name=friend.name;
		
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
