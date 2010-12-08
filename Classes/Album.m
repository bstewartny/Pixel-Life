//
//  Album.m
//  PhotoExplorer
//
//  Created by Robert Stewart on 12/5/10.
//  Copyright 2010 Evernote. All rights reserved.
//

#import "Album.h"
#import "Feed.h"
#import "Picture.h"

@implementation Album
@synthesize pictureFeed,picture;
@synthesize description;
@synthesize location;
@synthesize count;


- (void) dealloc
{
	[picture release];
	[pictureFeed release];
	[description release];
	[location release];
	[super dealloc];
}
@end
