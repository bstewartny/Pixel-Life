//
//  PhotoGridViewCell.m
//  PhotoExplorer
//
//  Created by Robert Stewart on 12/4/10.
//  Copyright 2010 Evernote. All rights reserved.
//

#import "PhotoGridViewCell.h"
#import "Picture.h"
#import <QuartzCore/QuartzCore.h>
#import "User.h"

@implementation PhotoGridViewCell
@synthesize picture;

- (id) initWithFrame: (CGRect) frame reuseIdentifier: (NSString *) aReuseIdentifier
{
    self = [super initWithFrame: frame reuseIdentifier: aReuseIdentifier];
    if ( self == nil )
        return nil;
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, frame.size.width-10, frame.size.height-50)];
	imageView.clipsToBounds = NO;
	//imageView.layer.borderColor=[UIColor whiteColor].CGColor;
	//imageView.layer.borderWidth=6;
	
	imageView.contentMode = UIViewContentModeScaleAspectFit;
	
    self.backgroundColor = [UIColor blackColor];
	
    self.contentView.backgroundColor = self.backgroundColor;
    
	imageView.backgroundColor = self.backgroundColor;
    
    [self.contentView addSubview: imageView];
    
	titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, frame.size.height-40, frame.size.width-20, 20)];
	titleLabel.textAlignment=UITextAlignmentCenter;
	titleLabel.font=[UIFont boldSystemFontOfSize:16];
	titleLabel.textColor=[UIColor whiteColor];
	titleLabel.backgroundColor=[UIColor blackColor];
	 [self.contentView addSubview:titleLabel];
	
	descriptionLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, frame.size.height-20, frame.size.width-20, 20)];
	descriptionLabel.textAlignment=UITextAlignmentCenter;
	descriptionLabel.font=[UIFont boldSystemFontOfSize:12];
	descriptionLabel.textColor=[UIColor whiteColor];
	descriptionLabel.backgroundColor=[UIColor blackColor];
	[self.contentView addSubview:descriptionLabel];
	
    return self;
}

- (void) setImage:(UIImage*)image
{
	if(image==nil)
	{
		imageView.image=nil;
		return;
	}
	
	/*CGRect frame=self.frame;
	
	CGSize maxSize=CGSizeMake(frame.size.width-20,frame.size.height-60);
	
	CGSize size=image.size;
	
	CGFloat widthFactor = maxSize.width / size.width;
	CGFloat heightFactor = maxSize.height / size.height;
	CGFloat scaleFactor;
	
	if (widthFactor > heightFactor) 
		scaleFactor = widthFactor; // scale to fit height
	else
		scaleFactor = heightFactor; // scale to fit width
	
	CGFloat scaledWidth  = size.width * scaleFactor;
	CGFloat scaledHeight =  size.height * scaleFactor;
	
	CGSize newSize=CGSizeMake(scaledWidth, scaledHeight);
	
	
	imageView.frame=CGRectMake(frame.size.width-newSize.width/2,frame.size.height-40-newSize.height /2,newSize.width,newSize.height);
	imageView.layer.borderColor=[UIColor whiteColor].CGColor;
	imageView.layer.borderWidth=10;*/
	
	imageView.image = image;
}

- (void)setPicture:(Picture *)newPicture
{
    if (newPicture != picture)
    {
		titleLabel.text=newPicture.name;
		
		descriptionLabel.text=[NSString stringWithFormat:@"%@ on %@",newPicture.user.name,[newPicture.created_date description]];
		
        picture.delegate = nil;
        [picture release];
        picture = nil;
        
        picture = [newPicture retain];
        [picture setDelegate:self];
        
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
	NSLog(@"PhotoGridViewCell.load");
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

- (void)picture:(Picture *)picture didLoadImage:(UIImage *)image
{
	NSLog(@"picture:didLoadImage");
	[self setImage:image];
	[self finishedLoading];
    [self bringSubviewToFront:imageView];
	[imageView setNeedsDisplay];
}

- (void)picture:(Picture *)picture couldNotLoadImageError:(NSError *)error
{
	NSLog(@"picture:couldNotLoadImageError");
	// Here we could show a "default" or "placeholder" image...
    [self finishedLoading];
}

- (void) dealloc
{
	[imageView release];
	[titleLabel release];
	[descriptionLabel release];
    [picture setDelegate:nil];
    [picture release];

	[super dealloc];
}


@end
