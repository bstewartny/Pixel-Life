#import "FacebookAlbumPictureFeed.h"
#import "ASIHTTPRequest.h"
#import "FBConnect.h"
#import "JSON.h"
#import "Album.h"
#import "Friend.h"
#import "Picture.h"
#import "Comment.h"

@implementation FacebookAlbumPictureFeed
@synthesize album;

- (id) initWithFacebookAccount:(FacebookAccount*)account album:(Album*)album
{
	self=[super initWithFacebookAccount:account];
	if (self==nil) {
		return nil;
	}
	self.album=album;
	return self;
}
- (NSString*) graphPath
{
	return [NSString stringWithFormat:@"%@/photos?limit=1000&fields=id,comments,picture,source,width,height,link,created_time,updated_time,name",album.uid];
}

- (NSArray*) getItemsFromJson:(NSDictionary*)json
{
	
	if(![json isKindOfClass:[NSDictionary class]])
	{
		//NSLog(@"json object is not a dictionary: %@",[json description]);
		return nil;
	}
	
	
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
		
		NSDate * updated_date=[self dateFromString:[d objectForKey:@"updated_time"]];
		if(updated_date)
		{
			picture.created_date=updated_date;
		}
		else 
		{
			picture.created_date=[self dateFromString:[d objectForKey:@"created_time"]];
		}

		picture.short_created_date=[self stringFromDate:picture.created_date];
		
		NSDictionary * comments_dict=[d objectForKey:@"comments"];
		
		if(comments_dict)
		{
			//NSMutableArray * comments=[[NSMutableArray alloc] init];
			NSArray * comments=[comments_dict objectForKey:@"data"];
			
			picture.commentCount=[comments count];
			/*
			for(NSDictionary * c in [comments_dict objectForKey:@"data"])
			{
		
				Comment * comment=[[Comment alloc] init];
				
				comment.uid=[c objectForKey:@"id"];
				comment.name=[c objectForKey:@"message"];
				comment.message=comment.name;
				
				comment.created_date=[self dateFromString:[c objectForKey:@"created_time"]];
				comment.updated_date=comment.created_date;
				
				User * user=[[User alloc] init];
				
				user.uid=[[c objectForKey:@"from"] objectForKey:@"id"];
				user.name=[[c objectForKey:@"from"] objectForKey:@"name"];
				
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
			
			picture.comments=comments;
			
			[comments release];*/
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
	
	
	
	return pictures;	
}

- (void) dealloc
{
	//[album release];
	[super dealloc];
}

@end
