#import "PhotoGridViewCell.h"
#import "Picture.h"
#import <QuartzCore/QuartzCore.h>
#import "User.h"
#import "GridViewController.h"
#import "AQGridView.h"

@implementation PhotoGridViewCell
@synthesize showBorder;

- (id) initWithFrame: (CGRect) frame reuseIdentifier: (NSString *) aReuseIdentifier
{
    self = [super initWithFrame: frame reuseIdentifier: aReuseIdentifier];
    if ( self == nil )
        return nil;
    
    return self;
}

- (void) setupSubviews
{
	imageView.frame = CGRectMake(5, 5, self.frame.size.width-10, self.frame.size.height-60);
	imageView.clipsToBounds = NO;
	maxImageSize=CGSizeMake(imageView.frame.size.width, imageView.frame.size.height);
	imageView.contentMode = UIViewContentModeScaleAspectFit;
    
	label1=[self createLabelWithFrame:CGRectMake(5, self.frame.size.height-48, self.frame.size.width-10, 14)];
	label2=[self createLabelWithFrame:CGRectMake(5, self.frame.size.height-32, self.frame.size.width-10, 14)];
	label3=[self createLabelWithFrame:CGRectMake(5, self.frame.size.height-16, self.frame.size.width-10, 14)];
	
	[self.contentView addSubview:label1];
	[self.contentView addSubview:label2];
	[self.contentView addSubview:label3];
}

- (UILabel*)createLabelWithFrame:(CGRect)frame
{
	UILabel * label=[[UILabel alloc] initWithFrame:frame];
	label.textAlignment=UITextAlignmentCenter;
	//label.font=[UIFont boldSystemFontOfSize:12];
	label.font=[UIFont fontWithName:@"Verdana" size:12];
	
	label.textColor=[UIColor whiteColor];
	label.backgroundColor=[UIColor clearColor];
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

	imageView.image = image;
	[self setNeedsLayout];
}
- (void)setPictureLabels:(Picture *)newPicture
{
	// set any display labels,e tc.
	
	label1.text=nil;
	label2.text=nil;
	//label3.text=nil;
	
	if([newPicture.name length]>0)
	{
		label1.text=newPicture.name;
		if([newPicture.description length]>0)
		{
			label2.text=newPicture.description;
			label3.text=newPicture.short_created_date;
		}
		else 
		{
			label2.text=newPicture.short_created_date;
		}
	}
	else 
	{
		if([newPicture.description length]>0)
		{
			label1.text=newPicture.description;
			label2.text=newPicture.short_created_date;
		}
		else 
		{
			label1.text=newPicture.short_created_date;
		}
	}
}

- (void) dealloc
{
	[label1 release];
	[label2 release];
	[label3 release];
	//[format release];
	[super dealloc];
}

@end
