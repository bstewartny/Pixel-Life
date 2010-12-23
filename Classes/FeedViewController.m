    //
//  FeedViewController.m
//  PhotoExplorer
//
//  Created by Robert Stewart on 12/21/10.
//  Copyright 2010 Evernote. All rights reserved.
//

#import "FeedViewController.h"
#import "Feed.h"
#import "PhotoExplorerAppDelegate.h"
#import "Reachability.h"

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
- (void)reloadFeed
{
	// Check if the remote server is available
    Reachability *reachManager = [Reachability reachabilityWithHostName:@"www.facebook.com"];
    PhotoExplorerAppDelegate *appDelegate = [PhotoExplorerAppDelegate sharedAppDelegate];
	NetworkStatus remoteHostStatus = [reachManager currentReachabilityStatus];
    if (remoteHostStatus == NotReachable)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        NSString *msg = @"This app requires internet connectivity. Data will be loaded from cache if available.";
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
    
    [self showLoadingView];
	[feed fetch];
}

- (void)feed:(Feed *)feed didFindItems:(NSArray *)items 
{
	self.items=items;
	[self reloadData];
	[self hideLoadingView];
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
	[spinningWheel startAnimating];
	[self.view bringSubviewToFront:spinningWheel];
}

- (void)hideLoadingView
{
	[spinningWheel stopAnimating];
	[self.view sendSubviewToBack:spinningWheel];
}

- (void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[self reloadData];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    [self reloadFeed];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation
{
    return YES;
}
 
- (void)dealloc {
	[items release];
    [feed setDelegate:nil];
    [feed release];
	[spinningWheel release];
    [super dealloc];
}

@end
