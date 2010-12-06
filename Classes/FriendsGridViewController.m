//
//  FriendsGridViewController.m
//  PhotoExplorer
//
//  Created by Robert Stewart on 12/6/10.
//  Copyright 2010 Evernote. All rights reserved.
//

#import "FriendsGridViewController.h"
#import "Friend.h"
#import "PhotoGridViewCell.h"
#import "AlbumsGridViewController.h"

@implementation FriendsGridViewController

- (AQGridViewCell *) gridView: (AQGridView *) aGridView cellForItemAtIndex: (NSUInteger) index
{
    static NSString * cellIdentifier = @"CellIdentifier";
	
    PhotoGridViewCell * photoCell = (PhotoGridViewCell *)[aGridView dequeueReusableCellWithIdentifier: cellIdentifier];
	if ( photoCell == nil )
	{
		photoCell = [[[PhotoGridViewCell alloc] initWithFrame: CGRectMake(0.0, 0.0, 200.0, 150.0)
											  reuseIdentifier: cellIdentifier] autorelease];
		photoCell.selectionStyle = AQGridViewCellSelectionStyleBlueGray;
	}
	
	Friend  * friend=(Friend*)[items objectAtIndex:index];
	photoCell.picture=[friend picture];
	
	
	
	return photoCell;
}

- (void) gridView: (AQGridView *) gridView didSelectItemAtIndex: (NSUInteger) index
{
	Friend  * friend=(Friend*)[items objectAtIndex:index];
	// show album...
	
	 
	AlbumsGridViewController * controller=[[AlbumsGridViewController alloc] initWithFeed:friend.albumFeed title:[NSString stringWithFormat:@"%@'s Albums",friend.name]];
	
	[[self navigationController] pushViewController:controller animated:YES];
	
	[controller release];
}


@end
