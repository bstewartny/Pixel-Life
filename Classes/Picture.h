//
//  Picture.h
//  PhotoExplorer
//
//  Created by Robert Stewart on 12/4/10.
//  Copyright 2010 Evernote. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PictureDelegate.h"
#import "Item.h"
@class ASIHTTPRequest;
@interface Picture : Item {
	NSString * imageURL;
	NSString * thumbnailURL;
	NSString * description;
	NSInteger width;
	NSInteger height;
	UIImage * image;
	UIImage * thumbnail;
	NSObject<PictureDelegate> *delegate;
	BOOL downloadFailed;
	ASIHTTPRequest *thumbnailRequest;
	ASIHTTPRequest *imageRequest;
	BOOL dealloc_called;
}
@property(nonatomic,retain) NSString * imageURL;
@property(nonatomic,retain) NSString * thumbnailURL;
@property(nonatomic,retain) NSString * description;

@property(nonatomic,retain) UIImage * image;
@property(nonatomic,retain) UIImage * thumbnail;
@property(nonatomic) NSInteger width;
@property(nonatomic) NSInteger height;

@property(nonatomic,assign) NSObject<PictureDelegate> * delegate;

- (BOOL) hasLoadedImage;
- (BOOL) hasLoadedThumbnail;
@end
