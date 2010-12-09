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

- (void) setImage:(UIImage*)image
{
	if(image==nil)
	{
		imageView.image=nil;
		
		[layerView1 removeFromSuperview];
		[layerView2 removeFromSuperview];
		
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
	
	imageView.layer.shadowRadius=4.0;
	imageView.layer.shadowColor=[UIColor darkGrayColor].CGColor;
	imageView.layer.shadowOpacity=0.5;
	imageView.layer.shadowOffset=CGSizeMake(2,2);
	imageView.transform=CGAffineTransformMakeRotation(-0.1);
	//imageView.layer.borderWidth=1;
	//imageView.layer.borderColor=[UIColor clearColor].CGColor;
	imageView.layer.edgeAntialiasingMask = kCALayerLeftEdge | kCALayerRightEdge | kCALayerBottomEdge | kCALayerTopEdge;
	
	
	[layerView1 removeFromSuperview];
	[layerView2 removeFromSuperview];
	
	layerView1=[[UIView alloc] initWithFrame:imageView.frame];
	layerView1.backgroundColor=[UIColor whiteColor];
	layerView1.transform = CGAffineTransformMakeRotation (0.2);
	layerView1.layer.shadowRadius=2.0;
	layerView1.layer.shadowColor=[UIColor darkGrayColor].CGColor;
	layerView1.layer.shadowOpacity=0.5;
	layerView1.layer.shadowOffset=CGSizeMake(2,2);
	layerView1.layer.borderWidth=1;
	layerView1.layer.borderColor=[UIColor clearColor].CGColor;
	layerView1.layer.edgeAntialiasingMask = kCALayerLeftEdge | kCALayerRightEdge | kCALayerBottomEdge | kCALayerTopEdge;
	
	layerView2=[[UIView alloc] initWithFrame:imageView.frame];
	layerView2.backgroundColor=[UIColor whiteColor];
	layerView2.transform = CGAffineTransformMakeRotation (-0.3);
	layerView2.layer.shadowRadius=2.0;
	layerView2.layer.shadowColor=[UIColor darkGrayColor].CGColor;
	layerView2.layer.shadowOpacity=0.5;
	layerView2.layer.shadowOffset=CGSizeMake(2,2);
	layerView2.layer.borderWidth=1;
	layerView2.layer.borderColor=[UIColor clearColor].CGColor;
	layerView2.layer.edgeAntialiasingMask = kCALayerLeftEdge | kCALayerRightEdge | kCALayerBottomEdge | kCALayerTopEdge;
	
	
	[self.contentView addSubview:layerView1];
	[self.contentView sendSubviewToBack:layerView1];
	
	[self.contentView addSubview:layerView2];
	[self.contentView sendSubviewToBack:layerView2];

	[layerView1 release];
	[layerView2 release];
	

	
	imageView.image = image;
}

- (void) dealloc
{
	//[layerView1 release];
	//[layerView2 release];
	[super dealloc];
}


@end
