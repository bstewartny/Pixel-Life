#import "PictureTableViewController.h"
#import "PixelLifeAppDelegate.h"
#import "Reachability.h"
#import "Feed.h"
#import "Friend.h"
#import "PictureTableViewCell.h"
#import "Picture.h"

@implementation PictureTableViewController
@synthesize tableView,tabBar;

- (id)initWithFeed:(Feed*)feed title:(NSString*)title
{
    // subclass
	return nil;
}

- (void) setTabBar:(UITabBar*)t
{
	if(![t isEqual:tabBar])
	{
		BOOL needsTableFrameAdjusted=(tabBar==nil);
		
		[tabBar removeFromSuperview];
		[tabBar release];
		tabBar=[t retain];
		
		CGRect s=[[UIScreen mainScreen] bounds];
		
		
		if(needsTableFrameAdjusted)
		{
			CGRect t=tableView.frame;
			t.size.height=t.size.height-tabBar.frame.size.height;
			tableView.frame=t;
		}
		
		tabBar.frame=CGRectMake(0, (s.size.height-tabBar.frame.size.height)-20, s.size.width, tabBar.frame.size.height);
		
		
		[self.view addSubview:tabBar];
	}
}

- (void) reloadData
{
	[tableView reloadData];
	
	[self loadVisibleCells];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	[cell load];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView; 
{
    // Method is called when the decelerating comes to a stop.
    // Pass visible cells to the cell loading function. If possible change 
    // scrollView to a pointer to your table cell to avoid compiler warnings
    [self loadVisibleCells]; 
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
{
    if (!decelerate) 
    {
        [self loadVisibleCells]; 
    }
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	[self loadVisibleCells]; 
}

- (void) loadVisibleCells
{
	for(PictureTableViewCell * cell in [tableView visibleCells])
	{
		[cell load];
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [items count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	// subclass
	return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	//subclass
	return nil;
}

- (void)dealloc 
{
	[tabBar release];
	[tableView release];
    [super dealloc];
}

@end
