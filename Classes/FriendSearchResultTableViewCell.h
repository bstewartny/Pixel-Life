//
//  FriendSearchResultTableViewCell.h
//  PixelLife
//
//  Created by Robert Stewart on 4/13/11.
//  Copyright 2011 OmegaMuse, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PictureTableViewCell.h"

@interface FriendSearchResultTableViewCell : PictureTableViewCell {
	UILabel * nameLabel;
	UILabel * summaryLabel;
}
@property(nonatomic,retain) UILabel * nameLabel;
@property(nonatomic,retain) UILabel * summaryLabel;
@end
