#import <UIKit/UIKit.h>

@class Comment;
@interface CommentTableViewCell : UITableViewCell {
	Comment * comment;
	IBOutlet UIImageView * userImageView;
	IBOutlet UILabel * userLabel;
	//IBOutlet UILabel * dateLabel;
	IBOutlet UILabel * messageLabel;
}
@property(nonatomic,retain) Comment	* comment;
@property(nonatomic,retain) IBOutlet UILabel * userLabel;
//@property(nonatomic,retain) IBOutlet UILabel * dateLabel;
@property(nonatomic,retain) IBOutlet UILabel * messageLabel;
@property(nonatomic,retain) IBOutlet UIImageView * userImageView;
- (void) load;

@end
