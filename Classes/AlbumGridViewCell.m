//
//  PhotoGridViewCell.m
//  PhotoExplorer
//
//  Created by Robert Stewart on 12/4/10.
//  Copyright 2010 Evernote. All rights reserved.
//

#import "AlbumGridViewCell.h"
#import "Album.h"
#import "Picture.h"
#import <QuartzCore/QuartzCore.h>

@implementation AlbumGridViewCell
@synthesize album;

- (id) initWithFrame: (CGRect) frame reuseIdentifier: (NSString *) aReuseIdentifier
{
    self = [super initWithFrame: frame reuseIdentifier: aReuseIdentifier];
    if ( self == nil )
        return nil;
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, frame.size.width-10, frame.size.height-50)];
	imageView.clipsToBounds = NO;
	imageView.layer.borderColor=[UIColor whiteColor].CGColor;
	imageView.layer.borderWidth=6;
	
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
	
	dateLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, frame.size.height-20, frame.size.width-20, 20)];
	dateLabel.textAlignment=UITextAlignmentCenter;
	dateLabel.font=[UIFont boldSystemFontOfSize:12];
	dateLabel.textColor=[UIColor whiteColor];
	dateLabel.backgroundColor=[UIColor blackColor];
	 
	[self.contentView addSubview:dateLabel];
	
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

- (void)setAlbum:(Album *)newAlbum
{
    if (newAlbum != album)
    {
		titleLabel.text=newAlbum.name;
		dateLabel.text=nil;
		
        album.picture.delegate = nil;
        [album release];
        album = nil;
        
        album = [newAlbum retain];
        [album.picture setDelegate:self];
        
        if (album != nil)
        {
            // This is to avoid the item loading the image
            // when this setter is called; we only want that
            // to happen depending on the scrolling of the table
            if ([album.picture hasLoadedImage])
            {
				[self setImage:album.picture.image];
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
	NSLog(@"PictureView.loadImage");
	// The getter in the Picture class is overloaded...!
    // If the image is not yet downloaded, it returns nil and 
    // begins the asynchronous downloading of the image.
    UIImage *image = album.picture.image;
	if (image == nil)
    {
		[self startLoading];
    }
	[self setImage:image];
}

- (void)picture:(Picture *)picture didLoadImage:(UIImage *)image
{
	NSLog(@"PictureView.didLoadImage");
    [self setImage:image];
	[self finishedLoading];
    [self bringSubviewToFront:imageView];
	[imageView setNeedsDisplay];
}

- (void)picture:(Picture *)picture couldNotLoadImageError:(NSError *)error
{
	NSLog(@"PictureView.couldNotLoadImageError: %@",[error userInfo]);
    // Here we could show a "default" or "placeholder" image...
    [self finishedLoading];
}

- (void) dealloc
{
	[imageView release];
	[titleLabel release];
	[dateLabel release];
    [album.picture setDelegate:nil];
    [album release];
	
	[super dealloc];
}


@end
