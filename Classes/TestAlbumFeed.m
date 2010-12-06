//
//  TestAlbumFeed.m
//  PhotoExplorer
//
//  Created by Robert Stewart on 12/6/10.
//  Copyright 2010 Evernote. All rights reserved.
//

#import "TestAlbumFeed.h"
#import "Album.h"
#import "Picture.h"
#import "TestPictureFeed.h"
#import "User.h"

@implementation TestAlbumFeed


- (void)fetch
{
	NSMutableArray * albums=[[[NSMutableArray alloc] init] autorelease];
	
	for(int i=0;i<24;i++)
	{
		Album * album=[[Album alloc] init];
		
		album.name=[NSString stringWithFormat:@"Album %d",i ];
		album.description=@"The album description.";
		album.created_date=[NSDate date];
		
		User * user=[[User alloc] init];
		user.uid=@"12345";
		user.name=@"Bob Stewart";
		
		album.user=user;
		
		[user release];
		
		
		Picture * picture=[[Picture alloc] init];
		
		picture.user=album.user;
		picture.imageURL=@"http://i.cdn.turner.com/cnn/2010/POLITICS/12/04/senate.tax.vote/story.senate.senatetv.jpg";
		picture.name=[NSString stringWithFormat:@"Album picture %d",i ];
		picture.created_date=[NSDate date];
		
		album.picture=picture;
		
		TestPictureFeed * pictureFeed=[[TestPictureFeed alloc] init];
		
		album.pictureFeed=pictureFeed;
		
		[pictureFeed release];
		 
		[picture release];
		
		[albums addObject:album];
		
		[album release];
	}
	
	if([delegate respondsToSelector:@selector(feed:didFindItems:)])
    {
        [delegate feed:self didFindItems:albums];
    }
}
@end

