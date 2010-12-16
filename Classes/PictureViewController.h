#import <UIKit/UIKit.h>

@class Picture;
@interface PictureViewController : UIViewController {
	Picture * picture;
	IBOutlet UIImageView * imageView;
	IBOutlet UIActivityIndicatorView * scrollingWheel;
}
@property(nonatomic,retain) Picture * picture;
@property(nonatomic,retain) IBOutlet UIImageView * imageView;
@property(nonatomic,retain) IBOutlet UIActivityIndicatorView * scrollingWheel;

- (id)initWithPicture:(Picture*)picture;

@end
