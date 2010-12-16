#import <Foundation/Foundation.h>
#import "FeedDelegate.h"

@interface Feed : NSObject {
	NSObject<FeedDelegate> *delegate;
	
}
@property (nonatomic, assign) NSObject<FeedDelegate> *delegate;

- (void) fetch;


@end
