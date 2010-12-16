#import "FriendListsGridViewController.h"
#import "FriendList.h"
#import "FriendListGridViewCell.h"
#import "FriendsGridViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation FriendListsGridViewController

- (AQGridViewCell *) gridView: (AQGridView *) aGridView cellForItemAtIndex: (NSUInteger) index
{
    static NSString * cellIdentifier = @"CellIdentifier";
	
	FriendListGridViewCell * photoCell = (FriendListGridViewCell *)[aGridView dequeueReusableCellWithIdentifier: cellIdentifier];
	if ( photoCell == nil )
	{
		photoCell = [[[FriendListGridViewCell alloc] initWithFrame: CGRectMake(0.0, 0.0, 170.0, 170.0)
											   reuseIdentifier: cellIdentifier] autorelease];
		
		photoCell.selectionStyle = AQGridViewCellSelectionStyleBlueGray;
	}
	
	FriendList  * list=(FriendList*)[items objectAtIndex:index];
	photoCell.picture=list.picture;
	
	return photoCell;
}

- (CGSize) portraitGridCellSizeForGridView: (AQGridView *) aGridView
{
	return ( CGSizeMake(170.0, 170.0) );
}

- (void) gridView: (AQGridView *) gridView didSelectItemAtIndex: (NSUInteger) index
{
	FriendList  * list=(FriendList*)[items objectAtIndex:index];
		
	FriendsGridViewController * controller=[[FriendsGridViewController alloc] initWithFeed:list.friendFeed title:list.name];
	
	[[self navigationController] pushViewController:controller animated:YES];
	
	[controller release];
}