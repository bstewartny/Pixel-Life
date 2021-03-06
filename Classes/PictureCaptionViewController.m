#import "PictureCaptionViewController.h"
#import "Picture.h"
#import "Friend.h"
#import "User.h"

@implementation PictureCaptionViewController
@synthesize picture,friendPicture,userLabel,nameLabel,descriptionLabel,dateLabel,imageView;

- (id)initWithPicture:(Picture*)picture
{
    if(self=[super initWithNibName:@"PictureCaptionView" bundle:nil])
	{
		self.picture=picture;
		
		if ([picture.user isKindOfClass:[Friend class]]) {
			Friend * f=(Friend*)picture.user;
			self.friendPicture=f.picture;
			self.friendPicture.delegate=self;
			
		}
		imageView.contentMode= UIViewContentModeScaleAspectFill;
	
		self.view.backgroundColor=[UIColor blackColor];
		self.view.alpha=0.5;
	}
    return self;
}

- (void) startLoading
{
	//[self.view bringSubviewToFront:scrollingWheel];
	//[scrollingWheel startAnimating];
}

- (void) finishedLoading
{
	//[scrollingWheel stopAnimating];
	//[self.view sendSubviewToBack:scrollingWheel];
}

- (void)viewDidLoad {
	
	[super viewDidLoad];
	
	if(friendPicture)
	{
		UIImage * image=friendPicture.thumbnail;
		if(image)
		{
			[self finishedLoading];
			imageView.image=image;
		}
		else 
		{
			[self startLoading];
		}
	}
}

- (void)toggleZoom:(UIGestureRecognizer *)gestureRecognizer
{
	//NSLog(@"toggleZoom");
	//[UIView beginAnimations:nil context:NULL]; {
	//	[UIView setAnimationTransition:UIViewAnimationCurveLinear forView:imageView cache:YES];
	//	[UIView setAnimationDuration:1.0];
	/*if(imageView.contentMode==UIViewContentModeCenter)
	{
		imageView.contentMode=UIViewContentModeScaleAspectFit;
	}
	else {
		if(imageView.contentMode==UIViewContentModeScaleAspectFit)
		{
			imageView.contentMode=UIViewContentModeScaleAspectFill;
			//imageView.transform = CGAffineTransformMakeScale(2,2);
		}
		else 
		{
			if(imageView.contentMode==UIViewContentModeScaleAspectFill)
			{
				if(imageView.image.size.width<768 ||
				   imageView.image.size.height<768)
				{
					imageView.contentMode=UIViewContentModeCenter;
				}
				else 
				{
					imageView.contentMode=UIViewContentModeScaleAspectFit;
				}
				
				
				//	imageView.transform = CGAffineTransformMakeScale(0.5,0.5);
			}
		}
	}	
	[imageView setNeedsDisplay];*/
	//} [UIView commitAnimations];
}

- (void)picture:(Picture *)picture didLoadImage:(UIImage *)image
{
    imageView.image=image;
	[self finishedLoading];
	[imageView setNeedsDisplay];
}

- (void)picture:(Picture *)picture couldNotLoadImageError:(NSError *)error
{
	// Here we could show a "default" or "placeholder" image...
    [self finishedLoading];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (void)viewDidUnload {
    [super viewDidUnload];
	[friendPicture setDelegate:nil];
}

- (void) dealloc
{
	[picture release];
	[friendPicture setDelegate:nil];
	[friendPicture release];
	[userLabel release];
	[nameLabel release];
	[descriptionLabel release];
	[dateLabel release];
	[imageView release];
	[super dealloc];
}
@end
