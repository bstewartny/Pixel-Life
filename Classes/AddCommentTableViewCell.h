#import <UIKit/UIKit.h>

@interface AddCommentTableViewCell : UITableViewCell<UITextViewDelegate> {
	IBOutlet UITextView * messageTextView;
	CGRect origFrame;
}
@property(nonatomic,retain) IBOutlet UITextView * messageTextView;

- (IBAction) addButtonTouch:(id)sender;
- (IBAction) sendMessage:(id)sender;
- (void) load;
@end
