#import <UIKit/UIKit.h>
#import "FeedViewController.h"

@interface PhotoCommentsViewController : FeedViewController {
	IBOutlet UITableView * tableView;
	NSArray * comments;
}
@property (nonatomic, retain) IBOutlet UITableView * tableView;

- (void) reloadTable;
- (id)initWithComments:(NSArray*)comments title:(NSString*)title;
- (IBAction) close:(id)sender;

@end
