#import "PictureImageView.h"
#import "Picture.h"

@implementation PictureImageView
@synthesize picture;

- (id) initWithFrame: (CGRect) frame picture: (Picture *) picture
{
    self = [super initWithFrame: frame];
    if ( self == nil )
        return nil;
	
	self.picture=picture;
	
	scrollingWheel = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(frame.size.width/2-10, frame.size.height/2-10, 20.0, 20.0)];
	scrollingWheel.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
	scrollingWheel.hidesWhenStopped = YES;
	[scrollingWheel stopAnimating];
	self.clipsToBounds=YES;
	self.contentMode=UIViewContentModeScaleAspectFit;
	self.backgroundColor=[UIColor blackColor];
	
	[self addSubview:scrollingWheel];
	
    return self;
}

- (void) load
{
	// The getter in the Picture class is overloaded...!
    // If the image is not yet downloaded, it returns nil and 
    // begins the asynchronous downloading of the image.
    UIImage *img = picture.image;
	if (img == nil)
    {
		if([picture hasLoadedThumbnail])
		{
			self.image=picture.thumbnail;
		}
		delegateWasSet=YES;
		[picture setDelegate:self];
		[self startLoading];
    }
	else 
	{
		self.image=img;
	}
}

- (void) unload
{
	self.image=nil;
	if([picture hasLoadedThumbnail])
	{
		self.image=picture.thumbnail;
	}
	[picture setImage:nil];
}

- (void)picture:(Picture *)picture didLoadImage:(UIImage *)img
{
	self.image=img;
	
	[self finishedLoading];
	[self setNeedsDisplay];
}

- (void)picture:(Picture *)picture couldNotLoadImageError:(NSError *)error
{
	// Here we could show a "default" or "placeholder" image...
    [self finishedLoading];
}

- (void) startLoading
{
	[self bringSubviewToFront:scrollingWheel];
	[scrollingWheel startAnimating];
}

- (void) finishedLoading
{
	[scrollingWheel stopAnimating];
	[self sendSubviewToBack:scrollingWheel];
}

- (void) dealloc
{	
	if(delegateWasSet)
	{
		[picture setDelegate:nil];
	}
	[picture release];
	[scrollingWheel release];
	[super dealloc];
}

@end
