#import <UIKit/UIKit.h>
#import "FeedViewController.h"
@class Comment;
@interface PhotoCommentsViewController : FeedViewController {
	IBOutlet UITableView * tableView;
	id delegate;
	BOOL phoneMode;
	Comment * pictureComment;
}
@property (nonatomic, retain) IBOutlet UITableView * tableView;
@property(nonatomic,assign) id delegate;
@property(nonatomic,retain) Comment * pictureComment;

- (void) reloadTable;
- (id)initWithFeed:(Feed*)feed title:(NSString*)title  phoneMode:(BOOL)mode;
- (IBAction) close:(id)sender;
- (IBAction) addComment:(id)sender;

@end
