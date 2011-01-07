#import "PictureTableViewCell.h"
#import "Picture.h"
#import <QuartzCore/QuartzCore.h>

@implementation PictureTableViewCell
@synthesize picture;
@synthesize useLargeImage;
- (void)layoutSubviews {
    [super layoutSubviews];
    //self.imageView.bounds = CGRectMake(,5,50,50);
    self.imageView.frame = CGRectMake(5,5,50,50);
	self.imageView.clipsToBounds=YES;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
	self.imageView.layer.cornerRadius=6.0;
	
	
	
    CGRect tmpFrame = self.textLabel.frame;
    tmpFrame.origin.x = 65;
    self.textLabel.frame = tmpFrame;
	
    tmpFrame = self.detailTextLabel.frame;
    tmpFrame.origin.x = 65;
    self.detailTextLabel.frame = tmpFrame;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}

- (void) setImage:(UIImage*)image
{
	self.imageView.image = image;
	if(image!=nil)
	{
		[self finishedLoading];
		[self setNeedsLayout];
	}
}

- (void) load
{
	if(dealloc_called) return;
	//NSLog(@"load called on comment cell...");
	// The getter in the Picture class is overloaded...!
    // If the image is not yet downloaded, it returns nil and 
    // begins the asynchronous downloading of the image.
    if (self.imageView.image==nil) 
	{
		self.picture.delegate=self;
		UIImage *image=nil;
		if(useLargeImage)
		{
			image=self.picture.image;
		}
		else 
		{
			image = self.picture.thumbnail;
		}
		if (image == nil)
		{
			[self startLoading];
		}
		[self setImage:image];
	}
}

- (void)picture:(Picture *)picture didLoadImage:(UIImage *)image
{
	if(dealloc_called) return;
	[self setImage:image];
	[self finishedLoading];
}

- (void)picture:(Picture *)picture couldNotLoadImageError:(NSError *)error
{
	if(dealloc_called) return;
	// Here we could show a "default" or "placeholder" image...
    [self finishedLoading];
}

- (void) startLoading
{
	//[scrollingWheel startAnimating];
	[self setNeedsLayout];
}

- (void) finishedLoading
{
	//[scrollingWheel stopAnimating];
	//[scrollingWheel release];
	//scrollingWheel=nil;
}

- (void) dealloc
{	
	dealloc_called=YES;
	[picture setDelegate:nil];
	[picture release];
	picture=nil;
	//[scrollingWheel release];
	//scrollingWheel=nil;
	//[pictureImageView release];
	//[nameLabel release];
	[super dealloc];
}

@end
