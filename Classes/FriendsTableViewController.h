#import <UIKit/UIKit.h>
#import "FeedViewController.h"

@interface FriendsTableViewController : FeedViewController <UITableViewDelegate,UITableViewDataSource,UISearchDisplayDelegate>{
	IBOutlet UISearchBar * searchBar;
	NSMutableArray * filteredItems;
	IBOutlet UITableView * tableView;
	IBOutlet UITabBar * tabBar;
	BOOL searching;
	
}
@property(nonatomic,retain) IBOutlet UITableView * tableView;
@property(nonatomic,retain) IBOutlet UITabBar * tabBar;
@property(nonatomic,retain) IBOutlet UISearchBar * searchBar;

- (id)initWithFeed:(Feed*)feed title:(NSString*)title;

@end
