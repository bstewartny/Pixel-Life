#import <Foundation/Foundation.h>
#import "AsyncImageDelegate.h"

@class ASIHTTPRequest;

@interface AsyncImage : NSObject {
	NSString * url;
	UIImage * image;
	BOOL dealloc_called;
	ASIHTTPRequest * imageRequest;
	NSObject<AsyncImageDelegate> * delegate;
}
@property(nonatomic,retain) NSString * url;
@property(nonatomic,retain) UIImage * image;
@property(nonatomic,assign) NSObject<AsyncImageDelegate> * delegate;

- (BOOL) hasLoadedImage;

@end
