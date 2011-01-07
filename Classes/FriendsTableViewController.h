#import <UIKit/UIKit.h>
#import "FeedViewController.h"

@interface FriendsTableViewController : FeedViewController <UITableViewDelegate,UITableViewDataSource,UISearchDisplayDelegate>{
	UISearchDisplayController * searchController;
	UISearchBar * searchBar;
	NSMutableArray * filteredItems;
	IBOutlet UITableView * tableView;
}
@property(nonatomic,retain) IBOutlet UITableView * tableView;

- (id)initWithFeed:(Feed*)feed title:(NSString*)title;

@end
