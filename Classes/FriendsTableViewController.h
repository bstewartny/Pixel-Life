#import <UIKit/UIKit.h>
#import "PictureTableViewController.h"

@interface FriendsTableViewController : PictureTableViewController <UISearchDisplayDelegate>{
	IBOutlet UISearchBar * searchBar;
	NSMutableArray * filteredItems;
	BOOL searching;
}
@property(nonatomic,retain) IBOutlet UISearchBar * searchBar;

- (id)initWithFeed:(Feed*)feed title:(NSString*)title;

@end
