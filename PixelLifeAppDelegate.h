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
#define kActionSheetSettings 3434

/*
	TODO: 
		fix ipad start screen showing on 3GS with 4.1 OS
		dont pop up memory warning alerts
		fix memory leaks
		analyze code
		fix warnings
		make archive
		verify archived code
		simple help/intro screen to show what icons do...
		dont default to zoomed in images...
		make borders btween images in scroll view
		remove sort option in slideshow options
 
 
 
 
*/



@class PLNavigationController;
@interface PixelLifeAppDelegate : NSObject <UIApplicationDelegate,UIActionSheetDelegate> 
{
	PLNavigationController * navController;
	
	//UINavigationController * navController;
    UIWindow *window;
	NSOperationQueue * downloadQueue;
	ImageCache * imageCache;
	NSMutableArray * facebookAccounts;
	FacebookAccount * currentAccount;
}

+ (PixelLifeAppDelegate*) sharedAppDelegate;

@property (nonatomic, retain) IBOutlet PLNavigationController * navController;
@property (nonatomic, retain) NSOperationQueue *downloadQueue;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) ImageCache * imageCache;
@property (nonatomic, retain) NSMutableArray * facebookAccounts;
@property (nonatomic, retain) FacebookAccount * currentAccount;

- (BOOL) isPhone;
- (void) sendComment:(NSString*)comment uid:(NSString*)uid;
- (void) likeGraphObject:(NSString*)uid;

- (void) setupWindow;
- (void) loadArchivedData;
- (void) showAllFriends;
- (void) showAllLists;
- (void) showNoFriends;
- (void) showMyAlbums;

- (void) clearCache;
- (void) showAccounts;
- (void) login;
- (void) logout;
- (void) saveData;
 


@end

