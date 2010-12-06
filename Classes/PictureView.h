//
//  PictureView.h
//  PhotoExplorer
//
//  Created by Robert Stewart on 12/4/10.
//  Copyright 2010 Evernote. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PictureDelegate.h"
 
@class Picture;

@interface PictureView : UIView<PictureDelegate> {
	Picture * picture;
	UIImageView * imageView;
	UIActivityIndicatorView * scrollingWheel;
}
@property (nonatomic, retain) Picture * picture;

- (void)loadImage;


@end
