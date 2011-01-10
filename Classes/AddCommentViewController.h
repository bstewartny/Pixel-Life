#import <UIKit/UIKit.h>

@class Picture;
@interface AddCommentViewController : UIViewController<UITextViewDelegate> {
	IBOutlet UITextView * messageTextView;
	id delegate;
}
@property(nonatomic,retain) IBOutlet UITextView * messageTextView;
@property(nonatomic,assign) id delegate;

- (IBAction) send:(id)sender;
- (IBAction) cancel:(id)sender;

@end
