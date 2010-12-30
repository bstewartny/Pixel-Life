#import "PhotoExplorerAppDelegate.h"
#import "AlbumsGridViewController.h"
#import "FriendsGridViewController.h"
#import "FacebookMyAlbumsFeed.h"
#import "FacebookFriendsAlbumsFeed.h"
#import "PictureFeedGridViewController.h"
#import "FacebookFriendsPhotosFeed.h"
#import "FacebookLikesFeed.h"
#import "Feed.h"
#import "FBConnect.h"
#import "FacebookFriendFeed.h"
#import "UserSettings.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"
#import "FacebookFriendsAlbumsFeed.h"
#import "FriendListsGridViewController.h"
#import "FacebookFriendListsFeed.h"
#import "ImageCache.h"
#import "FadeNavigationController.h"
#import "BlankToolbar.h"
#import "Reachability.h"
#import "FacebookAccount.h"
#import "FacebookAccountsViewController.h"
@implementation PhotoExplorerAppDelegate

@synthesize window;
@synthesize downloadQueue;
@synthesize navController;
//@synthesize facebook;
@synthesize imageCache;
@synthesize facebookAccounts;
@synthesize currentAccount;

+ (PhotoExplorerAppDelegate *)sharedAppDelegate
{
    return (PhotoExplorerAppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
	ASIDownloadCache * cache=[ASIDownloadCache sharedCache];
	cache.shouldRespectCacheControlHeaders=YES;
	
	[cache setDefaultCachePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy|ASIFallbackToCacheIfLoadFailsCachePolicy];
	 
	[ASIHTTPRequest setDefaultCache:cache];
	
	imageCache=[[ImageCache alloc] init];
	
	downloadQueue = [[NSOperationQueue alloc] init];
	
	[self loadArchivedData];
	
	//facebook=[[Facebook alloc] init];
	
	//NSLog(@"setting facebook accessToken to %@",accessToken);
	
	//if(currentAccount)
	//{
		//facebook.accessToken=currentAccount.accessToken;
		//facebook.expirationDate=currentAccount.expirationDate;
	//}
	
	navController=[[FadeNavigationController alloc] init] ;
	navController.navigationBar.barStyle=UIBarStyleBlack;
	
	segmentedControl=[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"My Photo Albums",@"My Friend Lists",@"All My Friends",nil]];
	
	segmentedControl.segmentedControlStyle=UISegmentedControlStyleBar;
	
	[segmentedControl addTarget:self
						 action:@selector(segmentedControlValueChanged:)
			   forControlEvents:UIControlEventValueChanged];
	
	self.window.backgroundColor=[UIColor blackColor];
		
	// Override point for customization after app launch. 
    [self.window addSubview:navController.view];
    [self.window makeKeyAndVisible];

	[self showAllFriends];
	
	return YES;
}

- (NSString *)dataFilePath
{
	NSArray * paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString * documentsDirectory = [paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:@"archive"];
}

- (void) segmentedControlValueChanged:(id)sender
{
	switch ([sender selectedSegmentIndex]) {
		case 0:
			[self showMyAlbums];
			break;
		case 1:
			[self showAllLists];
			break;
		case 2:
			[self showAllFriends];
			break;
		default:
			break;
	}
}

- (void)login 
{
	[self showAccounts];
	/*
	FacebookAccountsViewController * accountsView=[[FacebookAccountsViewController alloc] initWithAccounts:facebookAccounts];
	accountsView.modalPresentationStyle=UIModalPresentationFormSheet;
	accountsView.delegate=self;
	
	[navController.topViewController presentModalViewController:accountsView animated:YES];
	
	[accountsView release];
	*/
	/*
	if(![facebook isSessionValid])
	{
		Reachability *reachManager = [Reachability reachabilityWithHostName:@"www.facebook.com"];
		NetworkStatus remoteHostStatus = [reachManager currentReachabilityStatus];
		if (remoteHostStatus == NotReachable)
		{
			// dont try to authorize...
		}
		else
		{
			NSLog(@"session is NOT valid, calling facebook.authorize...");
			[facebook authorize:kAppId permissions:[NSArray arrayWithObjects:
											@"read_stream",@"friends_photos", @"read_friendlists",@"user_photos",@"offline_access",nil] delegate:self];
		}
	}
	else 
	{
		NSLog(@"session is valid, NOT calling facebook.authorize...");
	}*/
}

- (void)fbDidLogin
{
	if([currentAccount isSessionValid])
	{
		[self saveData];
		[self showAllFriends];
	}
	else 
	{
		[self saveData];
		[self showNoFriends];
	}
}

- (void) logout
{
	@try {
		// clear existing data...
		[self clearCache];
		
		self.currentAccount=nil;
		
		[self saveData];
		// show blank screen...
		[self showNoFriends];
		
		//self.currentAccount=nil;
		//[facebook logout:self];
	}
	@catch (NSException * e) {
	}
	@finally {
	}
}

- (void) clearCache
{
	@try {
		[imageCache clear];
		ASIDownloadCache * cache=[ASIDownloadCache sharedCache];
		[cache clearCachedResponsesForStoragePolicy:ASICacheForSessionDurationCacheStoragePolicy];
		[cache clearCachedResponsesForStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
	}
	@catch (NSException * e) {
	}
	@finally {
	}
}

/**
 * Called when the user dismissed the dialog without logging in.
 */
- (void)fbDidNotLogin:(BOOL)cancelled
{
	self.currentAccount=nil;
	
	//accessToken=nil;
	//expirationDate=nil;
	
	[self showAllFriends];
}

/**
 * Called when the user logged out.
 */
- (void)fbDidLogout
{
	self.currentAccount=nil;
	
	//accessToken=nil;
	//expirationDate=nil;
	[self clearCache];
	[self saveData];
	
	// redisplay UI...
	[self showAllFriends];
}


- (void) addCommentToPhoto:(Picture*)picture comment:(NSString*)comment
{
	if(![currentAccount isSessionValid])
	{
		return;
	}
	// TODO
	
}

- (void) likePhoto:(Picture*)picture
{
	if(![currentAccount isSessionValid])
	{
		return;
	}
	// TODO
}

- (void) showMyAlbums
{
	if(![currentAccount isSessionValid])
	{
		[self login];
		return;
	}
	
	FacebookMyAlbumsFeed * feed=[[FacebookMyAlbumsFeed alloc] initWithFacebookAccount:currentAccount];
	AlbumsGridViewController * controller=[[AlbumsGridViewController alloc] initWithFeed:feed title:@"My Albums"];
	[self addSettingsButtonToController:controller];
	controller.navigationItem.titleView=segmentedControl;
	segmentedControl.selectedSegmentIndex=0;
	[navController setViewControllers:[NSArray arrayWithObject:controller] animated:NO];
	[feed release];
}
- (void) showNoFriends
{
	//FacebookFriendFeed * feed=[[FacebookFriendFeed alloc] initWithFacebook:facebook];
	
	FriendsGridViewController * controller=[[FriendsGridViewController alloc] initWithFeed:nil title:@"All Friends"];
	[self addSettingsButtonToController:controller];
	controller.navigationItem.titleView=segmentedControl;
	segmentedControl.selectedSegmentIndex=2;
	[navController setViewControllers:[NSArray arrayWithObject:controller] animated:NO];
	//[feed release];
}
- (void) showAllFriends
{
	FacebookFriendFeed * feed=nil;
	
	if([currentAccount isSessionValid])
	{
		feed=[[FacebookFriendFeed alloc] initWithFacebookAccount:currentAccount];
	}
	
	FriendsGridViewController * controller=[[FriendsGridViewController alloc] initWithFeed:feed title:@"All Friends"];
	[self addSettingsButtonToController:controller];
	controller.navigationItem.titleView=segmentedControl;
	segmentedControl.selectedSegmentIndex=2;
	[navController setViewControllers:[NSArray arrayWithObject:controller] animated:NO];
	[feed release];
	
	
}

- (void) addSettingsButtonToController:(UIViewController*)controller
{
	BlankToolbar * tools=[[BlankToolbar alloc] initWithFrame:CGRectMake(0, 0, 150, 44.01)];
	
	tools.backgroundColor=[UIColor clearColor];
	tools.opaque=NO;
	
	NSMutableArray * toolItems=[[NSMutableArray alloc] init];
	
	UIBarButtonItem * b;
	
	b=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_settings.png"] style:UIBarButtonItemStylePlain target:self action:@selector(settings:)];
	[toolItems addObject:b];
	[b release];
	
	b=[[UIBarButtonItem	alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	b.width=10;
	[toolItems addObject:b];
	[b release];
	
	b=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_circle_arrow_right.png"] style:UIBarButtonItemStylePlain target:self action:@selector(refresh:)];
	[toolItems addObject:b];
	[b release];
	
	b=[[UIBarButtonItem	alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	[toolItems addObject:b];
	[b release];

	[tools setItems:toolItems animated:NO];
	
	controller.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc] initWithCustomView:tools] autorelease];
	
	[tools release];	
	[toolItems release];
}

- (void) showAllLists
{
	if(![currentAccount isSessionValid])
	{
		[self login];
		return;
	}
	
	FacebookFriendListsFeed * feed=[[FacebookFriendListsFeed alloc] initWithFacebookAccount:currentAccount];
	
	FriendListsGridViewController * controller=[[FriendListsGridViewController alloc] initWithFeed:feed title:@"My Lists"];
	[self addSettingsButtonToController:controller];
	
	controller.navigationItem.titleView=segmentedControl;
	segmentedControl.selectedSegmentIndex=1;
	[navController setViewControllers:[NSArray arrayWithObject:controller] animated:NO];
	[feed release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSLog(@"actionSheet:clickedButtonAtIndex:%d",buttonIndex);
	if(actionSheet.tag==kActionSheetSettings)
	{
		if(buttonIndex==0)
		{
			// clear cache
			[self clearCache];
		}
		if(buttonIndex==1)
		{
			// facebook accounts
			[self showAccounts];
		}
		if(buttonIndex==2)
		{
			// logout
			[self logout];
		}
	}
}

- (void) showAccounts
{
	NSLog(@"showAccounts");
	
	FacebookAccountsViewController * accountsView=[[FacebookAccountsViewController alloc] initWithAccounts:facebookAccounts];
	accountsView.modalPresentationStyle=UIModalPresentationFormSheet;
	accountsView.delegate=self;
	NSLog(@"presentModalViewController...");
	
	[navController.topViewController presentModalViewController:accountsView animated:YES];
	
	[accountsView release];
}

- (void) refresh:(id)sender
{
	FeedViewController * feedController=self.navController.topViewController;
	[feedController refresh];
}

- (void) settings:(id)sender
{
	UIActionSheet * actionSheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Clear cached images" otherButtonTitles:@"Facebook accounts",@"Logout",nil];
	
	actionSheet.tag=kActionSheetSettings;
	
	[actionSheet showFromBarButtonItem:sender animated:YES];
	
	[actionSheet release];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
	[self saveData];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
	[self saveData];
}

- (void) loadArchivedData
{
	NSLog(@"loadArchivedData");
	
	NSString * filePath=[self dataFilePath];
	
	NSLog(@"Loading archived data from: %@",filePath);
	
	@try 
	{
		NSData * data =[[NSMutableData alloc]
						initWithContentsOfFile:filePath];
		if (data) 
		{
			NSKeyedUnarchiver * unarchiver = [[NSKeyedUnarchiver alloc]
											  initForReadingWithData:data];
		
			facebookAccounts=[[unarchiver decodeObjectForKey:@"facebookAccounts"] retain];
			
			currentAccount=[[unarchiver decodeObjectForKey:@"currentAccount"] retain];
			
			[unarchiver finishDecoding];
			
			[unarchiver	release];
			
			[data release];
		}
	}
	@catch (NSException * e) 
	{
		NSLog(@"Exception in loadArchivedData");
		NSLog(@"Exception: %@",[e description]);
	}
	@finally 
	{
	}
	if(facebookAccounts==nil)
	{
		NSLog(@"facebookAccounts==nil, creating new array...");
		
		facebookAccounts=[[NSMutableArray alloc] init];
	}
}

- (void) saveData
{
	NSLog(@"saveData");
	
	@try {
		
		NSMutableData * data=[[NSMutableData alloc] init];
		
		if(data)
		{
			NSKeyedArchiver * archiver=[[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
			
			[archiver encodeObject:facebookAccounts forKey:@"facebookAccounts"];
			[archiver encodeObject:currentAccount forKey:@"currentAccount"];
			
			[archiver finishEncoding];
			
			[data writeToFile:[self dataFilePath] atomically:YES];
			
			[archiver release];
		
			[data release];
			NSLog(@"Data saved ...");
		}
		
	}
	@catch (NSException * e) 
	{
		NSLog(@"Exception in saveData");
		NSLog(@"Exception: %@",[e description]);
	}
	@finally 
	{
		
	}
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
	@try 
	{
		NSLog(@"applicationDidReceiveMemoryWarning: clearing image cache...");
		[self clearCache];
	}
	@catch (NSException * e) 
	{
		
	}
	@finally 
	{
	}
}

- (void)dealloc {
	[downloadQueue release];
	[navController release];
	[segmentedControl release];
	[imageCache release];
    [window release];
	[facebookAccounts release];
	[currentAccount release];
    [super dealloc];
}


@end
