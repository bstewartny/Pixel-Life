#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

#define kLikeActionSheet 1
#define kActionActionSheet 2
@class FriendPictureImageView;
@interface PicturesScrollViewController : UIViewController<MFMailComposeViewControllerDelegate> {
	IBOutlet UIScrollView * scrollView;
	NSArray * pictures;
	NSMutableArray * picViews;
	NSInteger currentItemIndex;
	IBOutlet UIToolbar * toolbar;
	IBOutlet FriendPictureImageView * infoImageView;
	
	IBOutlet UILabel * infoUserLabel;
	IBOutlet UILabel * infoNameLabel;
	IBOutlet UILabel * infoDateLabel;
	IBOutlet UILabel * infoFirstNameLabel;
	IBOutlet UILabel * infoLastNameLabel;
	IBOutlet UILabel * infoNumCommentsLabel;
	
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
@property(nonatomic,retain) IBOutlet FriendPictureImageView * infoImageView;
@property(nonatomic,retain) IBOutlet UILabel * infoUserLabel;
@property(nonatomic,retain) IBOutlet UILabel * infoNameLabel;
@property(nonatomic,retain) IBOutlet UILabel * infoDateLabel;
@property(nonatomic,retain) IBOutlet UILabel * commentCountLabel;
@property(nonatomic,retain) IBOutlet UILabel * infoFirstNameLabel;
@property(nonatomic,retain) IBOutlet UILabel * infoLastNameLabel;
@property(nonatomic,retain) IBOutlet UILabel * infoNumCommentsLabel;

- (IBAction) showComments:(id)sender;
@end
