//
//  Friend.m
//  PhotoExplorer
//
//  Created by Robert Stewart on 12/6/10.
//  Copyright 2010 Evernote. All rights reserved.
//

#import "Friend.h"
#import "Picture.h"
#import "Feed.h"

@implementation Friend

@synthesize first_name;
@synthesize last_name;
@synthesize url;
@synthesize about;
@synthesize birthday;
@synthesize location;
@synthesize albumFeed;
@synthesize picture;

- (void) dealloc
{
	[first_name release];
	[last_name release];
	[url release];
	[about release];
	[birthday release];
	[location release];
	[albumFeed release];
	[picture release];
	[super dealloc];
}

@end
