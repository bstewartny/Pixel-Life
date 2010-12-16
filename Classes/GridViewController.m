#import "GridViewController.h"
#import "PhotoExplorerAppDelegate.h"
#import "Reachability.h"
#import "Feed.h"
#import "GridViewCell.h"

@implementation GridViewController
@synthesize gridView,items,feed;

- (id)initWithFeed:(Feed*)feed title:(NSString*)title
{
    if(self=[super initWithNibName:@"GridView" bundle:nil])
	{
		self.feed=feed;
		self.feed.delegate=self;
		self.navigationItem.title=title;
		self.title=title;
		
		CGRect bounds=[[UIScreen mainScreen] bounds];
		
		spinningWheel = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(bounds.size.width/2-10, bounds.size.height/2-10, 20.0, 20.0)];
		spinningWheel.contentMode=UIViewContentModeCenter;
		spinningWheel.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
		spinningWheel.autoresizingMask=
					UIViewAutoresizingFlexibleLeftMargin |  
					UIViewAutoresizingFlexibleRightMargin  |
					UIViewAutoresizingFlexibleTopMargin   |
					UIViewAutoresizingFlexibleBottomMargin;
		
		spinningWheel.hidesWhenStopped=YES;
		[spinningWheel stopAnimating];
		
		[self.view addSubview:spinningWheel];
	
    }
    return self;
}

- (void)reloadGrid
{
	// Check if the remote server is available
    Reachability *reachManager = [Reachability reachabilityWithHostName:@"www.facebook.com"];
    PhotoExplorerAppDelegate *appDelegate = [PhotoExplorerAppDelegate sharedAppDelegate];
	NetworkStatus remoteHostStatus = [reachManager currentReachabilityStatus];
    if (remoteHostStatus == NotReachable)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        NSString *msg = @"Facebook is not reachable! This requires Internet connectivity.";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Problem" 
                                                        message:msg 
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    else if (remoteHostStatus == ReachableViaWiFi)
    {
        [appDelegate.downloadQueue setMaxConcurrentOperationCount:4];
    }
    else if (remoteHostStatus == ReachableViaWWAN)
    {
        [appDelegate.downloadQueue setMaxConcurrentOperationCount:NSOperationQueueDefaultMaxConcurrentOperationCount];
    }
    
    [self showLoadingView];
	[feed fetch];
}

- (void)feed:(Feed *)feed didFindItems:(NSArray *)items 
{
	self.items=items;
	[gridView reloadData];
	[gridView updateVisibleGridCellsNow];
	[self loadVisibleCells];
	[self hideLoadingView];
}

- (void)feed:(Feed *)feed didFailWithError:(NSString *)errorMsg
{
	NSLog(@"didFailWithError: %@",errorMsg);
    [self hideLoadingView];
}

- (void)showLoadingView
{
	[spinningWheel startAnimating];
	[self.view bringSubviewToFront:spinningWheel];
}

- (void)hideLoadingView
{
	[spinningWheel stopAnimating];
	[self.view sendSubviewToBack:spinningWheel];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    self.gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	self.gridView.autoresizesSubviews = YES;
	self.gridView.delegate = self;
	self.gridView.dataSource = self;
    
	self.gridView.separatorStyle = AQGridViewCellSeparatorStyleEmptySpace;
	self.gridView.resizesCellWidthToFit = NO;
	self.gridView.separatorColor = nil;
	self.gridView.backgroundColor=[UIColor blackColor];
	
    [self.gridView reloadData];
}

- (void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	if([items count]==0)
	{
		[self reloadGrid];
	}
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation
{
    return YES;
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	[self loadVisibleCells]; 
}

- (IBAction) shuffle
{
    //NSMutableArray * sourceArray = [_imageNames mutableCopy];
    //NSMutableArray * destArray = [[NSMutableArray alloc] initWithCapacity: [sourceArray count]];
    
    [self.gridView beginUpdates];
    
    /*srandom( time(NULL) );
	 while ( [sourceArray count] != 0 )
	 {
	 NSUInteger index = (NSUInteger)(random() % [sourceArray count]);
	 id item = [sourceArray objectAtIndex: index];
	 
	 // queue the animation
	 [self.gridView moveItemAtIndex: [_imageNames indexOfObject: item]
	 toIndex: [destArray count]
	 withAnimation: AQGridViewItemAnimationFade];
	 
	 // modify source & destination arrays
	 [destArray addObject: item];
	 [sourceArray removeObjectAtIndex: index];
	 }
	 
	 [_imageNames release];
	 _imageNames = [destArray copy];
	 */
    [self.gridView endUpdates];
   
}


- (AQGridViewCell *) gridView: (AQGridView *) aGridView cellForItemAtIndex: (NSUInteger) index
{
	// subclass
	return nil;
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
	[items release];
    [feed setDelegate:nil];
    [feed release];
	[gridView release];
	[spinningWheel release];
    [super dealloc];
}


@end
