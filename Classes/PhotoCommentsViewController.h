#import <UIKit/UIKit.h>
#import "FeedViewController.h"
//@class Picture;
@interface PhotoCommentsViewController : FeedViewController {
	IBOutlet UITableView * tableView;
	NSArray * comments;
	//Picture * picture;
	id delegate;
	BOOL phoneMode;
}
@property (nonatomic, retain) IBOutlet UITableView * tableView;
//@property(nonatomic,retain) Picture * picture;
@property(nonatomic,assign) id delegate;

- (void) reloadTable;
//- (id)initWithComments:(NSArray*)comments title:(NSString*)title;
- (id)initWithFeed:(Feed*)feed title:(NSString*)title  phoneMode:(BOOL)mode;
- (IBAction) close:(id)sender;
- (IBAction) addComment:(id)sender;

@end
