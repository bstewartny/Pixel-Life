#import <Foundation/Foundation.h>
#import "GridViewController.h"
@class Friend;

@interface FriendsGridViewController : GridViewController <UITableViewDelegate,UITableViewDataSource,UISearchDisplayDelegate> {
	UISearchDisplayController * searchController;
	UISearchBar * searchBar;
	NSMutableArray * filteredItems;
}
- (void) showFriendAlbums:(Friend*)friend;

@end
