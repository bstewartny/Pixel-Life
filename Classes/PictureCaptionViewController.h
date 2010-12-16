#import <UIKit/UIKit.h>

@class Picture;

@interface PictureCaptionViewController : UIViewController {
	Picture * picture;
	Picture * friendPicture;
	IBOutlet UIImageView * imageView;
	IBOutlet UILabel * userLabel;
	IBOutlet UILabel * nameLabel;
	IBOutlet UILabel * descriptionLabel;
	IBOutlet UILabel * dateLabel;
}
@property(nonatomic,retain) Picture * picture;
@property(nonatomic,retain) Picture * friendPicture;
@property(nonatomic,retain) IBOutlet UILabel * userLabel;
@property(nonatomic,retain) IBOutlet UILabel * nameLabel;
@property(nonatomic,retain) IBOutlet UILabel * descriptionLabel;
@property(nonatomic,retain) IBOutlet UILabel * dateLabel;
@property(nonatomic,retain) IBOutlet UIImageView * imageView;

@end
