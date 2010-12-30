//
//  FacebookAccountInfoFeed.m
//  PhotoExplorer
//
//  Created by Robert Stewart on 12/29/10.
//  Copyright 2010 Evernote. All rights reserved.
//

#import "FacebookAccountInfoFeed.h"
#import "FacebookAccount.h"
@implementation FacebookAccountInfoFeed

- (NSString*) graphPath
{
	return @"me?fields=id,name,first_name,last_name,picture";
}

- (NSArray*) getItemsFromJson:(NSDictionary*)json
{
	if(![json isKindOfClass:[NSDictionary class]])
	{
		NSLog(@"json object is not a dictionary: %@",[json description]);
		return nil;
	}
	
	account.name=[json objectForKey:@"name"];
	
	return [NSMutableArray arrayWithObject:account];
}

@end
