#import <Foundation/Foundation.h>
#import "PictureDelegate.h"
#import "Item.h"
@class AsyncImage;
//@class ASIHTTPRequest;
@interface Picture : Item {
	AsyncImage * asyncImage;
	AsyncImage * asyncThumbnail;
	//NSString * imageURL;
	//NSString * thumbnailURL;
	NSString * description;
	NSInteger width;
	NSInteger height;
	//UIImage * image;
	//UIImage * thumbnail;
	NSObject<PictureDelegate> *delegate;
	//BOOL downloadFailed;
	//ASIHTTPRequest *thumbnailRequest;
	//ASIHTTPRequest *imageRequest;
	//BOOL dealloc_called;
	NSInteger commentCount;
	//NSArray * comments;
}
@property(nonatomic,retain) AsyncImage * asyncImage;
@property(nonatomic,retain) AsyncImage * asyncThumbnail;
@property(nonatomic,retain) NSString * imageURL;
@property(nonatomic,retain) NSString * thumbnailURL;
@property(nonatomic,retain) NSString * description;
//@property(nonatomic,retain) UIImage * image;
//@property(nonatomic,retain) UIImage * thumbnail;
//@property(nonatomic,retain) NSArray * comments;
@property(nonatomic) NSInteger width;
@property(nonatomic) NSInteger height;
@property(nonatomic) NSInteger commentCount;

@property(nonatomic,assign) NSObject<PictureDelegate> * delegate;

- (UIImage*) image;
- (UIImage*) thumbnail;
- (BOOL) hasLoadedImage;
- (BOOL) hasLoadedThumbnail;
@end
