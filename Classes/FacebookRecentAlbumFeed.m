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

@implementation FacebookRecentAlbumFeed

- (ASIHTTPRequest*)createFetchRequest
{
	NSMutableDictionary * queries=[[NSMutableDictionary alloc] init];
	
	//[queries setObject:@"SELECT pid,created,src_small,src_big,object_id,owner,caption FROM photo WHERE aid IN ( SELECT aid FROM album WHERE owner in (select uid1 from friend where uid2=me()) order by modified_major desc ) ORDER BY created DESC LIMIT 100" forKey:@"photos"];
	[queries setObject:@"SELECT aid,owner,cover_pid,name,created,modified,modified_major,size,object_id,description FROM album WHERE owner in (select uid1 from friend where uid2=me()) order by modified_major desc LIMIT 100" forKey:@"albums"];
	
	[queries setObject:@"SELECT post_fbid, fromid, object_id, text, time from comment where object_id in (select object_id from #albums)" forKey:@"comments"];
	[queries setObject:@"select uid,first_name,last_name,name,pic,pic_big from user where uid in (select owner from #albums)" forKey:@"users"];
	
	NSString * escaped_queries=[self escapeQueryValue:[queries JSONFragment]];
	
	[queries release];
	
	NSString* escaped_token = [self escapeQueryValue:account.accessToken];
	
	NSString * url=[NSString stringWithFormat:@"https://api.facebook.com/method/fql.multiquery?queries=%@&access_token=%@&format=JSON",escaped_queries,escaped_token];
	
	ASIHTTPRequest * request=[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
	//[request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
	//[request setSecondsToCache:60*60*24*3]; // Cache for 3 days
	
	request.requestMethod=@"GET";
	
	return request;
}

- (NSArray*) getItemsFromJson:(NSDictionary*)json
{
	if(![json isKindOfClass:[NSArray class]])
	{
		//NSLog(@"json object is not a dictionary: %@",[json description]);
		return nil;
	}
	
	NSArray * albums_results;
	NSArray * users_results;
	NSArray * comments_results;
	
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
		if ([name isEqualToString:@"comments"]) 
		{
			comments_results=results;
		}
	}
	
	// create map of owner to user...
	NSMutableDictionary * user_map=[[NSMutableDictionary alloc] init];
	
	for(NSDictionary * user in users_results)
	{
		[user_map setObject:user forKey:[[user objectForKey:@"uid"] stringValue]];
	}
	
	// create map of photo id to comments
	
	NSMutableDictionary * comment_map=[[NSMutableDictionary alloc] init];
	
	for(NSDictionary * comment in comments_results)
	{
		NSString * object_id=[[comment objectForKey:@"object_id"] stringValue];
		
		MutableInt * commentCount=[comment_map objectForKey:object_id];
		
		if(commentCount)
		{
			[commentCount incValue];
			
		}
		else 
		{
			commentCount=[[MutableInt alloc] init];
			
			[comment_map setObject:commentCount forKey:object_id];
			
			[commentCount release];
		}
	}
	
	NSMutableArray * albums=[[[NSMutableArray alloc] init] autorelease];
	
	for(NSDictionary * photo in albums_results)
	{
		Friend * friend=[[Friend alloc] init];
		
		friend.uid=[[photo objectForKey:@"owner"] stringValue];
		
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
		album.description=[photo objectForKey:@"name"];
		
		//album.name=[photo objectForKey:@"name"];
		//album.description=[photo objectForKey:@"description"];
		
		album.created_date=[NSDate dateWithTimeIntervalSince1970:[[photo objectForKey:@"modified_major"] longValue]];
		album.short_created_date=[self stringFromDate:album.created_date];
		
		[friend release];
		
		album.uid=[[photo objectForKey:@"object_id"] stringValue];
		 
		Picture   * picture=[[Picture alloc] init];
		
		// TODO: how to get the most recent photo in the album?
		
		picture.thumbnailURL=[self createGraphUrl:[NSString stringWithFormat:@"%@/picture",album.uid]];
		//picture.thumbnailURL=[[album.user picture] thumbnailURL];
		//picture.imageURL=[[album.user picture] imageURL];
		
		picture.name=album.name;
		
		album.count=[[photo objectForKey:@"size"] intValue];
		
		
		 
		picture.description=album.description; //[NSString stringWithFormat:@"%d photos",album.count];
		picture.created_date=album.created_date;
		picture.short_created_date=[NSString stringWithFormat:@"Updated: %@",album.short_created_date];
		
		album.picture=picture;
		
		[picture release];
		
		FacebookAlbumPictureFeed * pictureFeed=[[FacebookAlbumPictureFeed alloc] initWithFacebookAccount:account album:album];
		
		album.pictureFeed=pictureFeed;
		
		[pictureFeed release];
		
		MutableInt * commentCount=[comment_map objectForKey:album.uid];
		
		if(commentCount)
		{
			album.commentCount=[commentCount intValue];
		}
		
		[albums addObject:album];
		
		[album release];
	
	}
	
	[albums sortUsingSelector:@selector(compare:)];
	
	[user_map release];
	[comment_map release];
	
	return albums;
	
}


@end
