//
//  FacebookFriendsAlbumsFeed.m
//  PhotoExplorer
//
//  Created by Robert Stewart on 12/7/10.
//  Copyright 2010 Evernote. All rights reserved.
//

#import "FacebookFriendsAlbumsFeed.h"
#import "ASIHTTPRequest.h"
#import "FBConnect.h"
#import "JSON.h"
#import "Album.h"
#import "Friend.h"
#import "Picture.h"
#import "FacebookAlbumPictureFeed.h"

@implementation FacebookFriendsAlbumsFeed
 
- (NSString*) graphPath
{
	return @"me/friends?fields=id,name,first_name,last_name,picture,albums";
}
- (NSArray*) getItemsFromJson:(NSDictionary*)json
{
	NSMutableArray * albums=[[[NSMutableArray alloc] init] autorelease];
	/*
	 {
	 "data": [
		 {
		 "id": "688152358",
		 "name": "Sue Roth Stewart",
		 "first_name": "Sue",
		 "last_name": "Stewart",
		 "picture": "http://profile.ak.fbcdn.net/hprofile-ak-snc4/hs458.snc4/50109_688152358_53882_q.jpg",
		 "albums": {
			 "data": [
				 {
				 "id": "10150089221722359",
				 "from": {
					"name": "Sue Roth Stewart",
					"id": "688152358"
				 },
				 "name": "Summer 2010",
				 "link": "http://www.facebook.com/album.php?aid=306832&id=688152358",
				 "count": 1,
				 "type": "normal",
				 "created_time": "2010-12-04T20:51:35+0000",
				 "updated_time": "2010-12-04T20:51:45+0000"
				 },
	 */
	
	NSLog(@"json=%@",[json description]);
	
	NSArray * ar=[json objectForKey:@"data"];
	
	for (NSDictionary * d in ar) {
		
		Friend * f=[[Friend alloc] init];
		
		f.name=[d objectForKey:@"name"];
		f.first_name=[d objectForKey:@"first_name"];
		f.last_name=[d objectForKey:@"last_name"];
		f.uid=[d objectForKey:@"id"];
		
		Picture * p=[[Picture alloc] init];
		p.user=f;
		p.thumbnailURL=[d objectForKey:@"picture"];
		
		f.picture=p;
		[p release];
		
		NSArray * n=[[d objectForKey:@"albums"] objectForKey:@"data"];
		
		for(NSDictionary * a in n)
		{
			Album  * album=[[Album alloc] init];
			
			album.user=f;
			album.uid=[a objectForKey:@"id"];
			album.name=[a objectForKey:@"name"];
			album.url=[a objectForKey:@"link"];
			album.created_date=[self dateFromString:[a objectForKey:@"created_time"]];
			album.updated_date=[self dateFromString:[a objectForKey:@"updated_time"]];
			
			album.count=[[a objectForKey:@"count"] intValue];
			
			Picture * picture=[[Picture alloc] init];
			
			picture.thumbnailURL=[self createGraphUrl:[NSString stringWithFormat:@"%@/picture",album.uid]];
			picture.name=album.name;
			
			picture.description=[NSString stringWithFormat:@"%d photos",album.count];
			picture.user=album.user;
			picture.created_date=album.created_date;
			picture.updated_date=album.updated_date;
			
			album.picture=picture;
			
			FacebookAlbumPictureFeed * pictureFeed=[[FacebookAlbumPictureFeed alloc] initWithFacebook:facebook album:album];
			
			album.pictureFeed=pictureFeed;
			
			[pictureFeed release];
			
			
			[picture release];
			
			[albums addObject:album];
			
			[album release];
		}
		
		[f release];
	}
	
	return albums;	
}

