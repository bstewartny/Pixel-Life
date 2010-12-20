#import <UIKit/UIKit.h>

@class Comment;
@interface CommentTableViewCell : UITableViewCell {
	Comment * comment;
	IBOutlet UIImageView * userImageView;
	IBOutlet UILabel * userLabel;
	IBOutlet UILabel * messageLabel;
	IBOutlet UIActivityIndicatorView * scrollingWheel;
}
@property(nonatomic,retain) Comment	* comment;
@property(nonatomic,retain) IBOutlet UILabel * userLabel;
@property(nonatomic,retain) IBOutlet UILabel * messageLabel;
@property(nonatomic,retain) IBOutlet UIImageView * userImageView;
@property(nonatomic,retain) IBOutlet UIActivityIndicatorView * scrollingWheel;
- (void) load;
+ (CGFloat) heightForMessage:(NSString*)message withWidth:(CGFloat)width;
+ (CGFloat) cellHeightForComment:(Comment*)comment;
@end
