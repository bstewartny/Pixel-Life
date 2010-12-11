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
#import "FriendGridViewCell.h"
#import "AlbumsGridViewController.h"
#import <QuartzCore/QuartzCore.h>
@implementation FriendsGridViewController

- (AQGridViewCell *) gridView: (AQGridView *) aGridView cellForItemAtIndex: (NSUInteger) index
{
    static NSString * cellIdentifier = @"CellIdentifier";
	
	CGFloat width=self.view.bounds.size.width;
	
	NSLog(@"cellForItemAtIndex: width=%f",width);

    FriendGridViewCell * photoCell = (FriendGridViewCell *)[aGridView dequeueReusableCellWithIdentifier: cellIdentifier];
	if ( photoCell == nil )
	{
		photoCell = [[[FriendGridViewCell alloc] initWithFrame: CGRectMake(0.0, 0.0, 192.0, 192.0)
											  reuseIdentifier: cellIdentifier] autorelease];
		
		photoCell.selectionStyle = AQGridViewCellSelectionStyleBlueGray;
	}
	
	Friend  * friend=(Friend*)[items objectAtIndex:index];
	photoCell.picture=friend.picture;
	
	
	
	return photoCell;
}

- (CGSize) portraitGridCellSizeForGridView: (AQGridView *) aGridView
{
	CGFloat width=self.view.bounds.size.width;
	NSLog(@"portraitGridCellSizeForGridView: width=%f",width);

    //return ( CGSizeMake(224.0, 168.0) );
	return ( CGSizeMake(192.0, 192.0) );
}

- (void) gridView: (AQGridView *) gridView didSelectItemAtIndex: (NSUInteger) index
{
	Friend  * friend=(Friend*)[items objectAtIndex:index];
	// show album...
	
	CATransition *transition = [CATransition animation];
	transition.duration = 0.5;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	transition.subtype = kCATransitionReveal;
	 
	AlbumsGridViewController * controller=[[AlbumsGridViewController alloc] initWithFeed:friend.albumFeed title:[NSString stringWithFormat:@"%@'s Albums",friend.name]];
	[controller.view.layer addAnimation:transition forKey:nil];
	
	[[self navigationController] pushViewController:controller animated:NO];
	
	[controller release];
}


@end
