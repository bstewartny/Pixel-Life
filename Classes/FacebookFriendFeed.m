#import "FacebookFriendFeed.h"
#import "FBConnect.h"
#import "JSON.h"
#import "Friend.h"
#import "Picture.h"
#import "FacebookFriendAlbumFeed.h"
#import "ASIHTTPRequest.h"

@implementation FacebookFriendFeed

- (ASIHTTPRequest*)createFetchRequest
{
	NSString * friend_query=@"SELECT uid,first_name,last_name,middle_name,name,pic_big,pic_small,pic,birthday_date FROM user WHERE uid in (select uid2 from friend where uid1=me())";
	
	NSString * escaped_query=[self escapeQueryValue:friend_query];
	
	NSString* escaped_token = [self escapeQueryValue:facebook.accessToken];
	
	NSString * url=[NSString stringWithFormat:@"https://api.facebook.com/method/fql.query?format=JSON&access_token=%@&query=%@",escaped_token,escaped_query];

	ASIHTTPRequest * request=[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
	
	request.requestMethod=@"GET";
	
	return request;
}

- (NSArray*) getItemsFromJson:(NSDictionary*)json
{
	NSMutableArray * friends=[[[NSMutableArray alloc] init] autorelease];
	
	for (NSDictionary * d in json) {
		
		Friend * friend=[[Friend alloc] init];
		
		friend.uid=[d objectForKey:@"uid"];
		friend.name=[d objectForKey:@"name"];
		friend.first_name=[d objectForKey:@"first_name"];
		friend.last_name=[d objectForKey:@"last_name"];
		
		Picture * picture=[[Picture alloc] init];
		
		picture.thumbnailURL=[d objectForKey:@"pic"];
		
		picture.imageURL=[d objectForKey:@"pic_big"];
		
		if(picture.imageURL==nil)
		{
			picture.imageURL=picture.thumbnailURL;
		}
		
		picture.user=friend;
		
		if([friend.first_name length]>0)
		{
			picture.name=friend.first_name;
			picture.description=friend.last_name;
		}
		else 
		{
			picture.description=friend.name;
		}
		
		FacebookFriendAlbumFeed * albumFeed=[[FacebookFriendAlbumFeed alloc] initWithFacebook:facebook friend:friend];
		
		friend.albumFeed=albumFeed;
		
		[albumFeed release];
		
		friend.picture=picture;
		
		[picture release];
		
		[friends addObject:friend];
		
		[friend release];
	}
	
	// sort alphabetically by name...
	// sort by last name then first name...
	[friends sortUsingSelector:@selector(compareFriend:)];
	
	return friends;
}

- (NSArray*) getItemsFromJsonOLD:(NSDictionary*)json
{
	NSMutableArray * friends=[[[NSMutableArray alloc] init] autorelease];
	
	NSArray * a=[json objectForKey:@"data"];
	
	for (NSDictionary * d in a) {
		
		Friend * friend=[[Friend alloc] init];
		
		friend.uid=[d objectForKey:@"id"];
		friend.name=[d objectForKey:@"name"];
		friend.first_name=[d objectForKey:@"first_name"];
		friend.last_name=[d objectForKey:@"last_name"];
		
		Picture * picture=[[Picture alloc] init];
		
		picture.thumbnailURL=[d objectForKey:@"picture"];
		
		picture.user=friend;
		
		if([friend.first_name length]>0)
		{
			picture.name=friend.first_name;
			picture.description=friend.last_name;
		}
		else 
		{
			picture.description=friend.name;
		}
		
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
