#import <UIKit/UIKit.h>
@class Picture;

@interface PictureTableViewCell : UITableViewCell 
{
	//IBOutlet UIImageView * pictureImageView;
	//IBOutlet UILabel * nameLabel;
	Picture * picture;
	BOOL dealloc_called;
	//IBOutlet UIActivityIndicatorView * scrollingWheel;
	BOOL useLargeImage;
}
@property(nonatomic) BOOL useLargeImage;
@property(nonatomic,retain) Picture * picture;
//@property(nonatomic,retain) IBOutlet UIImageView * pictureImageView;
//@property(nonatomic,retain) IBOutlet UILabel * nameLable;
//@property(nonatomic,retain) IBOutlet UIActivityIndicatorView * scrollingWheel;

- (void) load;

@end
