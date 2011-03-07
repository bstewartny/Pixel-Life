#import "FriendListsGridViewController.h"
#import "FriendList.h"
#import "FriendListGridViewCell.h"
#import "FriendsGridViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation FriendListsGridViewController

- (NSString*) noDataMessage
{
	return @"No friend lists. You can create lists on Facebook.";
}

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

- (void) viewWillAppear:(BOOL)animated
{
	
	
 if([self.navigationItem.titleView isKindOfClass:[UISegmentedControl class]])
 {
 UISegmentedControl * sc=[(UISegmentedControl*)self.navigationItem.titleView retain];
 [sc sizeToFit];
 self.navigationItem.titleView=nil;
 self.navigationItem.titleView=sc;
 [sc release];
 
 /*CGRect frame=self.navigationItem.titleView.frame;
 frame.size.width=300;
 self.navigationItem.titleView.frame=frame;*/

}
	
	[super viewWillAppear:animated];
}
- (void) gridView: (AQGridView *) gridView didSelectItemAtIndex: (NSUInteger) index
{
	if(index<0 || index>([items count]-1))
	{
		// some bug in grid view allows bogus selections sometimes...
		return;
	}
	FriendList  * list=(FriendList*)[items objectAtIndex:index];
		
	FriendsGridViewController * controller=[[FriendsGridViewController alloc] initWithFeed:list.friendFeed title:list.name];
	
	[[self navigationController] pushViewController:controller animated:YES];
	
	[controller release];
}

@end