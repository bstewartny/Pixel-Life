#import "FacebookAlbumPictureFeed.h"
#import "ASIHTTPRequest.h"
#import "FBConnect.h"
#import "JSON.h"
#import "Album.h"
#import "Friend.h"
#import "Picture.h"

@implementation FacebookAlbumPictureFeed
@synthesize album;

- (id) initWithFacebook:(Facebook*)facebook album:(Album*)album
{
	self=[super initWithFacebook:facebook];
	if (self==nil) {
		return nil;
	}
	self.album=album;
	return self;
}
- (NSString*) graphPath
{
	return [NSString stringWithFormat:@"%@/photos?limit=1000&fields=id,picture,source,width,height,link,created_time,updated_time,name",album.uid];
}

- (NSArray*) getItemsFromJson:(NSDictionary*)json
{
	NSMutableArray * pictures=[[[NSMutableArray alloc] init] autorelease];
	
	NSArray * a=[json objectForKey:@"data"];
	
	for (NSDictionary * d in a) {
		
		Picture   * picture=[[Picture alloc] init];
		
		picture.user=album.user;
		
		picture.uid=[d objectForKey:@"id"];
		
		picture.thumbnailURL=[d objectForKey:@"picture"];
		picture.imageURL=[d objectForKey:@"source"];
		
		picture.width=[[d objectForKey:@"width"] intValue];
		picture.height=[[d objectForKey:@"height"] intValue];
		
		picture.name=[d objectForKey:@"name"];
		picture.url=[d objectForKey:@"link"];
		picture.created_date=[self dateFromString:[d objectForKey:@"created_time"]];
		picture.updated_date=[self dateFromString:[d objectForKey:@"updated_time"]];
		 
		[pictures addObject:picture];
		
		[picture release];
	}
	
	return pictures;	
}

- (void) dealloc
{
	[album release];
	[super dealloc];
}

@end
