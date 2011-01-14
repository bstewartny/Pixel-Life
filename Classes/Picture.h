#import <Foundation/Foundation.h>
#import "PictureDelegate.h"
#import "Item.h"
#import "AsyncImage.h"

//@class AsyncImage;

@interface Picture : Item<AsyncImageDelegate> {
	AsyncImage * asyncImage;
	AsyncImage * asyncThumbnail;
	NSString * description;
	NSInteger width;
	NSInteger height;
	NSObject<PictureDelegate> *delegate;
	NSInteger commentCount;
	NSString * imageURL;
	NSString * thumbnailURL;
}

@property(nonatomic,retain) NSString * imageURL;
@property(nonatomic,retain) NSString * thumbnailURL;
@property(nonatomic,retain) NSString * description;
@property(nonatomic) NSInteger width;
@property(nonatomic) NSInteger height;
@property(nonatomic) NSInteger commentCount;
@property(nonatomic,assign) NSObject<PictureDelegate> * delegate;

- (UIImage*) image;
- (void) unloadImage;
- (UIImage*) thumbnail;
- (BOOL) hasLoadedImage;
- (BOOL) hasLoadedThumbnail;
@end
