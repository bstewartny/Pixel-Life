//
//  TestPictureFeed.m
//  PhotoExplorer
//
//  Created by Robert Stewart on 12/4/10.
//  Copyright 2010 Evernote. All rights reserved.
//

#import "TestPictureFeed.h"
#import "Picture.h"
#import "User.h"

@implementation TestPictureFeed


- (void)fetch
{
	NSMutableArray * pictures=[[[NSMutableArray alloc] init] autorelease];
	
	for(int i=0;i<24;i++)
	{
		Picture * picture=[[Picture alloc] init];
		
		picture.imageURL=@"http://i.cdn.turner.com/cnn/2010/POLITICS/12/04/senate.tax.vote/story.senate.senatetv.jpg";
		picture.name=[NSString stringWithFormat:@"Picture %d",i ];
		picture.created_date=[NSDate date];
		
		User * user=[[User alloc] init];
		user.uid=@"123456";
		user.name=@"Bob Stewart";
		
		picture.user=user;
		[user release];
		
		
		[pictures addObject:picture];
		[picture release];
	}
	
	if([delegate respondsToSelector:@selector(feed:didFindItems:)])
    {
        [delegate feed:self didFindItems:pictures];
    }
}
@end
