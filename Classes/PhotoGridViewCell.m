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
@synthesize picture,showBorder;

- (id) initWithFrame: (CGRect) frame reuseIdentifier: (NSString *) aReuseIdentifier
{
    self = [super initWithFrame: frame reuseIdentifier: aReuseIdentifier];
    if ( self == nil )
        return nil;
    
	gregorian=[[NSCalendar alloc]
							initWithCalendarIdentifier:NSGregorianCalendar];
	
	
	format = [[NSDateFormatter alloc] init];
	[format setDateFormat:@"MMM d, yyyy"];
	
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, frame.size.width-10, frame.size.height-50)];
	imageView.clipsToBounds = NO;
	//imageView.layer.borderColor=[UIColor whiteColor].CGColor;
	//imageView.layer.borderWidth=6;
	maxImageSize=CGSizeMake(imageView.frame.size.width, imageView.frame.size.height);
	
	imageView.contentMode = UIViewContentModeScaleAspectFit;
	
    self.backgroundColor = [UIColor blackColor];
	
    self.contentView.backgroundColor = self.backgroundColor;
    
	imageView.backgroundColor = self.backgroundColor;
    
    [self.contentView addSubview: imageView];
    
	label1=[self createLabelWithFrame:CGRectMake(5, frame.size.height-42, frame.size.width-10, 14)];
	label2=[self createLabelWithFrame:CGRectMake(5, frame.size.height-28, frame.size.width-10, 14)];
	label3=[self createLabelWithFrame:CGRectMake(5, frame.size.height-14, frame.size.width-10, 14)];
	
	[self.contentView addSubview:label1];
	[self.contentView addSubview:label2];
	[self.contentView addSubview:label3];
		
    return self;
}

- (UILabel*)createLabelWithFrame:(CGRect)frame
{
	UILabel * label=[[UILabel alloc] initWithFrame:frame];
	label.textAlignment=UITextAlignmentCenter;
	label.font=[UIFont boldSystemFontOfSize:12];
	label.textColor=[UIColor whiteColor];
	label.backgroundColor=[UIColor blackColor];
	return label;
}

- (void) setImage:(UIImage*)image
{
	if(image==nil)
	{
		imageView.image=nil;
		if(showBorder)
		{
			imageView.layer.borderColor=[UIColor clearColor].CGColor;
			imageView.layer.borderWidth=0;
		}
		return;
	}
	
	if(image.size.width > maxImageSize.width ||
	   image.size.height > maxImageSize.height)
	{
		imageView.contentMode=UIViewContentModeScaleAspectFit;
		
		CGFloat viewRatio=maxImageSize.width / maxImageSize.height;
		CGFloat imageRatio=image.size.width/image.size.height;
		
		if(viewRatio > imageRatio)
		{
			// view is more "wide" than image, so image will hit top/bottom first
			// so we make width narrower according to ratio
			CGFloat new_width=maxImageSize.height * (image.size.width/image.size.height);
			imageView.frame=CGRectMake((maxImageSize.width-new_width)/2, 5, new_width,maxImageSize.height);
		}
		else 
		{
			// view is less "wide" than image, so image will hit left/right first
			// so we make height smaller according to ratio
			CGFloat new_height=maxImageSize.width * (image.size.width/image.size.height);
			imageView.frame=CGRectMake(5, 5+(maxImageSize.height-new_height), maxImageSize.width,new_height);
		}

		
		if(showBorder)
		{
		imageView.layer.borderColor=[UIColor whiteColor].CGColor;
		imageView.layer.borderWidth=4;
		}
	}
	else 
	{
		imageView.contentMode=UIViewContentModeCenter;
		imageView.frame=CGRectMake((self.frame.size.width-image.size.width)/2, 5+(maxImageSize.height- image.size.height   ), image.size.width,image.size.height);
		
		if(showBorder)
		{
			imageView.layer.borderColor=[UIColor whiteColor].CGColor;
			imageView.layer.borderWidth=4;
		}
	}

	
	//CGSize size=image.size;
	
	/*if(size.width < imageView.frame.size.width &&
	   size.height < imageView.frame.size.height)
	{
		imageView.contentMode=UIViewContentModeCenter;
		
		imageView.layer.borderColor=[UIColor clearColor].CGColor;
		imageView.layer.borderWidth=0;
	}
	else 
	{*/
	/*	imageView.contentMode=UIViewContentModeScaleAspectFit;
	NSLog(@"image.size=%@",NSStringFromCGSize(size));
	
		if(size.width > size.height)
		{
			NSLog(@"landscape image");
			// wide landscape image
			// aspect fit will leave gaps between border so make it shorter
			CGRect frm=imageView.frame;
			CGFloat new_height=frm.size.height * (size.height/size.width);
			NSLog(@"old frame=%@",NSStringFromCGRect(imageView.frame));
			NSLog(@"new_height=%f",new_height);
			
			frm.origin.y=frm.origin.y+(frm.size.height - new_height);
			frm.size.height=new_height;
			imageView.frame=CGRectMake(frm.origin.x, frm.origin.y, frm.size.width, frm.size.height);
			NSLog(@"new frame=%@",NSStringFromCGRect(imageView.frame));
			
		}
		else 
		{
			NSLog(@"portrait image");
			// tall portrait image
			// aspect fit will leave gaps between border so make it narrower
			
			CGRect frm=imageView.frame;
			CGFloat new_width=frm.size.width * (size.width/size.height);
			NSLog(@"old frame=%@",NSStringFromCGRect(imageView.frame));
			
			NSLog(@"new_width=%f",new_width);
			
			frm.origin.x=frm.origin.x+(frm.size.width - new_width)/2;
			frm.size.width=new_width;
			imageView.frame=CGRectMake(frm.origin.x, frm.origin.y, frm.size.width, frm.size.height);
			NSLog(@"new frame=%@",NSStringFromCGRect(imageView.frame));
		}

		imageView.layer.borderColor=[UIColor whiteColor].CGColor;
		imageView.layer.borderWidth=4;
*/
	//}
	
	/*
	CGRect frame=self.frame;
	
	CGSize maxSize=CGSizeMake(frame.size.width-20,frame.size.height-60);
	
	CGSize size=image.size;
	
	CGFloat widthFactor = maxSize.width / size.width;
	
	CGFloat heightFactor = maxSize.height / size.height;
	
	if(widthFactor>1.0) widthFactor=1.0;
	if(heightFactor>1.0) heightFactor=1.0;
	
	CGFloat scaleFactor;
	
	if (widthFactor > heightFactor) 
		scaleFactor = widthFactor; // scale to fit height
	else
		scaleFactor = heightFactor; // scale to fit width
	
	CGFloat scaledWidth  = size.width * scaleFactor;
	CGFloat scaledHeight =  size.height * scaleFactor;
	
	CGSize newSize=CGSizeMake(scaledWidth, scaledHeight);
	
	imageView.frame=CGRectMake((frame.size.width-newSize.width)/2,((frame.size.height-60)-newSize.height) /2,newSize.width,newSize.height);
	imageView.layer.borderColor=[UIColor whiteColor].CGColor;
	imageView.layer.borderWidth=4;
	*/
	imageView.image = image;
}

- (NSString*) shortDisplayDate:(NSDate*)date
{
	NSDate *todayDate = [NSDate date];
	 
	NSDateComponents * today_components=[gregorian components:(NSDayCalendarUnit|NSWeekCalendarUnit) fromDate:todayDate];
	
	
	NSDateComponents * item_components=[gregorian components:(NSDayCalendarUnit|NSWeekCalendarUnit) fromDate:date];
	
	NSString * display;
	
	if([today_components day] == [item_components day] &&
	   [today_components month] == [item_components month] &&
	   [today_components year] == [item_components year])
	{
		if([today_components hour]==[item_components hour])
		{
			int minutes=([today_components minute] - [item_components minute]);
			
			if(minutes<2)
			{
				display=@"1 minute ago";
			}
			else 
			{
				display=[NSString stringWithFormat:@"%d minutes ago"];
			}
		}
		else 
		{
			int hours=([today_components hour] - [item_components hour]);
			if(hours<2)
			{
				display=@"1 hour ago";
			}
			else 
			{
				display=[NSString stringWithFormat:@"%d hours ago"];
			}
		}
	}
	else 
	{
		// return just date Mmm dd
		[format setDateFormat:@"MMM d, yyyy"];
		display = [format stringFromDate:date];
	}
	
	return display;
}

- (NSString*) shortDisplayDateWithPicture:(Picture*)pic
{
	if(pic.updated_date!=nil)
	{
		return [self shortDisplayDate:pic.updated_date];
	}
	else 
	{
		if(pic.created_date!=nil)
		{
			return [self shortDisplayDate:pic.created_date];
		}
	}
	return nil;
}

- (void)setPicture:(Picture *)newPicture
{
    if (newPicture != picture)
    {
		label1.text=nil;
		label2.text=nil;
		label3.text=nil;
		
		if([newPicture.name length]>0)
		{
			label1.text=newPicture.name;
			if([newPicture.description length]>0)
			{
				label2.text=newPicture.description;
				label3.text=[self shortDisplayDateWithPicture:newPicture];
			}
			else 
			{
				label2.text=[self shortDisplayDateWithPicture:newPicture];
			}

		}
		else 
		{
			if([newPicture.description length]>0)
			{
				label1.text=newPicture.description;
				label2.text=[self shortDisplayDateWithPicture:newPicture];
			}
			else 
			{
				label1.text=[self shortDisplayDateWithPicture:newPicture];
			}
		}

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
	NSLog(@"PhotoGridViewCell.load");
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
	NSLog(@"PhotoGridViewCell.dealloc");
	[imageView release];
	[label1 release];
	[label2 release];
	[label3 release];
	
	//[descriptionLabel release];
    [picture setDelegate:nil];
    [picture release];
	[gregorian release];
	[format release];
	[super dealloc];
}


@end
