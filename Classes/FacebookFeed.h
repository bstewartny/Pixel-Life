#import <Foundation/Foundation.h>
#import "Feed.h"
@class FacebookAccount;

@interface FacebookFeed : Feed {
	FacebookAccount * account;
	NSDateFormatter * formatter;
}
@property(nonatomic,retain) FacebookAccount * account;
- (id) initWithFacebookAccount:(FacebookAccount*)account;

- (NSString*) graphPath;

- (NSArray*) getItemsFromJson:(NSDictionary*)json;

@end
