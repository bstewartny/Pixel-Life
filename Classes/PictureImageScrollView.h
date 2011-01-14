#import <UIKit/UIKit.h>
@class Picture;
@class PictureImageView;
@interface PictureImageScrollView : UIScrollView <UIScrollViewDelegate> {
    PictureImageView *imageView;
    NSUInteger     index;
	Picture * picture;
}
@property (assign) NSUInteger index;
@property(nonatomic,retain) Picture * picture;

- (id) initWithFrame: (CGRect) frame picture: (Picture *) picture;

- (void)displayImage:(UIImage *)image;
- (void)configureForImageSize:(CGSize)imageSize;
- (void) load;
- (void) unload;

- (void) toggleZoomAtTouchPoint:(CGPoint)point;
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center;
- (CGFloat) calculateMaxZoomScale;
- (void) setImageContentMode:(UIViewContentMode)mode;

@end
