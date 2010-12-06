//
//  FacebookAlbumPictureFeed.m
//  PhotoExplorer
//
//  Created by Robert Stewart on 12/6/10.
//  Copyright 2010 Evernote. All rights reserved.
//

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
	return [NSString stringWithFormat:@"%@/photos?fields=id,from,source,link,created_time,updated_time,name",album.uid];
}

- (NSArray*) getItemsFromJson:(NSDictionary*)json
{
	NSMutableArray * pictures=[[[NSMutableArray alloc] init] autorelease];
	NSLog(@"json=%@",[json description]);
	
	NSArray * a=[json objectForKey:@"data"];
	
	for (NSDictionary * d in a) {
		
		Picture   * picture=[[Picture alloc] init];
		
		picture.user=album.user;
		
		picture.uid=[d objectForKey:@"id"];
		
		picture.imageURL=[d objectForKey:@"source"];
		 
		picture.name=[d objectForKey:@"name"];
		picture.url=[d objectForKey:@"link"];
		picture.created_date=[NSDate date];
		picture.updated_date=[NSDate date];
		 
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
