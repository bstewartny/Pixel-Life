#import <Foundation/Foundation.h>
#import "FacebookFeed.h"

@class Picture;
@interface FacebookPhotoCommentsFeed : FacebookFeed {
	Picture * picture;
}
@property(nonatomic,assign) Picture * picture;

- (id) initWithFacebook:(Facebook*)facebook picture:(Picture*)picture;


@end
