#import <UIKit/UIKit.h>

@interface PhotoCommentsViewController : UIViewController {
	IBOutlet UITableView * tableView;
	NSArray * comments;
}
@property(nonatomic,retain)NSArray * comments;
@property (nonatomic, retain) IBOutlet UITableView * tableView;

- (void) reloadTable;
- (id)initWithComments:(NSArray*)comments title:(NSString*)title;
- (IBAction) close:(id)sender;

@end
