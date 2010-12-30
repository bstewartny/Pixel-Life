#import <UIKit/UIKit.h>
#define kActionSheetSettings 3434

//@class Facebook;
@class PhotoExplorerViewController;
@class Picture;
@class ImageCache;
@class FadeNavigationController;
@class FacebookAccount;

// Your Facebook APP Id must be set before running this example
// See http://www.facebook.com/developers/createapp.php
// Also, your application must bind to the fb[app_id]:// URL
// scheme (substitue [app_id] for your real Facebook app id).
//static NSString* kAppId = @"144746058889817";
#define kAppId  @"174754232546721"

@interface PhotoExplorerAppDelegate : NSObject <UIApplicationDelegate> 
{
    UIWindow *window;
	NSOperationQueue * downloadQueue;
	FadeNavigationController * navController;
	UISegmentedControl * segmentedControl;
	//Facebook * facebook;
	//NSString * accessToken;
	//NSDate * expirationDate;
	ImageCache * imageCache;
	NSMutableArray * facebookAccounts;
	FacebookAccount * currentAccount;
}

@property (nonatomic, retain) NSOperationQueue *downloadQueue;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet FadeNavigationController * navController;
//@property (nonatomic, retain) Facebook * facebook;
@property (nonatomic, retain) ImageCache * imageCache;
@property (nonatomic, retain) NSMutableArray * facebookAccounts;
@property (nonatomic, retain) FacebookAccount * currentAccount;

+ (PhotoExplorerAppDelegate*) sharedAppDelegate;

- (void) addCommentToPhoto:(Picture*)picture comment:(NSString*)comment;
- (void) likePhoto:(Picture*)picture;

@end

