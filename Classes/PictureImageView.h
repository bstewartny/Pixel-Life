//
//  PictureImageView.h
//  PhotoExplorer
//
//  Created by Robert Stewart on 12/6/10.
//  Copyright 2010 Evernote. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Picture;

@interface PictureImageView : UIImageView {
	Picture * picture;
	BOOL delegateWasSet;
	UIView * infoView;
	UIActivityIndicatorView * scrollingWheel;
	
}
@property(nonatomic,retain) Picture * picture;

- (void) load;

@end
