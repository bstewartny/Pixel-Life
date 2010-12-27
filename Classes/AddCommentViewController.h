#import <UIKit/UIKit.h>

@class Picture;
@interface AddCommentViewController : UIViewController {
	IBOutlet UITextView * messageTextView;
	Picture * picture;
	id delegate;
}
@property(nonatomic,retain) IBOutlet UITextView * messageTextView;
@property(nonatomic,retain) Picture * picture;
@property(nonatomic,assign) id delegate;

- (IBAction) send:(id)sender;

@end
