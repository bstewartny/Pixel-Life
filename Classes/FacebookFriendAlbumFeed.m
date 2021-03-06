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

- (id) initWithFacebookAccount:(FacebookAccount*)account friend:(Friend*)friend
{
	self=[super initWithFacebookAccount:account];
	if (self==nil) {
		return nil;
	}
	self.friend=friend;
	return self;
}
- (NSString*) graphPath
{
	return [NSString stringWithFormat:@"%@/albums?fields=id,name,from,link,created_time,updated_time,count,comments",friend.uid];
}

- (NSArray*) getItemsFromJson:(NSDictionary*)json
{
	if(![json isKindOfClass:[NSDictionary class]])
	{
		//NSLog(@"json object is not a dictionary: %@",[json description]);
		return nil;
	}
	
	NSMutableArray * albums=[[[NSMutableArray alloc] init] autorelease];
		
	NSArray * a=[json objectForKey:@"data"];
	
	for (NSDictionary * d in a) {
		
		Album  * album=[[Album alloc] init];
		
		if(friend)
		{
			album.user=friend;
		}
		else 
		{
			Friend * fr=[[Friend alloc] init];
			fr.name=[[d objectForKey:@"from"] objectForKey:@"name"];
			fr.uid=[[d objectForKey:@"from"] objectForKey:@"id"];
			Picture * pic=[[Picture alloc] init];
			pic.thumbnailURL=[self createGraphUrl:[NSString stringWithFormat:@"%@/picture?type=large",fr.uid]];
			pic.imageURL=pic.thumbnailURL;
			fr.picture=pic;
			[pic release];
			album.user=fr;
			[fr release];
		}

		album.uid=[d objectForKey:@"id"];
		album.name=[d objectForKey:@"name"];
		album.url=[d objectForKey:@"link"];
		
		NSDate * updated_date=[self dateFromString:[d objectForKey:@"updated_time"]];
		if(updated_date)
		{
			album.created_date=updated_date;
		}
		else {
			album.created_date=[self dateFromString:[d objectForKey:@"created_time"]];
		}
		
		album.short_created_date=[self stringFromDate:album.created_date];
		
		album.count=[[d objectForKey:@"count"] intValue];
		
		NSDictionary * comments_dict=[d objectForKey:@"comments"];
		
		if(comments_dict)
		{
			//NSMutableArray * comments=[[NSMutableArray alloc] init];
			NSArray * comments=[comments_dict objectForKey:@"data"];
			
			album.commentCount=[comments count];
		}
		
		Picture * picture=[[Picture alloc] init];
		
		picture.thumbnailURL=[self createGraphUrl:[NSString stringWithFormat:@"%@/picture",album.uid]];
		picture.name=album.name;
		
		picture.description=[NSString stringWithFormat:@"%d photos",album.count];
		picture.created_date=album.created_date;
		picture.short_created_date=album.short_created_date;
									
		album.picture=picture;
		
		FacebookAlbumPictureFeed * pictureFeed=[[FacebookAlbumPictureFeed alloc] initWithFacebookAccount:account album:album];
		
		album.pictureFeed=pictureFeed;
		
		[pictureFeed release];
		
		[picture release];
		[albums addObject:album];
		
		[album release];
	}
	
	// sort by date in desc order...
	[albums sortUsingSelector:@selector(compare:)];
	
	return albums;	
}

- (void) dealloc
{
	//[friend release];
	[super dealloc];
}


@end
