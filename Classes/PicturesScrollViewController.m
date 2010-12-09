    //
//  PictureFeedScrollViewController.m
//  PhotoExplorer
//
//  Created by Robert Stewart on 12/6/10.
//  Copyright 2010 Evernote. All rights reserved.
//

#import "PicturesScrollViewController.h"
#import "Picture.h"
#import "PictureImageView.h"

@implementation PicturesScrollViewController
@synthesize scrollView, pictures,currentItemIndex;

- (id)initWithPictures:(NSArray*)pictures
{
    if(self=[super initWithNibName:@"PicturesScrollView" bundle:nil])
	{
		self.pictures=pictures;
		 
		self.view.backgroundColor=[UIColor blackColor];
		//self.navigationItem;
		//self.navigationBar.translucent=YES;
		
		//self.navigationController.navigationBar.translucent=YES;
		//self.wantsFullScreenLayout=YES;
		
		
		self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(action:)] autorelease];
		
		
		
		
		
		UITapGestureRecognizer * gr=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
		
		gr.numberOfTapsRequired=2;
		
		[self.scrollView addGestureRecognizer:gr];
		
		[gr release];
		
		
		
	}
    return self;
}
- (void) action:(id)sender
{
	
}
- (void) doubleTap:(UIGestureRecognizer*)gr
{
	// toggle nav bar
	[self toggleNavigationBar];
}

- (CGRect) getBounds
{
	
	CGRect b= scrollView.bounds;
	
	if(b.size.width==1024 && b.size.height==704)
	{
		b.size.height=748;
	}
	if (b.size.width==768 && b.size.height==960) {
		b.size.height=1004;
	}
	
	NSLog(@"getBounds: %@",NSStringFromCGRect(b));
	
	return b;
	//return [[UIScreen mainScreen] bounds];
}

-(void) addPicturesToScrollView
{
	CGFloat left=0;
	CGFloat top=0;
	
	CGRect frame=[self getBounds];
	
	CGFloat width=frame.size.width;
	CGFloat height=frame.size.height;
	
	for(Picture * picture in pictures)
	{
		CGFloat x=left;
		CGFloat y=top;
		
		CGRect frame=CGRectMake(x,y,width,height);
		
		PictureImageView * picView=[[PictureImageView alloc] initWithFrame:frame picture:picture];
		
		[scrollView addSubview:picView];
		
		[picView release];
		
		left+=width;
	}
	[scrollView setContentSize:CGSizeMake([pictures count]*width, height)];
}

- (void) setPictureFrames
{
	CGFloat left=0;
	CGFloat top=0;
	
	CGRect frame=[self getBounds];
	
	
	CGFloat width=frame.size.width;
	CGFloat height=frame.size.height;
	
	for(PictureImageView * picView in scrollView.subviews)
	{
		if([picView isKindOfClass:[PictureImageView class]])
		{
			CGFloat x=left;
			CGFloat y=top;
			
			CGRect frame=CGRectMake(x,y,width,height);
			picView.frame=frame;
			[picView setNeedsDisplay];
			
			left+=width;
		}
	}
	[scrollView setContentSize:CGSizeMake([pictures count]*width, height)];
	[scrollView setNeedsDisplay];
}
 
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	scrollView.backgroundColor=[UIColor blackColor];
	
	//[self addPicturesToScrollView];
	
	//[self goToCurrentItem];
	
	//[self loadVisiblePictures]; 
}

- (void)toggleNavigationBar {
	NSLog(@"toggleNavigationBar");
    //Check the current state of the navigation bar...
    /*BOOL navBarState = [self.navigationController isNavigationBarHidden];
    //Set the navigationBarHidden to the opposite of the current state.
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.35];
	self.navigationController.navigationBar.alpha = 0.0;
    [self.navigationController setNavigationBarHidden:!navBarState animated:NO];
	[UIView commitAnimations];
	
	*/
	CGRect rect = self.navigationController.navigationBar.frame;
    rect.origin.y = rect.origin.y < 0 ?
		rect.origin.y + rect.size.height
		:	rect.origin.y - rect.size.height;
	
    [UIView beginAnimations:nil context:NULL];
    //[UIView setAnimationDuration:0.2];
	[UIView setAnimationDuration:UINavigationControllerHideShowBarDuration];
    self.navigationController.navigationBar.frame = rect;
    [UIView commitAnimations];
	
	
	
    
}
/*
- (void)fadeBarAway:(NSTimer*)timer {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.35];
	self.navigationController.navigationBar.alpha = 0.0;
	[[UIApplication sharedApplication] setStatusBarHidden:YES animated:YES];
	[UIView commitAnimations];
}

- (void)fadeBarIn {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.35];
	self.navigationController.navigationBar.alpha = 1.0;
	[[UIApplication sharedApplication] setStatusBarHidden:NO animated:YES];
	[UIView commitAnimations];
}
*/

-(void)toggleNavigationBarWithTimer:(NSTimer*)theTimer { 
	[self performSelectorOnMainThread:@selector(toggleNavigationBar) withObject:nil waitUntilDone:NO];
	//[self toggleNavigationBar];
}

- (void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	NSLog(@"Creating timer...");
	
	NSTimer * myTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(toggleNavigationBarWithTimer:) userInfo:nil repeats:NO];
}

- (void) viewWillDisappear:(BOOL)animated
{
	self.navigationController.navigationBar.translucent=NO;
	[super viewWillDisappear:animated];
}

- (void) viewWillAppear:(BOOL)animated
{
	self.navigationController.navigationBar.translucent=YES;
	[self addPicturesToScrollView];
	
	[self goToCurrentItem];
	
	[self loadVisiblePictures]; 
}

- (void) goToCurrentItem
{
	scrollView.contentOffset=CGPointMake(currentItemIndex * scrollView.bounds.size.width, 0);
	
	self.navigationItem.title=[NSString stringWithFormat:@"%d of %d",currentItemIndex+1,[pictures count]];
	
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	NSLog(@"scrollViewDidEndDecelerating");
	[self loadVisiblePictures]; 
}

- (void) loadVisiblePictures
{
	NSLog(@"loadVisiblePictures");
	PictureImageView * prev=nil;
	BOOL prevLoaded=NO;
	int i=0;
	
	for (PictureImageView * picView in scrollView.subviews) 
	{
		if([ picView isKindOfClass:[PictureImageView class]])
		{
			
			if(CGRectIntersectsRect(picView.frame, scrollView.bounds))
			{
				NSLog(@"Found intersection rect...");
				currentItemIndex=i;
				[prev load];
				[picView load];
				prevLoaded=YES;
			}
			else	
			{
				if(prevLoaded)
				{
					[picView load];
					prevLoaded=NO;
				}
			}
			prev=picView;
			i++;
		}
	}
	self.navigationItem.title=[NSString stringWithFormat:@"%d of %d",currentItemIndex+1,[pictures count]];
	
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	[self setPictureFrames];
	[self goToCurrentItem];
	[self loadVisiblePictures];
}
 
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
	NSLog(@"PicturesScrollViewController.release");
	[pictures release];
	[scrollView release];
    [super dealloc];
}

@end
