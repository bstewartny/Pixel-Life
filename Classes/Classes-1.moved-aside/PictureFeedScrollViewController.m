    //
//  PictureFeedScrollViewController.m
//  PhotoExplorer
//
//  Created by Robert Stewart on 12/4/10.
//  Copyright 2010 Evernote. All rights reserved.
//

#import "PictureFeedScrollViewController.h"
#import "PictureFeed.h"
#import "PictureFeedDelegate.h"
#import "PictureViewDelegate.h"
#import "PictureView.h"
#import "Picture.h"
#import "PhotoExplorerAppDelegate.h"
#import "Reachability.h"

@implementation PictureFeedScrollViewController
@synthesize scrollView,pictures,pictureFeed;

- (id)initWithPictureFeed:(PictureFeed*)pictureFeed
{
    if (self = [super initWithNibName:@"PictureFeedScrollView" bundle:nil]) 
    {
		self.scrollView.autoresizesSubviews=NO;
		self.scrollView.zoomScale=1.0;
		self.pictureFeed=pictureFeed;
		self.pictureFeed.delegate=self;
    }
    return self;
} 

 

- (void)reloadFeed
{
	NSLog(@"reloadFeed");
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
    [pictureFeed fetch];
}

- (void)showLoadingView
{
	NSLog(@"showLoadingView");

    if (loadingView == nil)
    {
        loadingView = [[UIView alloc] initWithFrame:self.view.bounds];
        loadingView.opaque = NO;
        loadingView.backgroundColor = [UIColor darkGrayColor];
        loadingView.alpha = 0.5;
		
        UIActivityIndicatorView *spinningWheel = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(142.0, 222.0, 37.0, 37.0)];
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

- (void)pictureFeed:(PictureFeed *)pictureFeed didFindPictures:(NSArray *)pictures
{
	NSLog(@"didFindPictures");
	self.pictures=pictures;
    [self reloadPictureViews];
    [self loadVisiblePictureViews]; 
    [self hideLoadingView];
}

- (void)reloadPictureViews
{
	NSLog(@"reloadPictureViews");
	for(PictureView * pictureView in [scrollView subviews])
	{
		[pictureView removeFromSuperview];
	}
	
	
	UIDeviceOrientation deviceOrientation=[[UIDevice currentDevice] orientation];
	
	switch (deviceOrientation) {
		case UIDeviceOrientationUnknown:
			NSLog(@"UIDeviceOrientationUnknown");
			break;
		case UIDeviceOrientationPortrait: 
			NSLog(@"UIDeviceOrientationPortrait");
			break;// Device oriented vertically, home button on the bottom
		case UIDeviceOrientationPortraitUpsideDown: 
			NSLog(@"UIDeviceOrientationPortraitUpsideDown");
			break;// Device oriented vertically, home button on the top
		case UIDeviceOrientationLandscapeLeft: 
			NSLog(@"UIDeviceOrientationLandscapeLeft");
			break;// Device oriented horizontally, home button on the right
		case UIDeviceOrientationLandscapeRight: 
			NSLog(@"UIDeviceOrientationLandscapeRight");
			break;// Device oriented horizontally, home button on the left
		case UIDeviceOrientationFaceUp: 
			NSLog(@"UIDeviceOrientationFaceUp");
			break;// Device oriented flat, face up
		case UIDeviceOrientationFaceDown:   
			NSLog(@"UIDeviceOrientationFaceDown");
			break;// Device oriented flat, face down
			
			
	}
	 
	NSLog(@"bounds=%@",NSStringFromCGRect(scrollView.bounds));
	NSLog(@"frame=%@",NSStringFromCGRect(scrollView.frame));
	
	// what is current orientation?
	
	int padding=20;
	
	int cubeSize=256;
	
	float pictureWidth= cubeSize - (2*padding);
	float pictureHeight= cubeSize - (2*padding); //self.view.bounds.size.height/4.0 - (2* padding);
	
	int pics_per_row= [pictures count] / (scrollView.bounds.size.height / cubeSize);
	
	if(pics_per_row < 3) pics_per_row=3;
	
	int current_row=0;
	int current_col=0;
	
	[scrollView setContentSize:CGSizeMake(pics_per_row * pictureWidth, scrollView.bounds.size.height)];
	
	for(Picture * picture in pictures)
	{
		CGRect frame=CGRectMake(pictureWidth * current_col,pictureHeight * current_row, pictureWidth, pictureHeight);
		NSLog(@"adding picture at %@",NSStringFromCGRect(frame));
		PictureView * pictureView=[[PictureView alloc] initWithFrame:frame];
		
		pictureView.picture=picture;
		[scrollView addSubview:pictureView];
		[pictureView release];
		
		current_col++;
		 
		if(current_col>=pics_per_row)
		{
			current_row++;
			current_col=0;
		}
	}
}

- (void)pictureFeed:(PictureFeed *)pictureFeed didFailWithError:(NSString *)errorMsg
{
	NSLog(@"didFailWithError: %@",errorMsg);
    [self hideLoadingView];
}

- (void) loadVisiblePictureViews
{
	NSLog(@"loadVisiblePictureViews");
	CGRect visibleRect;
	visibleRect.origin = scrollView.contentOffset;
	visibleRect.size = scrollView.bounds.size;
	
	for (PictureView * pictureView in [scrollView subviews]) 
	{
		if(CGRectIntersectsRect(visibleRect, pictureView.frame))
		{
			[pictureView loadImage];
		}
	}
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView; 
{
    // Method is called when the decelerating comes to a stop.
    // Pass visible cells to the cell loading function. If possible change 
    // scrollView to a pointer to your table cell to avoid compiler warnings
    [self loadVisiblePictureViews]; 
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
{
    if (!decelerate) 
    {
        [self loadVisiblePictureViews]; 
    }
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
/*- (void)viewDidLoad 
{
    [super viewDidLoad];
}

- (void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}*/

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return YES;
	//return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	NSLog(@"didRotateFromInterfaceOrientation");
	[self reloadFeed];
}

- (void)didReceiveMemoryWarning 
{	
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc 
{
    [scrollView release];
    [pictures release];
    [pictureFeed setDelegate:nil];
    [pictureFeed release];
    [super dealloc];
}

@end
