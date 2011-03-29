#import "FacebookRecentPictureFeed.h"
#import "ASIHTTPRequest.h"
#import "FBConnect.h"
#import "JSON.h"
#import "Album.h"
#import "Friend.h"
#import "Picture.h"
#import "Comment.h"
#import "FacebookAccount.h"
#import "MutableInt.h"

@implementation FacebookRecentPictureFeed

- (ASIHTTPRequest*)createFetchRequest
{
	NSMutableDictionary * queries=[[NSMutableDictionary alloc] init];
	
	[queries setObject:@"SELECT pid,created,src_small,src_big,object_id,owner,caption FROM photo WHERE aid IN ( SELECT aid FROM album WHERE owner in (select uid1 from friend where uid2=me()) order by modified_major desc ) ORDER BY created DESC LIMIT 100" forKey:@"photos"];
	[queries setObject:@"SELECT post_fbid, fromid, object_id, text, time from comment where object_id in (select object_id from #photos)" forKey:@"comments"];
	[queries setObject:@"select uid,first_name,last_name,name,pic,pic_big from user where uid in (select owner from #photos)" forKey:@"users"];
	
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

	NSArray * photos_results;
	NSArray * users_results;
	NSArray * comments_results;
	
	for (NSDictionary * result in json)
	{
		NSString * name =[result objectForKey:@"name"];
		NSArray * results=[result objectForKey:@"fql_result_set"];
		
		if ([name isEqualToString:@"photos"]) 
		{
			photos_results=results;
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
		 
	NSMutableArray * pictures=[[[NSMutableArray alloc] init] autorelease];
	
	for(NSDictionary * photo in photos_results)
	{
		 Friend * friend=[[Friend alloc] init];
		 
		 friend.uid=[photo objectForKey:@"owner"];
		 
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
		 
		 Picture   * picture=[[Picture alloc] init];
		 
		 picture.user=friend;
		 
		 [friend release];
		 
		 picture.uid=[[photo objectForKey:@"object_id"] stringValue];
		 picture.thumbnailURL=[photo objectForKey:@"src_small"];
		 picture.imageURL=[photo objectForKey:@"src_big"];
		 picture.width=[[photo objectForKey:@"src_big_width"] intValue];
		 picture.height=[[photo objectForKey:@"src_big_height"] intValue];
		 
		 picture.name=[photo objectForKey:@"caption"];
		 
		 picture.created_date=[NSDate dateWithTimeIntervalSince1970:[[photo objectForKey:@"created"] longValue]];
		 //picture.updated_date=picture.created_date; //updated_date
		 
		 picture.short_created_date=[self stringFromDate:picture.created_date];
		 
		 MutableInt * commentCount=[comment_map objectForKey:picture.uid];
		 
		 if(commentCount)
		 {
			 picture.commentCount=[commentCount intValue];
		 }
		 
		 
		if(picture.commentCount>0)
		  {
		  if(picture.commentCount==1)
		  {
			  picture.description=@"1 comment";
		  }
		  else 
		  {
			  picture.description=[NSString stringWithFormat:@"%d comments",picture.commentCount];
		  }
		  }
		 
		 [pictures addObject:picture];
		 
		 [picture release];
	 
	 
	}
	
	[pictures sortUsingSelector:@selector(compare:)];
	
	[user_map release];
	[comment_map release];
	
	return pictures;
	
}


@end
