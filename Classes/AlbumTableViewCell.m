//
//  AlbumTableViewCell.m
//  PixelLife
//
//  Created by Robert Stewart on 3/7/11.
//  Copyright 2011 OmegaMuse, LLC. All rights reserved.
//

#import "AlbumTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation AlbumTableViewCell
@synthesize nameLabel,summaryLabel1,summaryLabel2,summaryLabel3;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	if(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])
	{
		//self.backgroundColor=[UIColor viewFlipsideBackgroundColor];
		//self.contentView.backgroundColor=[UIColor viewFlipsideBackgroundColor];
	
		nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(120, 0, 196, 24)];
		nameLabel.backgroundColor=[UIColor clearColor];
		nameLabel.font=[UIFont fontWithName:@"Verdana" size:20];
		nameLabel.textColor=[UIColor lightGrayColor];
		nameLabel.autoresizingMask=UIViewAutoresizingFlexibleWidth;
		nameLabel.baselineAdjustment=UIBaselineAdjustmentAlignCenters;
		
		nameLabel.adjustsFontSizeToFitWidth=YES;
		nameLabel.minimumFontSize=14;
		
		summaryLabel1=[[UILabel alloc] initWithFrame:CGRectMake(120, 28, 196, 18)];
		summaryLabel1.backgroundColor=[UIColor clearColor];
		summaryLabel1.font=[UIFont fontWithName:@"Verdana" size:16];
		summaryLabel1.textColor=[UIColor lightGrayColor];
		summaryLabel1.autoresizingMask=UIViewAutoresizingFlexibleWidth;
		summaryLabel2=[[UILabel alloc] initWithFrame:CGRectMake(120, 50, 196, 18)];
		summaryLabel2.backgroundColor=[UIColor clearColor];
		summaryLabel2.font=[UIFont fontWithName:@"Verdana" size:16];
		summaryLabel2.textColor=[UIColor lightGrayColor];
		summaryLabel2.autoresizingMask=UIViewAutoresizingFlexibleWidth;
		summaryLabel3=[[UILabel alloc] initWithFrame:CGRectMake(120, 70, 196, 18)];
		summaryLabel3.backgroundColor=[UIColor clearColor];
		summaryLabel3.font=[UIFont fontWithName:@"Verdana" size:16];
		summaryLabel3.textColor=[UIColor lightGrayColor];
		summaryLabel3.autoresizingMask=UIViewAutoresizingFlexibleWidth;
		[self.contentView addSubview:nameLabel];
		[self.contentView addSubview:summaryLabel1];
		[self.contentView addSubview:summaryLabel2];
		[self.contentView addSubview:summaryLabel3];
	}
	return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //self.imageView.bounds = CGRectMake(,5,50,50);
    self.imageView.frame = CGRectMake(4,4,112,112);
	self.imageView.clipsToBounds=YES;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
	self.imageView.layer.cornerRadius=0;
	self.imageView.layer.borderWidth=0;
	//self.imageView.layer.borderColor=[UIColor whiteColor].CGColor;
	
	
	
	/*
    CGRect tmpFrame = self.textLabel.frame;
    tmpFrame.origin.x = 120;
    self.textLabel.frame = tmpFrame;
	
    tmpFrame = self.detailTextLabel.frame;
    tmpFrame.origin.x = 120;
    self.detailTextLabel.frame = tmpFrame;*/
}

- (void) dealloc
{
	[nameLabel release];
	[summaryLabel1 release];
	[summaryLabel2 release];
	[summaryLabel3 release];

	[super dealloc];
}

@end
