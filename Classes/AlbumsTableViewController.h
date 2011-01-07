#import <UIKit/UIKit.h>
#import "FeedViewController.h"

@interface AlbumsTableViewController : FeedViewController <UITableViewDelegate,UITableViewDataSource> {
	IBOutlet UITableView * tableView;
}
@property(nonatomic,retain) IBOutlet UITableView * tableView;

- (id)initWithFeed:(Feed*)feed title:(NSString*)title;

@end
