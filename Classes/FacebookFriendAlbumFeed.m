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
		
	NSArray * a=[json objectForKey:@"data"];
	
	for (NSDictionary * d in a) {
		
		Album  * album=[[Album alloc] init];
		
		album.user=friend;
		album.uid=[d objectForKey:@"id"];
		album.name=[d objectForKey:@"name"];
		album.url=[d objectForKey:@"link"];
		album.created_date=[self dateFromString:[d objectForKey:@"created_time"]];
		album.updated_date=[self dateFromString:[d objectForKey:@"updated_time"]];
		
		album.count=[[d objectForKey:@"count"] intValue];
		
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
	
	return albums;	
}

- (void) dealloc
{
	[friend release];
	[super dealloc];
}


@end
