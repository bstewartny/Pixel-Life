#import <Foundation/Foundation.h>
#import "FacebookFeed.h"

@class Album;
@interface FacebookAlbumPictureFeed : FacebookFeed {
	Album * album;
}
@property(nonatomic,retain) Album * album;

- (id) initWithFacebook:(Facebook*)facebook album:(Album*)album;

@end
