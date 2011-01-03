#import <UIKit/UIKit.h>

@class Picture;

@interface PictureImageView : UIImageView {
	Picture * picture;
	BOOL delegateWasSet;
	UIView * infoView;
	UIActivityIndicatorView * scrollingWheel;
	
}
@property(nonatomic,retain) Picture * picture;
- (id) initWithFrame: (CGRect) frame picture: (Picture *) picture;
- (void) load;

@end
