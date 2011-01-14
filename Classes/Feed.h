#import <Foundation/Foundation.h>
#import "FeedDelegate.h"
@class ASIHTTPRequest;

@interface Feed : NSObject {
	NSObject<FeedDelegate> *delegate;
	
}
@property (nonatomic, assign) NSObject<FeedDelegate> *delegate;

- (void) fetch;

- (ASIHTTPRequest*)createFetchRequest;

@end
