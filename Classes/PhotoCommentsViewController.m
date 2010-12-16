#import "PhotoCommentsViewController.h"
#import "PhotoExplorerAppDelegate.h"
#import "Reachability.h"
#import "Feed.h"
#import "CommentTableViewCell.h"

@implementation PhotoCommentsViewController
@synthesize tableView,items,feed;





- (id)initWithFeed:(Feed*)feed title:(NSString*)title
{
    if(self=[super initWithNibName:@"PhotoCommentsView" bundle:nil])
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
		
		self.view.opaque=NO;
		self.view.backgroundColor=[UIColor blackColor];
		self.view.alpha=0.8;
		
		self.tableView.backgroundColor=[UIColor blackColor];
		self.tableView.alpha=0.8;
		self.tableView.opaque=NO;
    }
    return self;
}
- (IBAction) close:(id)sender
{
	[[self parentViewController] dismissModalViewControllerAnimated:YES]; 
}
- (void) reloadTable
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
	[tableView reloadData];
	//[gridView updateVisibleGridCellsNow];
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
    
    [self.tableView reloadData];
}

- (void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	if([items count]==0)
	{
		[self reloadTable];
	}
}

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation
{
    return YES;
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	[self loadVisibleCells]; 
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
- (void) loadVisibleCells
{
	for(CommentTableViewCell * cell in [tableView visibleCells])
	{
		[cell load];
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	Comment * comment=[items objectAtIndex:indexPath.row];
	static NSString * cellIdentifier = @"CommentTableViewCellIdentifier";
	
	CommentTableViewCell * cell=(CommentTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if(cell==nil)
	{
		NSArray * topLevelObjects=[[NSBundle mainBundle] loadNibNamed:@"CommentTableViewCell" owner:nil options:nil];
		
		for(id currentObject in topLevelObjects)
		{
			if([currentObject isKindOfClass:[UITableViewCell class]])
			{
				cell=(CommentTableViewCell*)currentObject;
				break;
			}
		}
		
		if(cell==nil)
		{
			NSLog(@"Failed to find table view cell in NIB!!!");
		}
	}
	
	cell.comment=comment;
	
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [items count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 80.0;
}

- (void)dealloc {
	[feed setDelegate:nil];
	[feed release];
	[items release];
	[tableView release];
	[spinningWheel release];
    [super dealloc];
}


@end
