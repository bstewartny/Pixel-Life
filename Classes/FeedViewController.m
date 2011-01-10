#import "FeedViewController.h"
#import "Feed.h"
#import "PixelLifeAppDelegate.h"
#import "Reachability.h"
#import "FacebookAccount.h"

@implementation FeedViewController
@synthesize items,feed;

- (id)initWithFeed:(Feed*)feed title:(NSString*)title withNibName:(NSString*)nibName
{
    if(self=[super initWithNibName:nibName bundle:nil])
	{
		self.feed=feed;
		self.feed.delegate=self;
		self.navigationItem.title=title;
		self.title=title;
		self.view.backgroundColor=[UIColor blackColor];
		
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
- (void) refresh
{
	Reachability *reachManager = [Reachability reachabilityWithHostName:@"www.facebook.com"];
    //PixelLifeAppDelegate *appDelegate = [PixelLifeAppDelegate sharedAppDelegate];
	NetworkStatus remoteHostStatus = [reachManager currentReachabilityStatus];
    if (remoteHostStatus == NotReachable)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        NSString *msg = @"This app requires internet connectivity.";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook unreachable!" 
                                                        message:msg 
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
	if(feed)
	{
		[self showLoadingView];
	}
	[feed fetch];
}

- (void)reloadFeed
{
	if([items count]>0)
	{
		// already loaded...
		return;
	}
	
	// Check if the remote server is available
    Reachability *reachManager = [Reachability reachabilityWithHostName:@"www.facebook.com"];
    PixelLifeAppDelegate *appDelegate = [PixelLifeAppDelegate sharedAppDelegate];
	NetworkStatus remoteHostStatus = [reachManager currentReachabilityStatus];
    if (remoteHostStatus == NotReachable)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        NSString *msg = @"This app requires internet connectivity.";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook unreachable!" 
                                                        message:msg 
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        //return;
    }
    else if (remoteHostStatus == ReachableViaWiFi)
    {
        [appDelegate.downloadQueue setMaxConcurrentOperationCount:4];
    }
    else if (remoteHostStatus == ReachableViaWWAN)
    {
        [appDelegate.downloadQueue setMaxConcurrentOperationCount:NSOperationQueueDefaultMaxConcurrentOperationCount];
    }
    if(feed)
	{
		[self showLoadingView];
	}
	[feed fetch];
}

- (void)feed:(Feed *)feed didFindItems:(NSArray *)items 
{
	self.items=items;
	if([items count]==0)
	{
		[self showNoDataMessage];
	}
	else 
	{
		[self reloadData];
	}

	[self hideLoadingView];
}

- (void) showNoDataMessage
{
	//NSLog(@"showNoDataMessage");
	
	UILabel * label=[[UILabel alloc] initWithFrame:self.view.frame];
	label.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin    |
	UIViewAutoresizingFlexibleWidth         |
	UIViewAutoresizingFlexibleRightMargin  |
	UIViewAutoresizingFlexibleTopMargin    |
	UIViewAutoresizingFlexibleHeight       |
	UIViewAutoresizingFlexibleBottomMargin;
	label.textAlignment=UITextAlignmentCenter;
	label.numberOfLines=20;
	label.backgroundColor=[UIColor clearColor];
	label.textColor=[UIColor lightGrayColor];
	label.font=[UIFont boldSystemFontOfSize:20];
	
	Reachability *reachManager = [Reachability reachabilityWithHostName:@"www.facebook.com"];
    NetworkStatus remoteHostStatus = [reachManager currentReachabilityStatus];
    if (remoteHostStatus == NotReachable)
    {
		label.text= @"Facebook is unreachable.";
	}
	else
	{
		label.text=[self noDataMessage];
	}
	
	[self.view addSubview:label];
	[self.view bringSubviewToFront:label];
	[label release];
}

- (NSString*) noDataMessage
{
	
	Reachability *reachManager = [Reachability reachabilityWithHostName:@"www.facebook.com"];
    NetworkStatus remoteHostStatus = [reachManager currentReachabilityStatus];
    if (remoteHostStatus == NotReachable)
    {
		return @"Facebook is unreachable.";
	}
	
	
	return @"No data found for request.";
}

- (void) reloadData
{
	// subclass - reload table, etc.
}

- (void)feed:(Feed *)feed didFailWithError:(NSString *)errorMsg
{
	NSLog(@"didFailWithError: %@",errorMsg);
    [self hideLoadingView];
}

- (void)showLoadingView
{
	if(feed)
	{
		[spinningWheel startAnimating];
		[self.view bringSubviewToFront:spinningWheel];
	}
}

- (void)hideLoadingView
{
	[spinningWheel stopAnimating];
	[self.view sendSubviewToBack:spinningWheel];
}

- (void) viewWillAppear:(BOOL)animated
{
	self.navigationController.navigationBar.translucent=NO;
	[self.navigationController setNavigationBarHidden:NO animated:NO];
	[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
	spinningWheel.center=self.view.center;
	
	[super viewWillAppear:animated];
}

- (void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[self reloadFeed];
	[self reloadData];
	
	FacebookAccount * currentAccount=[PixelLifeAppDelegate sharedAppDelegate].currentAccount;
	if(![currentAccount isSessionValid])
	{
		[[PixelLifeAppDelegate sharedAppDelegate] login];
	}
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation
{
    return YES;
}
 
- (void) didReceiveMemoryWarning
{
	NSLog(@"didReceiveMemoryWarning...");
	UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"memory warning" message:@"didReceiveMemoryWarning" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

- (void)dealloc {
	//NSLog(@"FeedViewController dealloc");
	[items release];
    [feed setDelegate:nil];
    [feed release];
	[spinningWheel release];
    [super dealloc];
}

@end
