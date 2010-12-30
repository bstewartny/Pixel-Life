#import "PictureScrollView.h"
#import "Picture.h"
#import "PictureImageView.h"

@implementation PictureScrollView

- (id) initWithFrame: (CGRect) frame picture: (Picture *) picture
{
    self = [super initWithFrame: frame];
    if ( self == nil )
        return nil;
	
	pictureImageView=[[PictureImageView	alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) picture:picture];
	pictureImageView.autoresizingMask=UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
	[self addSubview:pictureImageView];
	
	self.clipsToBounds=YES;
	
	self.backgroundColor=[UIColor blackColor];
	
	self.maximumZoomScale = 2.0;
	self.minimumZoomScale = 1;
	
    return self;
}



- (void) load
{
	[pictureImageView load];
}

- (void) unload
{
	[pictureImageView unload];
}

@end
