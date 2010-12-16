#import <UIKit/UIKit.h>

@class Feed;

@interface PhotoCommentsViewController : UIViewController {
	IBOutlet UITableView * tableView;
	UIView *loadingView;
	NSArray * items;
	Feed * feed;
	UIActivityIndicatorView * spinningWheel;
}
@property(nonatomic,retain)Feed * feed;
@property(nonatomic,retain)NSArray * items;
@property (nonatomic, retain) IBOutlet UITableView * tableView;

- (void) reloadTable;
- (id)initWithFeed:(Feed*)feed title:(NSString*)title;

- (IBAction) close:(id)sender;


@end
