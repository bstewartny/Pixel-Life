//
//  PictureGridViewCell.h
//  PhotoExplorer
//
//  Created by Robert Stewart on 12/8/10.
//  Copyright 2010 Evernote. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GridViewCell.h"

@class Picture;
@interface PictureGridViewCell : GridViewCell {
	Picture * picture;
	UIImageView * imageView;
}
@property(nonatomic,retain) Picture * picture;
@end
