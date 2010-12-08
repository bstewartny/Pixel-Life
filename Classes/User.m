//
//  User.m
//  PhotoExplorer
//
//  Created by Robert Stewart on 12/6/10.
//  Copyright 2010 Evernote. All rights reserved.
//

#import "User.h"

@implementation User
@synthesize uid,name;

- (void) dealloc
{
	[uid release];
	[name release];
	[super dealloc];
}
@end
