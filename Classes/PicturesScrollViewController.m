#import "PicturesScrollViewController.h"
#import "Picture.h"
#import "PictureImageView.h"
#import "User.h"
#import "FacebookPhotoCommentsFeed.h"
#import "PhotoCommentsViewController.h"


@implementation PicturesScrollViewController
@synthesize scrollView, toolbar,pictures,infoView,currentItemIndex,infoImageView,infoUserLabel,infoNameLabel,infoDateLabel;

- (id)initWithPictures:(NSArray*)pictures
{
    if(self=[super initWithNibName:@"PicturesScrollView" bundle:nil])
	{
		self.pictures=pictures;
		 
		self.view.backgroundColor=[UIColor blackColor];
		self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(action:)] autorelease];
		
		UITapGestureRecognizer * gr=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
		
		gr.numberOfTapsRequired=1;
		
		[self.scrollView addGestureRecognizer:gr];
		
		[gr release];
		
		format = [[NSDateFormatter alloc] init];
		[format setDateFormat:@"MMM d, yyyy"];
		
		picViews=[[NSMutableArray alloc] init];
	}
    return self;
}

- (void) action:(id)sender
{
	FacebookPhotoCommentsFeed * feed=[[FacebookPhotoCommentsFeed alloc] initWithFacebook:[[[UIApplication sharedApplication] delegate] facebook] picture:[self.pictures objectAtIndex:currentItemIndex]];
	
	PhotoCommentsViewController * controller=[[PhotoCommentsViewController alloc] initWithFeed:feed title:@"Comments"];
	
	controller.modalPresentationStyle=UIModalPresentationFormSheet;
	controller.view.backgroundColor=[UIColor clearColor];
	
	[self presentModalViewController:controller animated:YES];
	
	[feed release];
	[controller release];					  
}

- (void) doubleTap:(UIGestureRecognizer*)gr
{
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
	
	return b;
}

-(void) addPicturesToScrollView
{
	CGFloat left=0;
	CGFloat top=0;
	
	CGRect frame=[self getBounds];
	
	CGFloat width=frame.size.width;
	CGFloat height=frame.size.height;
	
	[picViews removeAllObjects];
	
	for(Picture * picture in pictures)
	{
		CGFloat x=left;
		CGFloat y=top;
		
		CGRect frame=CGRectMake(x,y,width,height);
		
		PictureImageView * picView=[[PictureImageView alloc] initWithFrame:frame picture:picture];
		
		[scrollView addSubview:picView];
		
		[picViews addObject:picView];
		
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
	
	for(PictureImageView * picView in picViews)
	{
		CGFloat x=left;
		CGFloat y=top;
		
		CGRect frame=CGRectMake(x,y,width,height);
		picView.frame=frame;
		[picView setNeedsDisplay];
		
		left+=width;
	}
	[scrollView setContentSize:CGSizeMake([pictures count]*width, height)];
	[scrollView setNeedsDisplay];
}
 
- (void)viewDidLoad 
{
    [super viewDidLoad];
	scrollView.backgroundColor=[UIColor blackColor];
}

- (void)toggleNavigationBar {
	CGRect rect = self.navigationController.navigationBar.frame;
    rect.origin.y = rect.origin.y < 0 ?
		rect.origin.y + rect.size.height
		:	rect.origin.y - rect.size.height;
	
	CGRect rect2=infoView.frame;
		rect2.origin.y= rect2.origin.y>=self.view.frame.size.height ?
			self.view.frame.size.height-rect2.size.height :
			self.view.frame.size.height;
	
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:UINavigationControllerHideShowBarDuration];
    self.navigationController.navigationBar.frame = rect;
    infoView.frame=rect2;
	[UIView commitAnimations];
}

-(void)toggleNavigationBarWithTimer:(NSTimer*)theTimer { 
	[self performSelectorOnMainThread:@selector(toggleNavigationBar) withObject:nil waitUntilDone:NO];
}

- (void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	NSTimer * myTimer = [NSTimer scheduledTimerWithTimeInterval:6.0 target:self selector:@selector(toggleNavigationBarWithTimer:) userInfo:nil repeats:NO];
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
	[self loadVisiblePictures]; 
}

- (void) loadVisiblePictures
{
	PictureImageView * prev=nil;
	BOOL prevLoaded=NO;
	int i=0;
	
	BOOL unloadImages=NO;
	
	if([scrollView.subviews count] > 20)
	{
		unloadImages=YES;
	}
	
	for(PictureImageView * picView in picViews)
	{
		if(CGRectIntersectsRect(picView.frame, scrollView.bounds))
		{
			NSLog(@"Found intersection rect...");
			currentItemIndex=i;
			[picView load];
		}
		
		i++;
	}
	
	int prevItemIndex=-1;
	// also preload prev and next images
	if(currentItemIndex>0)
	{
		prevItemIndex=currentItemIndex-1;
		[[picViews objectAtIndex:prevItemIndex] load];
	}
	int nextItemindex=-1;
	if(currentItemIndex < ([pictures count]-1))
	{
		nextItemindex=currentItemIndex+1;
		[[picViews objectAtIndex:nextItemindex] load];
	}
	if(unloadImages)
	{
		i=0;
		for(PictureImageView * picView in picViews)
		{
			if(prevItemIndex>-1)
			{
				if(i<prevItemIndex)
				{
					[picView unload];
				}
			}
			if(nextItemindex>-1)
			{
				if (i>nextItemindex) 
				{
					[picView unload];
				}
			}
			i++;
		}
	}

	self.navigationItem.title=[NSString stringWithFormat:@"%d of %d",currentItemIndex+1,[pictures count]];
	
	// show info view...
	[self updateInfoView];
}

- (void) updateInfoView
{
	Picture * currentPicture=[pictures objectAtIndex:currentItemIndex];
	
	NSLog(@"updateInfoView: %@",currentPicture.name);
	
	infoNameLabel.text=currentPicture.name;
	
	infoUserLabel.text=[NSString stringWithFormat:@"by %@ on %@",currentPicture.user.name,[format stringFromDate:currentPicture.created_date]];
	
	if([[currentPicture.user picture] hasLoadedThumbnail])
	{
		infoImageView.image=[[currentPicture.user picture] thumbnail];
	}
	else 
	{
		if([[currentPicture.user picture] hasLoadedImage])
		{
			infoImageView.image=[[currentPicture.user picture] image];
		}
		else 
		{
			infoImageView.image=nil;
		}
	}
}

- (void) showInfoView
{
	CGRect rect2=infoView.frame;
	rect2.origin.y= self.view.frame.size.height-rect2.size.height;	
	self.infoView.frame=rect2;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	self.scrollView.hidden=YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	[self setPictureFrames];
	[self goToCurrentItem];
	[self loadVisiblePictures];
	self.scrollView.hidden=NO;
	// show info view again because navigation bar will re-show if it was hidden...
	[self showInfoView];
}
 
- (void)dealloc {
	[pictures release];
	[toolbar release];
	[scrollView release];
	[infoImageView release];
	[infoUserLabel release];
	[infoNameLabel release];
	[infoDateLabel release];
	[picViews release];
	[format release];
	[infoView release];
	
    [super dealloc];
}

@end
