//
//  FriendGridViewCell.m
//  PhotoExplorer
//
//  Created by Robert Stewart on 12/8/10.
//  Copyright 2010 Evernote. All rights reserved.
//

#import "FriendGridViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "Picture.h"

@implementation FriendGridViewCell
 
- (id) initWithFrame: (CGRect) frame reuseIdentifier: (NSString *) aReuseIdentifier
{
	self = [super initWithFrame: frame reuseIdentifier: aReuseIdentifier];
	if ( self == nil )
		return nil;
	
	NSLog(@"FriendGridViewCell frame: %@",NSStringFromCGRect(frame));
	
	CGRect rect=frame; //self.contentView.bounds;
	
	//self.contentView.layer.borderWidth=2;
	//self.contentView.layer.borderColor=[UIColor whiteColor].CGColor;
	
	imageView.frame =CGRectMake(0,0, rect.size.width, rect.size.height);
	imageView.clipsToBounds = YES;
	imageView.contentMode = UIViewContentModeScaleAspectFill;
	
	nameView=[[UIView alloc] initWithFrame:CGRectMake(0,rect.size.height-50,rect.size.width,50)];
	nameView.backgroundColor=[UIColor blackColor];
	nameView.alpha=0.5;
	
	[self.contentView addSubview:nameView];
	[self.contentView bringSubviewToFront:nameView];
	
	[nameView release];
	
	firstNameLabel=[[UILabel alloc] initWithFrame:CGRectMake(10,5,rect.size.width-20,15)];
	firstNameLabel.font=[UIFont boldSystemFontOfSize:14];
	firstNameLabel.textColor=[UIColor whiteColor];
	firstNameLabel.backgroundColor=[UIColor clearColor];
	
	[nameView addSubview:firstNameLabel];
	
	lastNameLabel=[[UILabel alloc] initWithFrame:CGRectMake(10,25,rect.size.width-20,15)];
	lastNameLabel.font=[UIFont boldSystemFontOfSize:14];
	lastNameLabel.textColor=[UIColor whiteColor];
	lastNameLabel.backgroundColor=[UIColor clearColor];
	
	[nameView addSubview:lastNameLabel];
	
	return self;
}

- (void)setPictureLabels:(Picture *)newPicture
{
	firstNameLabel.text=newPicture.name;
	lastNameLabel.text=newPicture.description;
}

-(void)dealloc
{
	[lastNameLabel release];
	[firstNameLabel release];
	[super release];
}

@end
