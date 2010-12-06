//
//  PictureViewController.h
//  PhotoExplorer
//
//  Created by Robert Stewart on 12/6/10.
//  Copyright 2010 Evernote. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Picture;
@interface PictureViewController : UIViewController {
	Picture * picture;
	IBOutlet UIImageView * imageView;
	IBOutlet UIActivityIndicatorView * scrollingWheel;
}
@property(nonatomic,retain) Picture * picture;
@property(nonatomic,retain) IBOutlet UIImageView * imageView;
@property(nonatomic,retain) IBOutlet UIActivityIndicatorView * scrollingWheel;

- (id)initWithPicture:(Picture*)picture;

@end
