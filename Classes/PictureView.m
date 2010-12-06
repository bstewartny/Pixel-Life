//
//  PictureView.m
//  PhotoExplorer
//
//  Created by Robert Stewart on 12/4/10.
//  Copyright 2010 Evernote. All rights reserved.
//

#import "PictureView.h"
#import "Picture.h"
#import <QuartzCore/QuartzCore.h>

@implementation PictureView
@synthesize picture;

- (id)initWithFrame:(CGRect)frame 
{
    if (self = [super initWithFrame:frame]) 
    {
        self.backgroundColor = [UIColor blackColor];
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
		//imageView.contentMode=UIViewContentModeScale
		
		imageView.clipsToBounds = YES;
		imageView.layer.borderColor=[UIColor whiteColor].CGColor;
		imageView.layer.borderWidth=10;
		
        [self addSubview:imageView];
        
        scrollingWheel = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(frame.size.width/2-10, frame.size.height/2-10, 20.0, 20.0)];
        scrollingWheel.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        scrollingWheel.hidesWhenStopped = YES;
        [scrollingWheel stopAnimating];
        [self addSubview:scrollingWheel];

    }
    return self;
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
        
        if (picture != nil)
        {
            // This is to avoid the item loading the image
            // when this setter is called; we only want that
            // to happen depending on the scrolling of the table
            if ([picture hasLoadedImage])
            {
                imageView.image = picture.image;
            }
            else
            {
                imageView.image = nil;
            }
        }
    }
}

- (void)loadImage
{
	NSLog(@"PictureView.loadImage");
	// The getter in the Picture class is overloaded...!
    // If the image is not yet downloaded, it returns nil and 
    // begins the asynchronous downloading of the image.
    UIImage *image = picture.image;
	if (image == nil)
    {
        [scrollingWheel startAnimating];
    }
    imageView.image = image;
}

- (void)picture:(Picture *)picture didLoadImage:(UIImage *)image
{
	NSLog(@"PictureView.didLoadImage");
    imageView.image = image;
    [scrollingWheel stopAnimating];
	[self bringSubviewToFront:imageView];
	[imageView setNeedsDisplay];
}

- (void)picture:(Picture *)picture couldNotLoadImageError:(NSError *)error
{
	NSLog(@"PictureView.couldNotLoadImageError: %@",[error userInfo]);
    // Here we could show a "default" or "placeholder" image...
    [scrollingWheel stopAnimating];
}

- (void)dealloc 
{
    [imageView release];
	[scrollingWheel release];
    [picture setDelegate:nil];
    [picture release];
    [super dealloc];
}

@end
