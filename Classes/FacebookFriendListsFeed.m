#import "FacebookFriendListsFeed.h"
#import "FBConnect.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "FriendList.h"
#import "FacebookFriendListFriendFeed.h"
#import "Picture.h"
#import "User.h"

@implementation FacebookFriendListsFeed

- (NSString*) graphPath
{
	return @"me/friendlists?fields=id,name,members";
}

- (NSArray*) getItemsFromJson:(NSDictionary*)json
{
	if(![json isKindOfClass:[NSDictionary class]])
	{
		NSLog(@"json object is not a dictionary: %@",[json description]);
		return nil;
	}
	
	NSMutableArray * lists=[[[NSMutableArray alloc] init] autorelease];
	
	NSArray * a=[json objectForKey:@"data"];
	
	for (NSDictionary * d in a) {
		
		FriendList  * list=[[FriendList alloc] init];
		
		list.uid=[d objectForKey:@"id"];
		list.name=[d objectForKey:@"name"];
		
		Picture * picture=[[Picture alloc] init];
		
		picture.name=list.name;
		
		list.picture=picture;
		
		[picture release];
		
		NSArray * members=[[d objectForKey:@"members"] objectForKey:@"data"];
		
		list.count=[members count];
		
		picture.description=[NSString stringWithFormat:@"%d friends",list.count];
		
		// use first member as the picture
		if([members count]>0)
		{
			NSString * user_id=[[members objectAtIndex:0] objectForKey:@"id"];
			NSString * user_name=[[members objectAtIndex:0] objectForKey:@"name"];
			picture.thumbnailURL=[self createGraphUrl:[NSString stringWithFormat:@"%@/picture?type=large",user_id]];
			picture.imageURL=picture.thumbnailURL;
			User * user=[[User alloc] init];
			user.uid=user_id;
			user.name=user_name;
			picture.user=user;
			[user release];
		}
		else 
		{
			// Hmm... no picture to use for list then...
			NSLog(@"Friend list has no members...");
		}

		FacebookFriendListFriendFeed * friendFeed=[[FacebookFriendListFriendFeed alloc] initWithFacebook:facebook friendList:list];
		
		list.friendFeed=friendFeed;
		
		[friendFeed release];
		
		[lists addObject:list];
		
		[list release];
	}
	
	return lists;	
}

@end
