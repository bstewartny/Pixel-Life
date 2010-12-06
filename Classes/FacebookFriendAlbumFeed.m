//
//  FacebookFriendAlbumFeed.m
//  PhotoExplorer
//
//  Created by Robert Stewart on 12/6/10.
//  Copyright 2010 Evernote. All rights reserved.
//

#import "FacebookFriendAlbumFeed.h"
#import "ASIHTTPRequest.h"
#import "FBConnect.h"
#import "JSON.h"
#import "Album.h"
#import "Friend.h"
#import "Picture.h"
#import "FacebookAlbumPictureFeed.h"


@implementation FacebookFriendAlbumFeed
@synthesize friend;

- (id) initWithFacebook:(Facebook*)facebook friend:(Friend*)friend
{
	self=[super initWithFacebook:facebook];
	if (self==nil) {
		return nil;
	}
	self.friend=friend;
	return self;
}
- (NSString*) graphPath
{
	return [NSString stringWithFormat:@"%@/albums",friend.uid];
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
		
		Album  * album=[[Album alloc] init];
		
		album.user=friend;
		album.uid=[d objectForKey:@"id"];
		album.name=[d objectForKey:@"name"];
		album.url=[d objectForKey:@"link"];
		album.created_date=[NSDate date];
		album.updated_date=[NSDate date];
		
		Picture * picture=[[Picture alloc] init];
		
		//picture.imageURL=@"http://i.cdn.turner.com/cnn/2010/POLITICS/12/04/senate.tax.vote/story.senate.senatetv.jpg";
		
		picture.imageURL=[self createGraphUrl:[NSString stringWithFormat:@"%@/picture",album.uid]];
		picture.name=album.name;
		picture.user=album.user;
		
		album.picture=picture;
		
		FacebookAlbumPictureFeed * pictureFeed=[[FacebookAlbumPictureFeed alloc] initWithFacebook:facebook album:album];
		
		album.pictureFeed=pictureFeed;
		
		[pictureFeed release];
		
		
		[picture release];
		[albums addObject:album];
		
		[album release];
	}
	
	return albums;	
}

- (void) dealloc
{
	[friend release];
	[super dealloc];
}


@end
