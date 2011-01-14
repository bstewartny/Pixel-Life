#import "PictureImageScrollView.h"
#import "Picture.h"
#import "PictureImageView.h"

@implementation PictureImageScrollView
@synthesize index,picture;

- (id)initWithFrame:(CGRect)frame picture:(Picture*)picture
{
    if ((self = [super initWithFrame:frame])) 
	{
		self.picture=picture;
		self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.bouncesZoom = YES;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.delegate = self;        
		self.zoomScale = 1.0;
		self.maximumZoomScale = [self calculateMaxZoomScale];
		self.minimumZoomScale = 0.5;
		self.contentSize=frame.size;
		
		imageView=[[PictureImageView alloc] initWithFrame:frame picture:picture];
		
		[self addSubview:imageView];
	}
    return self;
}

- (void) setImageContentMode:(UIViewContentMode)mode
{
	imageView.contentMode=mode;
}
 

- (void) toggleZoomAtTouchPoint:(CGPoint)point
{
	if([self zoomScale]<2.0)
	{
		[self toggleZoomInAtTouchPoint:point];
	}
	else 
	{
		[self toggleZoomOutAtTouchPoint:point];
	}
}

- (void) toggleZoomOutAtTouchPoint:(CGPoint)point
{
	[self setZoomScale:1.0 animated:YES];
}

- (void) toggleZoomInAtTouchPoint:(CGPoint)point
{
	CGFloat maxZoomScale=[self calculateMaxZoomScale];
	CGRect zoomRect=[self zoomRectForScale:2.0 withCenter:point];
	[self zoomToRect:zoomRect animated:YES];
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    // the zoom rect is in the content view's coordinates. 
    //    At a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.
    //    As the zoom scale decreases, so more content is visible, the size of the rect grows.
    zoomRect.size.height = self.frame.size.height / scale;
    zoomRect.size.width  = self.frame.size.width  / scale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}

- (void) updateFrame:(CGRect)f
{
	self.frame=f;
	self.contentSize=f.size;
	imageView.frame=self.bounds;
}

- (void)dealloc
{
	[picture release];
    [imageView release];
    [super dealloc];
}

- (void)layoutSubviews 
{
    [super layoutSubviews];
    
    // center the image as it becomes smaller than the size of the screen
	
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = imageView.frame;
    
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width)
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    else
        frameToCenter.origin.x = 0;
    
    // center vertically
    if (frameToCenter.size.height < boundsSize.height)
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    else
        frameToCenter.origin.y = 0;
    
    imageView.frame = frameToCenter;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView;
}

- (void) load
{
	[imageView load];
}

- (void) unload
{
	[imageView unload];
}

- (CGFloat) calculateMaxZoomScale
{
	if([picture hasLoadedImage])
	{
		CGSize imageSize=picture.image.size;
	
		CGSize boundsSize=[self bounds].size;
	
		CGFloat xScale =  imageSize.width / boundsSize.width;   
		CGFloat yScale =  imageSize.height / boundsSize.height;  
		CGFloat maxScale = MAX(xScale, yScale);
		
		if(maxScale < 2.0) 
		{
			return 2.0;
		}
		else 
		{
			self.maximumZoomScale=maxScale;
			return maxScale;
		}
	}
	else 
	{
		return 2.0;
	}
}

/*
- (void)configureForImageSize:(CGSize)imageSize 
{
    CGSize boundsSize = [self bounds].size;
	
    // set up our content size and min/max zoomscale
    CGFloat xScale = boundsSize.width / imageSize.width;    // the scale needed to perfectly fit the image width-wise
    CGFloat yScale = boundsSize.height / imageSize.height;  // the scale needed to perfectly fit the image height-wise
    CGFloat minScale = MIN(xScale, yScale);                 // use minimum of these to allow the image to become fully visible
    
    // on high resolution screens we have double the pixel density, so we will be seeing every pixel if we limit the
    // maximum zoom scale to 0.5.
    CGFloat maxScale = 1.0 / [[UIScreen mainScreen] scale];
	
    // don't let minScale exceed maxScale. (If the image is smaller than the screen, we don't want to force it to be zoomed.) 
    if (minScale > maxScale) {
        minScale = maxScale;
    }
	
    self.contentSize = imageSize;
    self.maximumZoomScale = maxScale;
    self.minimumZoomScale = minScale;
    self.zoomScale = minScale;  // start out with the content fully visible
}
*/
@end

