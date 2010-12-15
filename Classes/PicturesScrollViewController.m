#import "PicturesScrollViewController.h"
#import "Picture.h"
#import "PictureImageView.h"
//#import "PictureCaptionViewController.h"
#import "User.h"
@implementation PicturesScrollViewController
@synthesize scrollView, toolbar,pictures,infoView,currentItemIndex,infoImageView,infoUserLabel,infoNameLabel,infoDescriptionLabel,infoDateLabel;

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
		
		//captionViewController=[[PictureCaptionViewController alloc] initWithPicture:nil];
		//captionViewController.view.frame=CGRectMake(20, frame.size.height-100, frame.size.width, 80);
		//captionViewController.view.autoresizingMask=
		//	UIViewAutoresizingFlexibleLeftMargin   |
		//	UIViewAutoresizingFlexibleWidth        |
		//	UIViewAutoresizingFlexibleRightMargin  |
		//	UIViewAutoresizingFlexibleTopMargin;
		
		//[self.view addSubview:captionViewController.view];
		
	}
    return self;
}

- (void) action:(id)sender
{
	
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
	
	// show info view...
	[self updateInfoView];
}

- (void) updateInfoView
{
	Picture * currentPicture=[pictures objectAtIndex:currentItemIndex];
	
	NSLog(@"updateInfoView: %@",currentPicture.name);
	
	infoNameLabel.text=currentPicture.name;
	
	infoDescriptionLabel.text=currentPicture.description;
	
	infoUserLabel.text=[NSString stringWithFormat:@"by %@ on %@",currentPicture.user.name,[currentPicture.created_date description]];
	
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
	
}

- (void) hideInfoView
{
	
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
}
 
- (void)dealloc {
	[pictures release];
	[toolbar release];
	[scrollView release];
	//[captionViewController release];
	[infoImageView release];
	[infoUserLabel release];
	[infoNameLabel release];
	[infoDescriptionLabel release];
	[infoDateLabel release];
	
	[infoView release];
	
    [super dealloc];
}

@end
