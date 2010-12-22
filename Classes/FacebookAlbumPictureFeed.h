#import <Foundation/Foundation.h>
#import "FacebookFeed.h"

@class Album;
@interface FacebookAlbumPictureFeed : FacebookFeed {
	Album * album;
}
@property(nonatomic,assign) Album * album;

- (id) initWithFacebook:(Facebook*)facebook album:(Album*)album;

@end
