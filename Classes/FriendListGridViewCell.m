#import "FriendListGridViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation FriendListGridViewCell
- (id) initWithFrame: (CGRect) frame reuseIdentifier: (NSString *) aReuseIdentifier
{
	self = [super initWithFrame: frame reuseIdentifier: aReuseIdentifier];
	if ( self == nil )
		return nil;

	layerView1=[[UIView alloc] initWithFrame:imageView.frame];
	layerView2=[[UIView alloc] initWithFrame:imageView.frame];
	layerView1.backgroundColor=[UIColor clearColor];
	layerView2.backgroundColor=[UIColor clearColor];

	[self.contentView addSubview:layerView1];
	[self.contentView addSubview:layerView2];
	[self.contentView sendSubviewToBack:layerView1];
	[self.contentView sendSubviewToBack:layerView2];
	
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
	
	return self;
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
