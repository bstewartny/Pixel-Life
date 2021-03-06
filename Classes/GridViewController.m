#import "GridViewController.h"
#import "PixelLifeAppDelegate.h"
#import "Reachability.h"
#import "Feed.h"
#import "GridViewCell.h"

@implementation GridViewController
@synthesize gridView;

- (CGPoint) spinningWheelCenter
{
	return self.gridView.center;
}

- (id)initWithFeed:(Feed*)theFeed title:(NSString*)title
{
	if([[[UIApplication sharedApplication] delegate] isPhone])
	{
		self=[super initWithFeed:theFeed title:title withNibName:@"PhoneGridView"];
	}
	else 
	{
		self=[super initWithFeed:theFeed title:title withNibName:@"GridView"];
	}

	
    if(self)
	{
		self.gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		self.gridView.autoresizesSubviews = YES;
		self.gridView.delegate = self;
		self.gridView.dataSource = self;
		self.gridView.separatorStyle = AQGridViewCellSeparatorStyleEmptySpace;
		self.gridView.separatorColor = [UIColor blackColor];
		self.gridView.backgroundColor=[UIColor blackColor];
    }
    return self;
}

- (void) reloadData
{
	[gridView reloadData];
	[gridView updateVisibleGridCellsNow];
	[self loadVisibleCells];
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	[self loadVisibleCells]; 
}
/*
- (IBAction) shuffle
{
    NSMutableArray * sourceArray = [items mutableCopy];
    NSMutableArray * destArray = [[NSMutableArray alloc] initWithCapacity: [sourceArray count]];
    
    [self.gridView beginUpdates];
    
    srandom( time(NULL) );
	while ( [sourceArray count] != 0 )
	{
		NSUInteger index = (NSUInteger)(random() % [sourceArray count]);
		id item = [sourceArray objectAtIndex: index];
			
		// queue the animation
		[self.gridView moveItemAtIndex: [items indexOfObject: item]
								toIndex: [destArray count]
						 withAnimation: AQGridViewItemAnimationFade];

		// modify source & destination arrays
		[destArray addObject: item];
		[sourceArray removeObjectAtIndex: index];
	}

	[items release];
	items = [destArray copy];
	 
	[self.gridView endUpdates];
	
	[self loadVisibleCells];
}
*/
- (AQGridViewCell *) gridView: (AQGridView *) aGridView cellForItemAtIndex: (NSUInteger) index
{
	// subclass
	return nil;
}
 
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView; 
{
	NSLog(@"scrollViewDidEndDecelerating");
	NSLog(@"calling loadvisiblecells");
    // Method is called when the decelerating comes to a stop.
    // Pass visible cells to the cell loading function. If possible change 
    // scrollView to a pointer to your table cell to avoid compiler warnings
    [self loadVisibleCells]; 
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
{
    //if (!decelerate) 
    //{
	//NSLog(@"scrollViewDidEndDragging");
	//NSLog(@"calling loadvisiblecells");
        [self loadVisibleCells]; 
    //}
}
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
	//[self loadVisibleCells];
///}
- (CGSize) portraitGridCellSizeForGridView: (AQGridView *) aGridView
{
    return ( CGSizeMake(168.0, 168.0) );
}

- (NSUInteger) numberOfItemsInGridView: (AQGridView *) aGridView
{
    return ( [items count] );
}

- (void) loadVisibleCells
{
	for(GridViewCell * cell in [gridView visibleCells])
	{
		[cell load];
	}
}

- (void)dealloc {
	[gridView release];
	[super dealloc];
}


@end
