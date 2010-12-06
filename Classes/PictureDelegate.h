//
//  PictureDelegate.h
//  PhotoExplorer
//
//  Created by Robert Stewart on 12/4/10.
//  Copyright 2010 Evernote. All rights reserved.
//

#import <Foundation/Foundation.h>


@class Picture;

@protocol PictureDelegate

@required
- (void)picture:(Picture *)item couldNotLoadImageError:(NSError *)error;

@optional
- (void)picture:(Picture *)item didLoadImage:(UIImage *)image;

@end
