#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

#define kLikeActionSheet 1
#define kActionActionSheet 2
@class PictureImageView;
@interface PicturesScrollViewController : UIViewController<MFMailComposeViewControllerDelegate> {
	IBOutlet UIScrollView * scrollView;
	NSArray * pictures;
	NSMutableArray * picViews;
	NSInteger currentItemIndex;
	IBOutlet UIToolbar * toolbar;
	IBOutlet PictureImageView * infoImageView;
	IBOutlet UILabel * infoUserLabel;
	IBOutlet UILabel * infoNameLabel;
	IBOutlet UILabel * infoDateLabel;
	NSDateFormatter * format;
	IBOutlet UIView * infoView;
	IBOutlet UILabel * commentCountLabel;
	UIPopoverController * addCommentPopover;
	UIPopoverController * showCommentsPopover;
	UIBarButtonItem * showCommentsButton;
	BOOL cancelRemoveBars;
	
}
@property(nonatomic,retain) NSArray * pictures;
@property(nonatomic,retain) IBOutlet UIScrollView * scrollView;
@property(nonatomic) NSInteger currentItemIndex;
@property(nonatomic,retain) IBOutlet UIToolbar * toolbar;
@property(nonatomic,retain) IBOutlet UIView * infoView;
@property(nonatomic,retain) IBOutlet PictureImageView * infoImageView;
@property(nonatomic,retain) IBOutlet UILabel * infoUserLabel;
@property(nonatomic,retain) IBOutlet UILabel * infoNameLabel;
@property(nonatomic,retain) IBOutlet UILabel * infoDateLabel;
@property(nonatomic,retain) IBOutlet UILabel * commentCountLabel;

- (IBAction) showComments:(id)sender;
@end
