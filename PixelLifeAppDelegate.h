#import <UIKit/UIKit.h>

@class Picture;
@class ImageCache;
@class FacebookAccount;

// Your Facebook APP Id must be set before running this example
// See http://www.facebook.com/developers/createapp.php
// Also, your application must bind to the fb[app_id]:// URL
// scheme (substitue [app_id] for your real Facebook app id).
//static NSString* kAppId = @"144746058889817";
#define kAppId  @"174754232546721"

@interface PixelLifeAppDelegate : NSObject <UIApplicationDelegate> 
{
	UINavigationController * navController;
    UIWindow *window;
	NSOperationQueue * downloadQueue;
	ImageCache * imageCache;
	NSMutableArray * facebookAccounts;
	FacebookAccount * currentAccount;
}

+ (PixelLifeAppDelegate*) sharedAppDelegate;

@property (nonatomic, retain) IBOutlet UINavigationController * navController;
@property (nonatomic, retain) NSOperationQueue *downloadQueue;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) ImageCache * imageCache;
@property (nonatomic, retain) NSMutableArray * facebookAccounts;
@property (nonatomic, retain) FacebookAccount * currentAccount;

@end

