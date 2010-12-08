//
//  Item.m
//  PhotoExplorer
//
//  Created by Robert Stewart on 12/6/10.
//  Copyright 2010 Evernote. All rights reserved.
//

#import "Item.h"
#import "User.h"

@implementation Item
@synthesize uid;
@synthesize url;
@synthesize name;
@synthesize user;
@synthesize created_date;
@synthesize updated_date;

- (void) dealloc
{
	[uid release];
	[url release];
	[name release];
	[user release];
	[created_date release];
	[updated_date release];
	[super dealloc];
}



@end
