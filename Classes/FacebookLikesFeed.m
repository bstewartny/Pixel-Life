//
//  FacebookLikesFeed.m
//  PhotoExplorer
//
//  Created by Robert Stewart on 12/7/10.
//  Copyright 2010 Evernote. All rights reserved.
//

#import "FacebookLikesFeed.h"
#import "FBConnect.h"
#import "JSON.h"
#import "Friend.h"
#import "Picture.h"
#import "FacebookFriendAlbumFeed.h"

@implementation FacebookLikesFeed

- (NSString*) graphPath
{
	return @"me/likes?fields=id,name,category,picture";
	//return @"me/likes?fields=id,name,first_name,last_name,birthday,location,picture";
}
- (NSArray*) getItemsFromJson:(NSDictionary*)json
{
	NSMutableArray * friends=[[[NSMutableArray alloc] init] autorelease];
	/*
	 {
	 "data": [
	 {
	 "id": "63479801375",
	 "name": "International Arts Movement",
	 "category": "Nonprofit",
	 "picture": "http://profile.ak.fbcdn.net/hprofile-ak-snc4/hs443.snc4/50254_63479801375_8141_s.jpg",
	 "created_time": "2010-10-26T01:17:06+0000"
	 },
	 {
	 "id": "146175949904",
	 "name": "The Pittsburgh Steelers",
	 "category": "Sports_athletics",
	 "picture": "http://profile.ak.fbcdn.net/hprofile-ak-snc4/hs467.snc4/50332_146175949904_4593_s.jpg",
	 "created_time": "2010-10-25T23:30:01+0000"
	 },
	 */
	
	NSLog(@"json=%@",[json description]);
	
	NSArray * a=[json objectForKey:@"data"];
	
	for (NSDictionary * d in a) {
		
		Friend * friend=[[Friend alloc] init];
		
		friend.uid=[d objectForKey:@"id"];
		friend.name=[d objectForKey:@"name"];
		//friend.first_name=[d objectForKey:@"first_name"];
		//friend.last_name=[d objectForKey:@"last_name"];
		
		Picture * picture=[[Picture alloc] init];
		
		picture.thumbnailURL=[d objectForKey:@"picture"];
		
		picture.user=friend;
		
		picture.name=friend.name;
		picture.created_date=[self dateFromString:[d objectForKey:@"created_time"]];
		
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
