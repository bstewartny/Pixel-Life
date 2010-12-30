#import <Foundation/Foundation.h>
#import "FacebookFeed.h"

@class Picture;
@interface FacebookPhotoCommentsFeed : FacebookFeed {
	Picture * picture;
}
@property(nonatomic,assign) Picture * picture;

- (id) initWithFacebookAccount:(FacebookAccount*)account picture:(Picture*)picture;


@end
