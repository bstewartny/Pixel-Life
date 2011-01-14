#import "FriendGridViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "Picture.h"

@implementation FriendGridViewCell
 
- (void) setupSubviews
{
	//NSLog(@"FriendGridViewCell frame: %@",NSStringFromCGRect(self.frame));
	
	CGRect rect=self.frame; 
	
	imageView.frame =CGRectMake(5,5, rect.size.width-10, rect.size.height-10);
	imageView.clipsToBounds = YES;
	imageView.contentMode = UIViewContentModeScaleAspectFill;
	imageView.layer.borderColor=[UIColor whiteColor].CGColor;
	imageView.layer.borderWidth=4;
	imageView.layer.shadowPath=[UIBezierPath bezierPathWithRect:imageView.bounds].CGPath;
	imageView.layer.shadowOpacity=0.5;
	imageView.layer.shadowColor=[UIColor blackColor].CGColor;
	
	nameView=[[UIView alloc] initWithFrame:CGRectMake(0,rect.size.height-55,rect.size.width,55)];
	nameView.backgroundColor=[UIColor blackColor];
	nameView.alpha=0.5;
	
	[imageView addSubview:nameView];
	[imageView bringSubviewToFront:nameView];
	
	[nameView release];
	
	firstNameLabel=[[UILabel alloc] initWithFrame:CGRectMake(10,5,rect.size.width-20,15)];
	firstNameLabel.font=[UIFont boldSystemFontOfSize:14];
	firstNameLabel.textColor=[UIColor whiteColor];
	firstNameLabel.backgroundColor=[UIColor clearColor];
	
	[nameView addSubview:firstNameLabel];
	[nameView bringSubviewToFront:firstNameLabel];
	
	lastNameLabel=[[UILabel alloc] initWithFrame:CGRectMake(10,22,rect.size.width-20,15)];
	lastNameLabel.font=[UIFont boldSystemFontOfSize:14];
	lastNameLabel.textColor=[UIColor whiteColor];
	lastNameLabel.backgroundColor=[UIColor clearColor];
	
	[nameView addSubview:lastNameLabel];
	[nameView bringSubviewToFront:lastNameLabel];

}

- (void)setPictureLabels:(Picture *)newPicture
{
	firstNameLabel.text=newPicture.name;
	lastNameLabel.text=newPicture.description;
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
            if ([picture hasLoadedImage])
            {
				[self setImage:picture.image];
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
    UIImage *image = picture.image;
	if (image == nil)
    {
		[self startLoading];
    }
	[self setImage:image];
}

-(void)dealloc
{
	[lastNameLabel release];
	[firstNameLabel release];
	[super dealloc];
}

@end
