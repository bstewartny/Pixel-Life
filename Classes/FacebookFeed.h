#import <Foundation/Foundation.h>
#import "Feed.h"
@class Facebook;

@interface FacebookFeed : Feed {
	Facebook * facebook;
	NSDateFormatter * formatter;
}
@property(nonatomic,retain) Facebook * facebook;
- (id) initWithFacebook:(Facebook*)facebook;

- (NSString*) graphPath;

- (NSArray*) getItemsFromJson:(NSDictionary*)json;

@end
