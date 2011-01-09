#import "PixelLifeAppDelegate_iPhone.h"
#import "FacebookAccountsViewController.h"
#import "FacebookFriendFeed.h"
#import "FriendsTableViewController.h"

@implementation PixelLifeAppDelegate_iPhone
//@synthesize tabBar;

- (void)setupWindow
{
	navController=[[UINavigationController alloc] init] ;
	navController.navigationBar.barStyle=UIBarStyleBlack;
	
	/*CGRect r=[[UIScreen mainScreen] bounds];
	
	tabBar=[[UITabBar alloc] initWithFrame:CGRectMake(0, r.size.height-65, r.size.width	, 65)];
	
	UITabBarItem * i;
	
	NSMutableArray * items=[[[NSMutableArray alloc] init] autorelease];
	
	i=[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFeatured tag:1];
	[items addObject:i];
	[i release];
	
	i=[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemContacts tag:2];
	[items addObject:i];
	[i release];
	
	i=[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemTopRated tag:3];
	[items addObject:i];
	[i release];
	
	[tabBar setItems:items animated:NO];
	*/
	self.window.backgroundColor=[UIColor blackColor];
	
	// Override point for customization after app launch. 
    
	[self.window addSubview:navController.view];
    //[self.window addSubview:tabBar];
	
	[self.window makeKeyAndVisible];
	
	[self showAllFriends];
}

- (void)login 
{
	[self showAccounts];
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
/**
 * Called when the user dismissed the dialog without logging in.
 */
- (void)fbDidNotLogin:(BOOL)cancelled
{
	self.currentAccount=nil;
	
	[self showAllFriends];
}

/**
 * Called when the user logged out.
 */
- (void)fbDidLogout
{
	self.currentAccount=nil;
	
	[self clearCache];
	[self saveData];
	
	// redisplay UI...
	[self showAllFriends];
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
	}
	@catch (NSException * e) {
	}
	@finally {
	}
}

- (void) showAccounts
{
	FacebookAccountsViewController * accountsView=[[FacebookAccountsViewController alloc] initWithAccounts:facebookAccounts];
	accountsView.modalPresentationStyle=UIModalPresentationFullScreen;
	accountsView.delegate=self;
	
	[navController.topViewController presentModalViewController:accountsView animated:YES];
	
	[accountsView release];
}

- (void) showNoFriends
{
	FriendsTableViewController * controller=[[FriendsTableViewController alloc] initWithFeed:nil title:@"All Friends"];
	//[self addSettingsButtonToController:controller];
	//controller.navigationItem.titleView=segmentedControl;
	//segmentedControl.selectedSegmentIndex=2;
	[navController setViewControllers:[NSArray arrayWithObject:controller] animated:NO];
	[controller release];
}
- (void) showAllFriends
{
	if(![currentAccount isSessionValid])
	{
		NSLog(@"session is not valid, need to login...");
		[self showNoFriends];
		[self login];
		return;
	}
	
	FacebookFriendFeed * feed=[[FacebookFriendFeed alloc] initWithFacebookAccount:currentAccount];
	
	FriendsTableViewController * controller=[[FriendsTableViewController alloc] initWithFeed:feed title:@"All Friends"];
	//[self addSettingsButtonToController:controller];
	//controller.navigationItem.titleView=segmentedControl;
	//segmentedControl.selectedSegmentIndex=2;
	[navController setViewControllers:[NSArray arrayWithObject:controller] animated:NO];
	[controller release];
	[feed release];
}
- (void) dealloc
{
	//[tabBar release];
	[super dealloc];
}
@end