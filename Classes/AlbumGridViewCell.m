//
//  AlbumGridViewCell.m
//  PhotoExplorer
//
//  Created by Robert Stewart on 12/8/10.
//  Copyright 2010 Evernote. All rights reserved.
//

#import "AlbumGridViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "Picture.h"

@implementation AlbumGridViewCell

- (id) initWithFrame: (CGRect) frame reuseIdentifier: (NSString *) aReuseIdentifier
{
    self = [super initWithFrame: frame reuseIdentifier: aReuseIdentifier];
    if ( self == nil )
        return nil;
    
	gregorian=[[NSCalendar alloc]
			   initWithCalendarIdentifier:NSGregorianCalendar];
	
	
	format = [[NSDateFormatter alloc] init];
	[format setDateFormat:@"MMM d, yyyy"];
	
    imageView.frame = CGRectMake(5, 10, frame.size.width-10, frame.size.height-55);
	imageView.clipsToBounds = NO;
	maxImageSize=CGSizeMake(imageView.frame.size.width, imageView.frame.size.height);
	imageView.contentMode = UIViewContentModeScaleAspectFit;
    
	label1=[self createLabelWithFrame:CGRectMake(5, frame.size.height-42, frame.size.width-10, 14)];
	label2=[self createLabelWithFrame:CGRectMake(5, frame.size.height-28, frame.size.width-10, 14)];
	label3=[self createLabelWithFrame:CGRectMake(5, frame.size.height-14, frame.size.width-10, 14)];
	
	[self.contentView addSubview:label1];
	[self.contentView addSubview:label2];
	[self.contentView addSubview:label3];
	
    return self;
}



- (void) setImage:(UIImage*)image
{
	if(image==nil)
	{
		imageView.image=nil;
		
		[layerView1 removeFromSuperview];
		[layerView2 removeFromSuperview];
		layerView1=nil;
		layerView2=nil;
		
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
			imageView.layer.borderWidth=8;
		}
	}
	
	imageView.layer.shadowRadius=4.0;
	imageView.layer.shadowColor=[UIColor blackColor].CGColor;
	imageView.layer.shadowOpacity=0.5;
	//imageView.layer.shadowOffset=CGSizeMake(2,2);
	imageView.layer.shadowPath=[UIBezierPath bezierPathWithRect:imageView.bounds].CGPath;
	//imageView.layer.shadowPath=[UIBezierPath bezierPath].CGPath;
	//imageView.transform=CGAffineTransformMakeRotation(-0.1);
	//imageView.layer.borderWidth=1;
	//imageView.layer.borderColor=[UIColor clearColor].CGColor;
	//imageView.layer.edgeAntialiasingMask = kCALayerLeftEdge | kCALayerRightEdge | kCALayerBottomEdge | kCALayerTopEdge;
	
	
	if(layerView1==nil || layerView2==nil)
	{
		layerView1=[[UIView alloc] initWithFrame:imageView.frame];
		layerView2=[[UIView alloc] initWithFrame:imageView.frame];
		[self.contentView addSubview:layerView1];
		[self.contentView sendSubviewToBack:layerView1];
		
		[self.contentView addSubview:layerView2];
		[self.contentView sendSubviewToBack:layerView2];
	}
	else 
	{
		layerView1.frame=imageView.frame;
		layerView2.frame=imageView.frame;
	}
	
	//layerView1=[[UIView alloc] initWithFrame:imageView.frame];
	layerView1.backgroundColor=[UIColor whiteColor];
	layerView1.transform = CGAffineTransformMakeRotation (0.05);
	layerView1.layer.shadowRadius=3.0;
	layerView1.layer.shadowColor=[UIColor blackColor].CGColor;
	layerView1.layer.shadowOpacity=0.7;
	layerView1.layer.shadowOffset=CGSizeMake(2,2);
	layerView1.layer.shadowPath=[UIBezierPath bezierPathWithRect:layerView1.bounds].CGPath;
	layerView2.layer.borderWidth=1;
	layerView2.layer.borderColor=[UIColor darkGrayColor].CGColor;
	//layerView1.layer.borderWidth=1;
	//layerView1.layer.borderColor=[UIColor clearColor].CGColor;
	//layerView1.layer.edgeAntialiasingMask = kCALayerLeftEdge | kCALayerRightEdge | kCALayerBottomEdge | kCALayerTopEdge;
	
	//layerView2=[[UIView alloc] initWithFrame:imageView.frame];
	layerView2.backgroundColor=[UIColor whiteColor];
	layerView2.transform = CGAffineTransformMakeRotation (-0.03);
	layerView2.layer.shadowRadius=3.0;
	layerView2.layer.shadowColor=[UIColor blackColor].CGColor;
	layerView2.layer.shadowOpacity=0.5;
	layerView2.layer.shadowOffset=CGSizeMake(2,2);
	layerView2.layer.shadowPath=[UIBezierPath bezierPathWithRect:layerView2.bounds].CGPath;
	layerView2.layer.borderWidth=1;
	layerView2.layer.borderColor=[UIColor darkGrayColor].CGColor;
	//layerView2.layer.edgeAntialiasingMask = kCALayerLeftEdge | kCALayerRightEdge | kCALayerBottomEdge | kCALayerTopEdge;
		
	

	imageView.image = image;
}

- (void) dealloc
{
	[layerView1 release];
	[layerView2 release];
	layerView1=nil;
	layerView2=nil;
	[super dealloc];
}


@end
