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

- (void)layoutSubviews {
    [super layoutSubviews];
    //self.imageView.bounds = CGRectMake(,5,50,50);
    self.imageView.frame = CGRectMake(4,4,52,52);
	self.imageView.clipsToBounds=YES;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
	self.imageView.layer.cornerRadius=0;
	self.imageView.layer.borderWidth=2;
	self.imageView.layer.borderColor=[UIColor whiteColor].CGColor;
	
	
    CGRect tmpFrame = self.textLabel.frame;
    tmpFrame.origin.x = 65;
    self.textLabel.frame = tmpFrame;
	
    tmpFrame = self.detailTextLabel.frame;
    tmpFrame.origin.x = 65;
    self.detailTextLabel.frame = tmpFrame;
}

@end
