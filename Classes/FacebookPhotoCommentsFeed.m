#import "FacebookPhotoCommentsFeed.h"
#import "Picture.h"
#import "FBConnect.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "User.h"
#import "Comment.h"

@implementation FacebookPhotoCommentsFeed
@synthesize picture;

- (id) initWithFacebook:(Facebook*)facebook picture:(Picture*)picture
{
	self=[super initWithFacebook:facebook];
	if (self==nil) {
		return nil;
	}
	self.picture=picture;
	return self;
}

- (NSString*) graphPath
{
	return [NSString stringWithFormat:@"%@/comments",self.picture.uid];
}

- (NSArray*) getItemsFromJson:(NSDictionary*)json
{
	if(![json isKindOfClass:[NSDictionary class]])
	{
		NSLog(@"json object is not a dictionary: %@",[json description]);
		return nil;
	}
	
	NSMutableArray * comments=[[[NSMutableArray alloc] init] autorelease];
	
	NSArray * a=[json objectForKey:@"data"];
	
	for (NSDictionary * d in a) {
		
		Comment * comment=[[Comment alloc] init];
		
		comment.uid=[d objectForKey:@"id"];
		comment.name=[d objectForKey:@"message"];
		comment.message=[d objectForKey:@"message"];
		comment.created_date=[self dateFromString:[d objectForKey:@"created_time"]];
		comment.updated_date=comment.created_date;
		
		User * user=[[User alloc] init];
		
		user.uid=[[d objectForKey:@"from"] objectForKey:@"id"];
		user.name=[[d objectForKey:@"from"] objectForKey:@"name"];
		
		comment.user=user;
		
		Picture * pic=[[Picture alloc] init];
		
		pic.name=user.name;
		pic.thumbnailURL=[self createGraphUrl:[NSString stringWithFormat:@"%@/picture",user.uid]];
		pic.imageURL=picture.thumbnailURL;
		
		comment.picture=pic;
		
		[pic release];
		
		[user release];
		
		[comments addObject:comment];
		
		[comment release];
	}
	
	return comments;	
}

- (void) dealloc
{
	//[picture release];
	[super dealloc];
}
@end
