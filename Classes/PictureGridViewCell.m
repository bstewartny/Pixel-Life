#import "PictureGridViewCell.h"
#import "Picture.h"
#import <QuartzCore/QuartzCore.h>

@implementation PictureGridViewCell
@synthesize picture;

- (id) initWithFrame: (CGRect) frame reuseIdentifier: (NSString *) aReuseIdentifier
{
	self = [super initWithFrame: frame reuseIdentifier: aReuseIdentifier];
	if ( self == nil )
	return nil;

	imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
	
	imageView.clipsToBounds = NO;
	
	imageView.contentMode = UIViewContentModeScaleAspectFit;

	self.backgroundColor = [UIColor blackColor];

	self.contentView.backgroundColor = self.backgroundColor;

	imageView.backgroundColor = self.backgroundColor;

	[self.contentView addSubview: imageView];
	
	[self setupSubviews];
	
	return self;
}

- (void) setupSubviews
{
	// subclass
}

- (void) setImage:(UIImage*)image
{
	imageView.image = image;
	if(image!=nil)
	{
		[self setNeedsLayout];
	}
}

- (void)setPictureLabels:(Picture *)newPicture
{
	// set any display labels,e tc.
}

- (void)setPicture:(Picture *)newPicture
{
    if (newPicture != picture)
    {
        picture.delegate = nil;
        [picture release];
        picture = nil;
        
        picture = [newPicture retain];
        [picture setDelegate:self];
        
		[self setPictureLabels:newPicture];
		
        if (picture != nil)
        {
            // This is to avoid the item loading the image
            // when this setter is called; we only want that
            // to happen depending on the scrolling of the table
            if ([picture hasLoadedThumbnail])
            {
				[self setImage:picture.thumbnail];
            }
            else
            {
				[self setImage:nil];
            }
        }
    }
}

- (void)load
{
	// The getter in the Picture class is overloaded...!
    // If the image is not yet downloaded, it returns nil and 
    // begins the asynchronous downloading of the image.
    UIImage *image = picture.thumbnail;
	if (image == nil)
    {
		[self startLoading];
    }
	[self setImage:image];
}

- (void)picture:(Picture *)picture didLoadImage:(UIImage *)image
{
	[self setImage:image];
	[self finishedLoading];
    [self bringSubviewToFront:imageView];
	[imageView setNeedsDisplay];
}

- (void)picture:(Picture *)picture couldNotLoadImageError:(NSError *)error
{
	// Here we could show a "default" or "placeholder" image...
    [self finishedLoading];
}

- (void) dealloc
{
	[imageView release];
	[picture setDelegate:nil];
    [picture release];
	[super dealloc];
}

@end
