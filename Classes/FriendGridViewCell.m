//
//  FriendGridViewCell.m
//  PhotoExplorer
//
//  Created by Robert Stewart on 12/8/10.
//  Copyright 2010 Evernote. All rights reserved.
//

#import "FriendGridViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation FriendGridViewCell

- (void) setImage:(UIImage*)image
{
	if(image==nil)
	{
		imageView.image=nil;
		
		return;
	}
	
	imageView.contentMode=UIViewContentModeScaleAspectFill;
	imageView.frame=CGRectMake((self.frame.size.width-72)/2, 5+(maxImageSize.height- 72   ), 72,72);
	imageView.layer.cornerRadius = 9.0;
    imageView.layer.masksToBounds = YES;
    //imageView.layer.borderColor = [UIColor blackColor].CGColor;
    //imageView.layer.borderWidth = 3.0;
	
	/*if(image.size.width > maxImageSize.width ||
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
	}*/
	
	
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


@end
