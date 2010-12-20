#import <UIKit/UIKit.h>
@class Facebook;

@class PhotoExplorerViewController;
@class Picture;
@interface PhotoExplorerAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	NSOperationQueue * downloadQueue;
	UINavigationController * navController;
	UISegmentedControl * segmentedControl;
	Facebook * facebook;
	NSString * accessToken;
	NSDate * expirationDate;
}
@property (nonatomic, retain) NSOperationQueue *downloadQueue;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController * navController;
@property(nonatomic,retain) Facebook * facebook;

+ (PhotoExplorerAppDelegate*) sharedAppDelegate;


- (void) addCommentToPhoto:(Picture*)picture comment:(NSString*)comment;
- (void) likePhoto:(Picture*)picture;


@end

