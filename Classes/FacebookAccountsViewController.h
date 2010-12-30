#import <UIKit/UIKit.h>

@class Facebook;
@class FacebookAccountInfoFeed;
@interface FacebookAccountsViewController : UIViewController {
	NSMutableArray * accounts;
	id delegate;
	IBOutlet UITableView * tableView;
	Facebook * facebook;
	FacebookAccountInfoFeed * infoFeed;
}
@property(nonatomic,retain) NSMutableArray * accounts;
@property(nonatomic,retain) IBOutlet UITableView * tableView;

@property(nonatomic,assign) id delegate;

-(id) initWithAccounts:(NSMutableArray*)accounts;

- (IBAction) addAccount:(id)sender;
- (IBAction) editAccounts:(id)sender;
- (IBAction) done:(id)sender;

@end
