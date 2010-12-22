#import <UIKit/UIKit.h>
#import "AQGridView.h"
#import "FeedViewController.h"

@interface GridViewController : FeedViewController <AQGridViewDelegate, AQGridViewDataSource> {
	IBOutlet AQGridView * gridView;
}
@property (nonatomic, retain) IBOutlet AQGridView * gridView;

- (id)initWithFeed:(Feed*)feed title:(NSString*)title;

@end
