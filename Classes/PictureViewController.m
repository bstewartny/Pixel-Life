#import "PictureViewController.h"
#import "Picture.h"

@implementation PictureViewController
@synthesize picture,imageView,scrollingWheel;

- (id)initWithPicture:(Picture*)picture
{
    if(self=[super initWithNibName:@"PictureView" bundle:nil])
	{
		self.picture=picture;
		self.picture.delegate=self;
		self.navigationItem.title=picture.name;
		self.title=picture.name;
		
		self.view.backgroundColor=[UIColor blackColor];
	}
    return self;
}

- (void) startLoading
{
	[self.view bringSubviewToFront:scrollingWheel];
	[scrollingWheel startAnimating];
}

- (void) finishedLoading
{
	[scrollingWheel stopAnimating];
	[self.view sendSubviewToBack:scrollingWheel];
}

- (void)viewDidLoad {
	 
	 [super viewDidLoad];
	 
	 imageView.contentMode= UIViewContentModeScaleAspectFit;
	 
	 UITapGestureRecognizer * tapRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self	action:@selector(toggleZoom:)];
	 
	 tapRecognizer.numberOfTapsRequired=2;
											
	 [self.view addGestureRecognizer:tapRecognizer];
	 
	 [tapRecognizer release];
	 
	 UIImage *image = picture.image;
	 if (image == nil)
	 {
		 [self startLoading];
	 }
	 else 
	 {
		 [self finishedLoading];
	 }

	 if(image!=nil)
	 {
		 if(image.size.width<768 ||
			image.size.height<768)
		 {
			 imageView.contentMode=UIViewContentModeCenter;
		 }
		 else 
		 {
			 imageView.contentMode=UIViewContentModeScaleAspectFit;
		 }
		 
		 imageView.image=image;
		 [self.view bringSubviewToFront:imageView];
		 [imageView setNeedsDisplay];
	 }
 }
 
- (void)toggleZoom:(UIGestureRecognizer *)gestureRecognizer
{
	NSLog(@"toggleZoom");
	//[UIView beginAnimations:nil context:NULL]; {
	//	[UIView setAnimationTransition:UIViewAnimationCurveLinear forView:imageView cache:YES];
	//	[UIView setAnimationDuration:1.0];
		if(imageView.contentMode==UIViewContentModeCenter)
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
	[imageView setNeedsDisplay];
	//} [UIView commitAnimations];
}

- (void)picture:(Picture *)picture didLoadImage:(UIImage *)image
{
	if(image.size.width<768 ||
	   image.size.height<768)
	{
		imageView.contentMode=UIViewContentModeCenter;
	}
	else 
	{
		imageView.contentMode=UIViewContentModeScaleAspectFit;
	}
	
    imageView.image=image;
	[self finishedLoading];
    [self.view bringSubviewToFront:imageView];
	[imageView setNeedsDisplay];
}

- (void)picture:(Picture *)picture couldNotLoadImageError:(NSError *)error
{
	[self finishedLoading];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}
 
- (void)viewDidUnload {
    [super viewDidUnload];
	[picture setDelegate:nil];
}

- (void) dealloc
{
	[picture setDelegate:nil];
	[picture release];
	[scrollingWheel release];
	[imageView release];
	[super dealloc];
}
@end
