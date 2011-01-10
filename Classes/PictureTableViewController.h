#import <UIKit/UIKit.h>
#import "FeedViewController.h"

@interface PictureTableViewController : FeedViewController <UITableViewDelegate,UITableViewDataSource>{
	IBOutlet UITableView * tableView;
	IBOutlet UITabBar * tabBar;
}

@property(nonatomic,retain) IBOutlet UITableView * tableView;
@property(nonatomic,retain) IBOutlet UITabBar * tabBar;
- (id)initWithFeed:(Feed*)feed title:(NSString*)title;


@end
