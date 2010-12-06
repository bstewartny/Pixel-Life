    //
//  GridViewController.m
//  PhotoExplorer
//
//  Created by Robert Stewart on 12/5/10.
//  Copyright 2010 Evernote. All rights reserved.
//

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
    }
    return self;
}

- (void)reloadGrid
{
	NSLog(@"reloadGrid");
    // Check if the remote server is available
    Reachability *reachManager = [Reachability reachabilityWithHostName:@"www.facebook.com"];
    PhotoExplorerAppDelegate *appDelegate = [PhotoExplorerAppDelegate sharedAppDelegate];
	// [reachManager setHostName:@"www.facebook.com"];
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
	NSLog(@"didFindPictures");
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
	NSLog(@"showLoadingView");
	
    if (loadingView == nil)
    {
        loadingView = [[UIView alloc] initWithFrame:self.view.bounds];
        //loadingView.opaque = NO;
        loadingView.backgroundColor = [UIColor blackColor];
        //loadingView.alpha = 0.5;
		
        UIActivityIndicatorView *spinningWheel = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2-20, self.view.bounds.size.height/2-20, 37.0, 37.0)];
        [spinningWheel startAnimating];
        spinningWheel.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [loadingView addSubview:spinningWheel];
        [spinningWheel release];
    }
    
    [self.view addSubview:loadingView];
}

- (void)hideLoadingView
{
	NSLog(@"hideLoadingView");
    [loadingView removeFromSuperview];
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
	
	[self reloadGrid];
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

- (void) viewDidUnload
{
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
    self.gridView = nil;
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
    
    //[sourceArray release];
    //[destArray release];
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
    return ( CGSizeMake(224.0, 168.0) );
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}
 

- (NSUInteger) numberOfItemsInGridView: (AQGridView *) aGridView
{
    return ( [items count] );
}

- (void) loadVisibleCells
{
	NSLog(@"loadVisibleCells");
	for(GridViewCell * cell in [gridView visibleCells])
	{
		NSLog(@"[cell loadImage]");
		[cell load];
	}
}

- (void)dealloc {
	[items release];
    [feed setDelegate:nil];
    [feed release];
	[gridView release];
    [super dealloc];
}


@end
