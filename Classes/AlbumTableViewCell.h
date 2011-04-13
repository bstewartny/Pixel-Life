//
//  AlbumTableViewCell.h
//  PixelLife
//
//  Created by Robert Stewart on 3/7/11.
//  Copyright 2011 OmegaMuse, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PictureTableViewCell.h"

@interface AlbumTableViewCell : PictureTableViewCell {
	UILabel * nameLabel;
	UILabel * summaryLabel1;
	UILabel * summaryLabel2;
	UILabel * summaryLabel3;
}
@property(nonatomic,retain) UILabel * nameLabel;
@property(nonatomic,retain) UILabel * summaryLabel1;
@property(nonatomic,retain) UILabel * summaryLabel2;
@property(nonatomic,retain) UILabel * summaryLabel3;

@end
