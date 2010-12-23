//
//  AsyncImageDelegate.h
//  PhotoExplorer
//
//  Created by Robert Stewart on 12/23/10.
//  Copyright 2010 Evernote. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AsyncImage;

@protocol AsyncImageDelegate

@required
- (void)image:(AsyncImage *)item couldNotLoadImageError:(NSError *)error;

@optional
- (void)image:(AsyncImage *)item didLoadImage:(UIImage *)image;
@end

@end
