#import "FacebookFriendListFriendFeed.h"
#import "FriendList.h"
#import "FBConnect.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"

@implementation FacebookFriendListFriendFeed
@synthesize friendList;

- (id) initWithFacebook:(Facebook*)facebook friendList:(FriendList*)friendList
{
	self=[super initWithFacebook:facebook];
	if (self==nil) {
		return nil;
	}
	self.friendList=friendList;
	return self;
}

- (ASIHTTPRequest*)createFetchRequest
{
	NSLog(@"createFetchRequest");
	
	NSString * friend_query=[NSString stringWithFormat:@"SELECT uid,first_name,last_name,middle_name,name,pic_big,pic_small,pic,birthday_date FROM user WHERE uid in (SELECT uid FROM friendlist_member WHERE flid = %@)",friendList.uid];
	
	NSString * escaped_query=[self escapeQueryValue:friend_query];
	
	NSString* escaped_token = [self escapeQueryValue:facebook.accessToken];
	
	NSString * url=[NSString stringWithFormat:@"https://api.facebook.com/method/fql.query?format=JSON&access_token=%@&query=%@",escaped_token,escaped_query];
	
	ASIHTTPRequest * request=[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
	
	request.requestMethod=@"GET";
	
	return request;
}

- (void) dealloc
{
	[friendList release];
	[super dealloc];
}

@end
