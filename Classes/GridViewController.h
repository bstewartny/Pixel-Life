#import <UIKit/UIKit.h>
#import "AQGridView.h"
@class Feed;

@interface GridViewController : UIViewController <AQGridViewDelegate, AQGridViewDataSource> {
	IBOutlet AQGridView * gridView;
	UIView *loadingView;
	NSArray * items;
	Feed * feed;
	UIActivityIndicatorView * spinningWheel;
}
@property(nonatomic,retain)Feed * feed;
@property(nonatomic,retain)NSArray * items;
@property (nonatomic, retain) IBOutlet AQGridView * gridView;

- (void)reloadGrid;
- (id)initWithFeed:(Feed*)feed title:(NSString*)title;

@end
