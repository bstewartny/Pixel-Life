#import "FacebookRecentAlbumFeed.h"
#import "ASIHTTPRequest.h"
#import "FBConnect.h"
#import "JSON.h"
#import "Album.h"
#import "Friend.h"
#import "Picture.h"
#import "Comment.h"
#import "FacebookAccount.h"
#import "MutableInt.h"
#import "FacebookAlbumPictureFeed.h"
#import "User.h"
#import "MostRecentAlbumPicture.h"

@implementation FacebookRecentAlbumFeed

- (ASIHTTPRequest*)createFetchRequest
{
	NSMutableDictionary * queries=[[NSMutableDictionary alloc] init];
	
	[queries setObject:@"SELECT aid,owner,cover_pid,name,created,modified,size,object_id,description FROM album WHERE owner in (select uid1 from friend where uid2=me()) order by created desc LIMIT 40" forKey:@"albums"];
	 
	[queries setObject:@"select uid,first_name,last_name,name,pic,pic_big from user where uid in (select owner from #albums)" forKey:@"users"];
	
	NSString * escaped_queries=[self escapeQueryValue:[queries JSONFragment]];
	
	[queries release];
	
	NSString* escaped_token = [self escapeQueryValue:account.accessToken];
	
	NSString * url=[NSString stringWithFormat:@"https://api.facebook.com/method/fql.multiquery?queries=%@&access_token=%@&format=JSON",escaped_queries,escaped_token];
	
	ASIHTTPRequest * request=[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
	[request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
	[request setSecondsToCache:60*3]; // Cache for 3 minutes
	
	request.requestMethod=@"GET";
	
	return request;
}

- (NSArray*) getItemsFromJson:(NSDictionary*)json
{
	if(![json isKindOfClass:[NSArray class]])
	{
		NSLog(@"json object is not a dictionary: %@",[json description]);
		return nil;
	}
	
	NSArray * albums_results;
	NSArray * users_results;
	
	for (NSDictionary * result in json)
	{
		NSString * name =[result objectForKey:@"name"];
		NSArray * results=[result objectForKey:@"fql_result_set"];
		
		if ([name isEqualToString:@"albums"]) 
		{
			albums_results=results;
		}
		if ([name isEqualToString:@"users"]) 
		{
			users_results=results;
		}
	}
	
	// create map of owner to user...
	NSMutableDictionary * user_map=[[NSMutableDictionary alloc] init];
	
	for(NSDictionary * user in users_results)
	{
		[user_map setObject:user forKey:[[user objectForKey:@"uid"] stringValue]];
	}
	
	NSMutableArray * albums=[[[NSMutableArray alloc] init] autorelease];
	
	for(NSDictionary * album_result in albums_results)
	{
		Friend * friend=[[Friend alloc] init];
		
		friend.uid=[[album_result objectForKey:@"owner"] stringValue];
		
		NSDictionary * user=[user_map objectForKey:friend.uid];
		if(user)
		{
			friend.first_name=[user objectForKey:@"first_name"];
			friend.last_name=[user objectForKey:@"last_name"];
			friend.name=[user objectForKey:@"name"];
			
			Picture * friend_picture=[[Picture alloc] init];
			
			friend_picture.thumbnailURL=[user objectForKey:@"pic"];
			
			friend_picture.imageURL=[user objectForKey:@"pic_big"];
			
			if(friend_picture.imageURL==nil)
			{
				friend_picture.imageURL=friend_picture.thumbnailURL;
			}
			
			friend_picture.user=friend;
			
			if([friend.first_name length]>0)
			{
				friend_picture.name=friend.first_name;
				friend_picture.description=friend.last_name;
			}
			else 
			{
				friend_picture.description=friend.name;
			}
			
			friend.picture=friend_picture;
			
			[friend_picture release];
		}
		
		// lookup friend by uid?
		Album * album=[[Album alloc] init];
		
		album.user=friend;
	
		album.name=album.user.name;
		album.description=[album_result objectForKey:@"name"];
		
		album.created_date=[NSDate dateWithTimeIntervalSince1970:[[album_result objectForKey:@"modified"] longValue]];
		album.short_created_date=[self stringFromDate:album.created_date];
		
		[friend release];
		
		album.uid=[[album_result objectForKey:@"object_id"] stringValue];
		 
		MostRecentAlbumPicture   * picture=[[MostRecentAlbumPicture alloc] init];
		
		// TODO: how to get the most recent photo in the album?
		
		NSString * aid=[album_result objectForKey:@"aid"];
		
		picture.albumId=aid;
		picture.accessToken=account.accessToken;
		
		picture.name=album.name;
		
		album.count=[[album_result objectForKey:@"size"] intValue];
		
		picture.description=album.description; //[NSString stringWithFormat:@"%d photos",album.count];
		picture.created_date=album.created_date;
		picture.short_created_date=[NSString stringWithFormat:@"Updated: %@",album.short_created_date];
		
		album.picture=picture;
		
		[picture release];
		
		FacebookAlbumPictureFeed * pictureFeed=[[FacebookAlbumPictureFeed alloc] initWithFacebookAccount:account album:album];
		
		album.pictureFeed=pictureFeed;
		
		[pictureFeed release];
		
		[albums addObject:album];
		
		[album release];
	
	}
	
	[albums sortUsingSelector:@selector(compare:)];
	
	[user_map release];
	
	return albums;
	
}


@end
