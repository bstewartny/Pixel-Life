#import <Foundation/Foundation.h>

@interface ImageCache : NSObject {
	NSMutableDictionary * cache;
}

- (UIImage*) imageForUrl:(NSString*)url;

- (void) setImage:(UIImage*)image forUrl:(NSString*)url;

- (void) clear;

@end
