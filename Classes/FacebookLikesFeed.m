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
}
- (NSArray*) getItemsFromJson:(NSDictionary*)json
{
	NSMutableArray * friends=[[[NSMutableArray alloc] init] autorelease];
	
	NSArray * a=[json objectForKey:@"data"];
	
	for (NSDictionary * d in a) {
		
		Friend * friend=[[Friend alloc] init];
		
		friend.uid=[d objectForKey:@"id"];
		friend.name=[d objectForKey:@"name"];
	
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
