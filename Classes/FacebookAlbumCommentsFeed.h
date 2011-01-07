#import <Foundation/Foundation.h>
#import "FacebookFeed.h"

@class Album;
@interface FacebookAlbumCommentsFeed : FacebookFeed {
	Album * album;
}
@property(nonatomic,assign) Album * album;

- (id) initWithFacebookAccount:(FacebookAccount*)account album:(Album*)album;

@end
