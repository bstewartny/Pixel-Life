#import "AlbumGridViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "Picture.h"

@implementation AlbumGridViewCell

- (void) setupSubviews
{
	imageView.frame = CGRectMake(5, 5, self.frame.size.width-10, self.frame.size.height-60);
	imageView.clipsToBounds = NO;
	maxImageSize=CGSizeMake(imageView.frame.size.width, imageView.frame.size.height);
	imageView.contentMode = UIViewContentModeScaleAspectFit;
    
	layerView1=[[UIView alloc] initWithFrame:imageView.frame];
	layerView2=[[UIView alloc] initWithFrame:imageView.frame];
	layerView1.backgroundColor=[UIColor clearColor];
	layerView2.backgroundColor=[UIColor clearColor];
	
	[self.contentView addSubview:layerView1];
	[self.contentView addSubview:layerView2];
	[self.contentView sendSubviewToBack:layerView1];
	[self.contentView sendSubviewToBack:layerView2];
	
	label1=[self createLabelWithFrame:CGRectMake(5, self.frame.size.height-45, self.frame.size.width-10, 14)];
	label2=[self createLabelWithFrame:CGRectMake(5, self.frame.size.height-30, self.frame.size.width-10, 14)];
	label3=[self createLabelWithFrame:CGRectMake(5, self.frame.size.height-16, self.frame.size.width-10, 14)];
	
	[self.contentView addSubview:label1];
	[self.contentView addSubview:label2];
	[self.contentView addSubview:label3];
	
     
}

- (void) setImage:(UIImage*)image
{
	if(image==nil)
	{
		imageView.image=nil;
		
		layerView1.backgroundColor=[UIColor clearColor];
		layerView2.backgroundColor=[UIColor clearColor];
		
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
			imageView.layer.borderWidth=8;
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
	imageView.layer.shadowOpacity=1.0;
	imageView.layer.shadowPath=[UIBezierPath bezierPathWithRect:imageView.bounds].CGPath;
	
	layerView1.frame=CGRectMake(imageView.frame.origin.x+4, imageView.frame.origin.y+4, imageView.frame.size.width, imageView.frame.size.height);
	layerView2.frame=CGRectMake(imageView.frame.origin.x+8, imageView.frame.origin.y+8, imageView.frame.size.width, imageView.frame.size.height);
	
	layerView1.backgroundColor=[UIColor lightGrayColor];
	layerView2.backgroundColor=[UIColor lightGrayColor];
	
	layerView1.layer.shadowRadius=3.0;
	layerView1.layer.shadowColor=[UIColor blackColor].CGColor;
	layerView1.layer.shadowOpacity=1.0;
	layerView1.layer.shadowOffset=CGSizeMake(0,0);
	layerView1.layer.shadowPath=[UIBezierPath bezierPathWithRect:layerView1.bounds].CGPath;
	
	layerView2.layer.shadowRadius=3.0;
	layerView2.layer.shadowColor=[UIColor blackColor].CGColor;
	layerView2.layer.shadowOpacity=1.0;
	layerView2.layer.shadowOffset=CGSizeMake(0,0);
	layerView2.layer.shadowPath=[UIBezierPath bezierPathWithRect:layerView1.bounds].CGPath;
	
	imageView.image = image;
	
	[self setNeedsLayout];
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
