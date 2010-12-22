//
//  AsyncImage.h
//  PhotoExplorer
//
//  Created by Robert Stewart on 12/22/10.
//  Copyright 2010 Evernote. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncImageDelegate.h"

#class ASIHTTPRequest;

@interface AsyncImage : NSObject {
	NSString * url;
	UIImage * image;
	BOOL dealloc_called;
	ASIHTTPRequest * imageRequest;
	NSObject<AsyncImageDelegate) * delegate;
}
@property(nonatomic,retain) NSString * url;
@property(nonatomic,retain) UIImage * image;
@property(nonatomic,assign) NSObject<AsyncImageDelegate) * delegate;

- (BOOL) hasLoadedImage;

@end
