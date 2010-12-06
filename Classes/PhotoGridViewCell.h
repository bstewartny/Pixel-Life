//
//  PhotoGridViewCell.h
//  PhotoExplorer
//
//  Created by Robert Stewart on 12/4/10.
//  Copyright 2010 Evernote. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GridViewCell.h"

@class Picture;

@interface PhotoGridViewCell : GridViewCell {
	Picture * picture;
	UIImageView * imageView;
	UILabel * titleLabel;
	UILabel * descriptionLabel;
}
@property(nonatomic,retain) Picture * picture;
@end
