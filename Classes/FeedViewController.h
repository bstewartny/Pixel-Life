#import <UIKit/UIKit.h>

#import "FeedDelegate.h"

@class Feed;

@interface FeedViewController : UIViewController<FeedDelegate> {
	UIView *loadingView;
	NSArray * items;
	Feed * feed;
	UIActivityIndicatorView * spinningWheel; 
}
@property(nonatomic,retain)Feed * feed;
@property(nonatomic,retain)NSArray * items;

- (void) refresh;

- (void)reloadFeed;
- (void)reloadData;
- (id)initWithFeed:(Feed*)feed title:(NSString*)title withNibName:(NSString*)nibName;


@end
