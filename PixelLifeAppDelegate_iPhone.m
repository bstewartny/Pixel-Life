#import "PixelLifeAppDelegate_iPhone.h"
#import "FacebookAccountsViewController.h"
#import "FacebookFriendFeed.h"
#import "FriendsTableViewController.h"
#import "FacebookMyAlbumsFeed.h"
#import "AlbumsTableViewController.h"
#import "FriendListsTableViewController.h"
#import "FacebookFriendListsFeed.h"

@implementation PixelLifeAppDelegate_iPhone
@synthesize tabBar;

- (void)setupWindow
{
	navController=[[UINavigationController alloc] init] ;
	navController.navigationBar.barStyle=UIBarStyleBlack;
	
	CGRect r=[[UIScreen mainScreen] bounds];
	
	tabBar=[[UITabBar alloc] init]; //WithFrame:CGRectMake(0, r.size.height-65, r.size.width	, 65)];
	tabBar.delegate=self;
	
	[tabBar sizeToFit];
	
	tabBar.autoresizingMask=UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
	
	UITabBarItem * i;
	
	NSMutableArray * items=[[[NSMutableArray alloc] init] autorelease];

	i=[[UITabBarItem alloc] initWithTitle:@"Settings" image:[UIImage imageNamed:@"icon_settings.png"] tag:kTabBarSettingsTag];
	[items addObject:i];
	[i release];
	
	i=[[UITabBarItem alloc] initWithTitle:@"My Friends" image:[UIImage imageNamed:@"icon_users.png"] tag:kTabBarFriendsTag];
	[items addObject:i];
	[i release];
	
	i=[[UITabBarItem alloc] initWithTitle:@"My Lists" image:[UIImage imageNamed:@"icon_list_bullets.png"] tag:kTabBarListsTag];
	[items addObject:i];
	[i release];
	
	i=[[UITabBarItem alloc] initWithTitle:@"My Albums" image:[UIImage imageNamed:@"icon_user.png"] tag:kTabBarAlbumsTag];
	[items addObject:i];
	[i release];
	
	
	[tabBar setItems:items animated:NO];
	
	self.window.backgroundColor=[UIColor blackColor];
	
	// Override point for customization after app launch. 
    
	[self.window addSubview:navController.view];
    //[self.window addSubview:tabBar];
	
	[self.window makeKeyAndVisible];
	
	[self showAllFriends];
}

- (void) showSettings
{
	UIActionSheet * actionSheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Clear cached images" otherButtonTitles:@"Facebook accounts",@"Logout",nil];
	
	[actionSheet showFromTabBar:tabBar];
	
	[actionSheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
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



- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
	switch (item.tag) 
	{
		
		case kTabBarAlbumsTag:
			// my albums
			[self showMyAlbums];
			break;
		
		case kTabBarFriendsTag:
			// my friends
			[self showAllFriends];
			break;
		
		case kTabBarListsTag:
			// friend lists
			[self showAllLists];
			break;
		
		case kTabBarSettingsTag:
			// settings
			[self showSettings];
			break;
	}
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
	FriendsTableViewController * controller=[[FriendsTableViewController alloc] initWithFeed:nil title:@"My Friends"];
	
	tabBar.selectedItem=[tabBar.items objectAtIndex:kTabBarFriendsTag];
	
	[controller setTabBar:tabBar];
	
	
	
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
	
	FriendsTableViewController * controller=[[FriendsTableViewController alloc] initWithFeed:feed title:@"My Friends"];
	tabBar.selectedItem=[tabBar.items objectAtIndex:kTabBarFriendsTag];
	
	[controller setTabBar:tabBar];
	
	//[self addSettingsButtonToController:controller];
	//controller.navigationItem.titleView=segmentedControl;
	//segmentedControl.selectedSegmentIndex=2;
	[navController setViewControllers:[NSArray arrayWithObject:controller] animated:NO];
	[controller release];
	[feed release];
}

- (void) showMyAlbums
{
	if(![currentAccount isSessionValid])
	{
		[self login];
		return;
	}
	
	FacebookMyAlbumsFeed * feed=[[FacebookMyAlbumsFeed alloc] initWithFacebookAccount:currentAccount];
	AlbumsTableViewController * controller=[[AlbumsTableViewController alloc] initWithFeed:feed title:@"My Albums"];
	tabBar.selectedItem=[tabBar.items objectAtIndex:kTabBarAlbumsTag];
	
	[controller setTabBar:tabBar];
	
	[navController setViewControllers:[NSArray arrayWithObject:controller] animated:NO];
	[feed release];
	[controller release];
}	   
	   
	   
- (void) showAllLists
{
	if(![currentAccount isSessionValid])
	{
		[self login];
		return;
	}
	
	FacebookFriendListsFeed * feed=[[FacebookFriendListsFeed alloc] initWithFacebookAccount:currentAccount];
	
	FriendListsTableViewController * controller=[[FriendListsTableViewController alloc] initWithFeed:feed title:@"My Lists"];
	
	tabBar.selectedItem=[tabBar.items objectAtIndex:kTabBarListsTag];
	
	[controller setTabBar:tabBar];

	[navController setViewControllers:[NSArray arrayWithObject:controller] animated:NO];
	[feed release];
	[controller release];
}
	   
- (void) dealloc
{
	[tabBar release];
	[super dealloc];
}
@end
