#import <Foundation/Foundation.h>
#import "GridViewController.h"

@interface FriendsGridViewController : GridViewController <UITableViewDelegate,UITableViewDataSource,UISearchDisplayDelegate> {
	UISearchDisplayController * searchController;
	UISearchBar * searchBar;
	NSMutableArray * filteredItems;
}

@end
