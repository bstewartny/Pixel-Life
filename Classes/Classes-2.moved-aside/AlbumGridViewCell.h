//
//  AlbumGridViewCell.h
//  PhotoExplorer
//
//  Created by Robert Stewart on 12/5/10.
//  Copyright 2010 Evernote. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GridViewCell.h"
@class Album;
@interface AlbumGridViewCell : GridViewCell {
	Album * album;
	UIImageView * imageView;
	UILabel * titleLabel;
	UILabel * dateLabel;
}
@property(nonatomic,retain) Album * album;

@end
