#import <UIKit/UIKit.h>

@class Picture;
@class PictureImageView;

@interface PictureScrollView : UIScrollView {
	PictureImageView * pictureImageView;
}

- (id) initWithFrame: (CGRect) frame picture: (Picture *) picture;

- (void) load;
- (void) unload;

@end
