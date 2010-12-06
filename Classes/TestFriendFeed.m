//
//  TestFriendFeed.m
//  PhotoExplorer
//
//  Created by Robert Stewart on 12/6/10.
//  Copyright 2010 Evernote. All rights reserved.
//

#import "TestFriendFeed.h"
#import "Friend.h"
#import "Picture.h"
#import "Feed.h"
#import "TestAlbumFeed.h"

@implementation TestFriendFeed
- (void)fetch
{
	NSMutableArray * friends=[[[NSMutableArray alloc] init] autorelease];
	
	for(int i=0;i<1000;i++)
	{
		Friend  * friend=[[Friend alloc] init];
		
		friend.name=@"Sue Roth Stewart";
		friend.first_name=@"Sue";
		friend.last_name=@"Stewart";
		friend.birthday=[NSDate date];
		friend.about=@"Married to Bob Stewart";
		friend.uid=@"688152358";
		
		Picture * profile_pic=[[Picture alloc] init];
		profile_pic.imageURL=@"http://profile.ak.fbcdn.net/hprofile-ak-snc4/hs458.snc4/50109_688152358_53882_q.jpg";
		profile_pic.name=friend.name;
		profile_pic.user=friend;
		friend.picture=profile_pic;
		[profile_pic release];
		
		TestAlbumFeed * albumFeed=[[TestAlbumFeed alloc] init];
		
		friend.albumFeed=albumFeed;
		
		[albumFeed release];
		
		
		
		[friends addObject:friend];
		
		[friend release];
	}
	
	if([delegate respondsToSelector:@selector(feed:didFindItems:)])
    {
        [delegate feed:self didFindItems:friends];
    }
}

@end
