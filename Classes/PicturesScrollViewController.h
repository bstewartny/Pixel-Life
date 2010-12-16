#import <UIKit/UIKit.h>

@interface PicturesScrollViewController : UIViewController {
	IBOutlet UIScrollView * scrollView;
	NSArray * pictures;
	NSMutableArray * picViews;
	NSInteger currentItemIndex;
	IBOutlet UIToolbar * toolbar;
	IBOutlet UIImageView * infoImageView;
	IBOutlet UILabel * infoUserLabel;
	IBOutlet UILabel * infoNameLabel;
	IBOutlet UILabel * infoDateLabel;
	NSDateFormatter * format;
	IBOutlet UIView * infoView;
	
}
@property(nonatomic,retain) NSArray * pictures;
@property(nonatomic,retain) IBOutlet UIScrollView * scrollView;
@property(nonatomic) NSInteger currentItemIndex;
@property(nonatomic,retain) IBOutlet UIToolbar * toolbar;
@property(nonatomic,retain) IBOutlet UIView * infoView;
@property(nonatomic,retain) IBOutlet UIImageView * infoImageView;
@property(nonatomic,retain) IBOutlet UILabel * infoUserLabel;
@property(nonatomic,retain) IBOutlet UILabel * infoNameLabel;
@property(nonatomic,retain) IBOutlet UILabel * infoDateLabel;

@end
