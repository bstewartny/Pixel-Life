//
//  PictureCache.h
//  PhotoExplorer
//
//  Created by Robert Stewart on 12/22/10.
//  Copyright 2010 Evernote. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ImageCache : NSObject {
	NSMutableDictionary * cache;
}

- (UIImage*) imageForUrl:(NSString*)url;

- (void) setImage:(UIImage*)image forUrl:(NSString*)url;

@end
