#import <UIKit/UIKit.h>

@class Feed;
@protocol FeedDelegate

@required
- (void)feed:(Feed *)feed didFindItems:(NSArray *)items;
- (void)feed:(Feed *)feed didFailWithError:(NSString *)errorMsg;

@end
