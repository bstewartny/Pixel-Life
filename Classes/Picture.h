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

@interface Picture : Item {
	NSString * imageURL;
	UIImage * image;
	NSObject<PictureDelegate> *delegate;
	BOOL downloadFailed;
}
@property(nonatomic,retain) NSString * imageURL;
@property(nonatomic,retain) UIImage * image;

@property(nonatomic,assign) NSObject<PictureDelegate> * delegate;

- (BOOL) hasLoadedImage;
@end
