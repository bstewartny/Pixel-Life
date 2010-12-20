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
    
	gregorian=[[NSCalendar alloc]
							initWithCalendarIdentifier:NSGregorianCalendar];
	
	format = [[NSDateFormatter alloc] init];
	[format setDateFormat:@"MMM d, yyyy"];
	
    imageView.frame = CGRectMake(5, 5, frame.size.width-10, frame.size.height-50);
	imageView.clipsToBounds = NO;
	maxImageSize=CGSizeMake(imageView.frame.size.width, imageView.frame.size.height);
	imageView.contentMode = UIViewContentModeScaleAspectFit;
    
	label1=[self createLabelWithFrame:CGRectMake(5, frame.size.height-42, frame.size.width-10, 14)];
	label2=[self createLabelWithFrame:CGRectMake(5, frame.size.height-28, frame.size.width-10, 14)];
	label3=[self createLabelWithFrame:CGRectMake(5, frame.size.height-14, frame.size.width-10, 14)];
	
	UIPinchGestureRecognizer * p=[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
	
	[imageView addGestureRecognizer:p];
	
	[p release];
	
	
	[self.contentView addSubview:label1];
	[self.contentView addSubview:label2];
	[self.contentView addSubview:label3];
		
    return self;
}

- (void)pinch:(UIGestureRecognizer*)g
{
	UIPinchGestureRecognizer * p=(UIPinchGestureRecognizer*)g;
	
	NSLog(@"pinch: velocity: %f, scale: %f",p.velocity,p.scale);
	if(p.velocity>0)
	{
		GridViewController * controller=[self parentViewController];
	
		AQGridView * gridView=[controller gridView];
	
		NSUInteger index=[gridView indexForCell:self];
	
		[controller gridView:gridView didSelectItemAtIndex:index];
	}
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

	imageView.image = image;
}

- (NSString*) shortDisplayDate:(NSDate*)date
{
	NSDate *todayDate = [NSDate date];
	 
	NSDateComponents * today_components=[gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit  |NSHourCalendarUnit  |NSMinuteCalendarUnit) fromDate:todayDate];
	
	NSDateComponents * item_components=[gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit  |NSHourCalendarUnit  |NSMinuteCalendarUnit) fromDate:date];
	
	NSString * display;
	
	if(([today_components day] == [item_components day]) &&
	   ([today_components month] == [item_components month]) &&
	   ([today_components year] == [item_components year]))
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

- (void)setPictureLabels:(Picture *)newPicture
{
	// set any display labels,e tc.
	
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
		else {
			label2.text=[self shortDisplayDateWithPicture:newPicture];
			
		}
/*
		if([newPicture.comments count]>0)
		{
			if([newPicture.comments count]==1)
			{
				label2.text=@"1 comment"; //[NSString stringWithFormat:@"%d comments",[newPicture.comments count]];
			}
			else 
			{
				label2.text=[NSString stringWithFormat:@"%d comments",[newPicture.comments count]];
			}
			label3.text=[self shortDisplayDateWithPicture:newPicture];
		}
		else 
		{
			label2.text=[self shortDisplayDateWithPicture:newPicture];
		}
		*/
	}
	else 
	{
		if([newPicture.description length]>0)
		{
			label1.text=newPicture.description;
			label2.text=[self shortDisplayDateWithPicture:newPicture];
		}
		else {
			label1.text=[self shortDisplayDateWithPicture:newPicture];
			
		}
		/*if([newPicture.comments count]>0)
		{
			if([newPicture.comments count]==1)
			{
				label1.text=@"1 comment"; //[NSString stringWithFormat:@"%d comments",[newPicture.comments count]];
			}
			else 
			{
				label1.text=[NSString stringWithFormat:@"%d comments",[newPicture.comments count]];
			}
			label2.text=[self shortDisplayDateWithPicture:newPicture];
		}
		else 
		{
			label1.text=[self shortDisplayDateWithPicture:newPicture];
		}*/
	}
}

- (void) dealloc
{
	[label1 release];
	[label2 release];
	[label3 release];
	[gregorian release];
	[format release];
	[super dealloc];
}

@end
