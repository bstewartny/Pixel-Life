#import <UIKit/UIKit.h>
@class Facebook;

@class PhotoExplorerViewController;
@class Picture;
@class ImageCache;
@class FadeNavigationController;
@interface PhotoExplorerAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	NSOperationQueue * downloadQueue;
	FadeNavigationController * navController;
	UISegmentedControl * segmentedControl;
	Facebook * facebook;
	NSString * accessToken;
	NSDate * expirationDate;
	ImageCache * imageCache;
}
@property (nonatomic, retain) NSOperationQueue *downloadQueue;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet FadeNavigationController * navController;
@property(nonatomic,retain) Facebook * facebook;
@property(nonatomic,retain) ImageCache * imageCache;
+ (PhotoExplorerAppDelegate*) sharedAppDelegate;


- (void) addCommentToPhoto:(Picture*)picture comment:(NSString*)comment;
- (void) likePhoto:(Picture*)picture;


@end

