//
//  FriendSearchResultTableViewCell.m
//  PixelLife
//
//  Created by Robert Stewart on 4/13/11.
//  Copyright 2011 OmegaMuse, LLC. All rights reserved.
//

#import "FriendSearchResultTableViewCell.h"
 #import <QuartzCore/QuartzCore.h>

@implementation FriendSearchResultTableViewCell
@synthesize nameLabel,summaryLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	if(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])
	{
		nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(84, 0, 220, 24)];
		nameLabel.backgroundColor=[UIColor clearColor];
		nameLabel.font=[UIFont fontWithName:@"Verdana" size:20];
		nameLabel.autoresizingMask=UIViewAutoresizingFlexibleWidth;
		nameLabel.textColor=[UIColor lightGrayColor];
		nameLabel.adjustsFontSizeToFitWidth=YES;
		nameLabel.minimumFontSize=14;
		
		summaryLabel=[[UILabel alloc] initWithFrame:CGRectMake(84, 28, 190, 18)];
		summaryLabel.backgroundColor=[UIColor clearColor];
		summaryLabel.font=[UIFont fontWithName:@"Verdana" size:16];
		summaryLabel.textColor=[UIColor lightGrayColor];
		summaryLabel.autoresizingMask=UIViewAutoresizingFlexibleWidth;
		[self.contentView addSubview:nameLabel];
		[self.contentView addSubview:summaryLabel];
	
	}
	return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(2,2,76,76);
	self.imageView.clipsToBounds=YES;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
	self.imageView.layer.cornerRadius=0;
	
	CGRect f=self.bounds;
	
	nameLabel.frame=CGRectMake(84, 0, f.size.width-84, 24);
	summaryLabel.frame=CGRectMake(84,28,f.size.width-84,18);  
    
}
- (void) dealloc
{
	[nameLabel release];
	[summaryLabel release];
	[super dealloc];
}

@end
