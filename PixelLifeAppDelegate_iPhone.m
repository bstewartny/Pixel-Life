#import "PixelLifeAppDelegate_iPhone.h"
#import "FacebookAccountsViewController.h"
#import "FacebookFriendFeed.h"
#import "FriendsTableViewController.h"
#import "FacebookMyAlbumsFeed.h"
#import "AlbumsTableViewController.h"
#import "FriendListsTableViewController.h"
#import "FacebookFriendListsFeed.h"
#import "PLNavigationController.h"
#import "AboutViewController.h"
#import "FacebookRecentAlbumFeed.h"
#import "PhoneFriendsGridViewController.h"

@implementation PixelLifeAppDelegate_iPhone
@synthesize tabBar;

 
- (void)setupWindow
{
	navController=[[PLNavigationController alloc] init] ;
	navController.navigationBar.barStyle=UIBarStyleBlack;
	
	tabBar=[[UITabBar alloc] init];
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
	
	i=[[UITabBarItem alloc] initWithTitle:@"Recent" image:[UIImage imageNamed:@"11-clock.png"] tag:kTabBarRecentTag];
	[items addObject:i];
	[i release];
	
	[tabBar setItems:items animated:NO];
	
	self.window.backgroundColor=[UIColor blackColor];
	
	[self.window addSubview:navController.view];
    
	[self.window makeKeyAndVisible];
	
	[self showAllFriends];
}

- (BOOL) isPhone
{
	return YES;
}

- (void) showSettingsActionSheet
{
	UIActionSheet * actionSheet=[[UIActionSheet alloc] initWithTitle:@"Pixel Life" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Accounts",@"About",nil];
	actionSheet.tag=kActionSheetSettings;
	[actionSheet showFromTabBar:tabBar];
	[actionSheet release];
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
			[self showSettingsActionSheet];
			break;
	
		case kTabBarRecentTag:
			// recent albums
			[self showRecent];
			break;
	
	}
	
	
}

- (void) showAccounts
{
	NSLog(@"showAccounts");
	FacebookAccountsViewController * accountsView=[[FacebookAccountsViewController alloc] initWithAccounts:facebookAccounts];
	accountsView.modalPresentationStyle=UIModalPresentationFullScreen;
	accountsView.delegate=self;
	
	[navController.topViewController presentModalViewController:accountsView animated:YES];
	
	[accountsView release];
}
- (void) showAbout
{
	NSLog(@"showAbout");
	
	
	
	AboutViewController * aboutView=[[AboutViewController alloc] init];
	aboutView.modalPresentationStyle=UIModalPresentationFullScreen;
	
	 
	[navController.topViewController presentModalViewController:aboutView animated:YES];
	
	 
	[aboutView release];
	
}
- (void) showNoFriends
{
	NSLog(@"showNoFriends");
	FriendsTableViewController * controller=[[FriendsTableViewController alloc] initWithFeed:nil title:@"My Friends"];
	tabBar.selectedItem=[tabBar.items objectAtIndex:kTabBarFriendsTag];
	[controller setTabBar:tabBar];
	[navController setViewControllers:[NSArray arrayWithObject:controller] animated:NO];
	[controller release];
}
	   
- (void) showAllFriends_old
{
	NSLog(@"showAllFriends");
	if(![currentAccount isSessionValid])
	{
		NSLog(@"session is not valid, need to login...");
		[self showNoFriends];
		return;
	}
	
	FacebookFriendFeed * feed=[[FacebookFriendFeed alloc] initWithFacebookAccount:currentAccount];
	FriendsTableViewController * controller=[[FriendsTableViewController alloc] initWithFeed:feed title:@"My Friends"];
	tabBar.selectedItem=[tabBar.items objectAtIndex:kTabBarFriendsTag];
	[controller setTabBar:tabBar];
	[navController setViewControllers:[NSArray arrayWithObject:controller] animated:NO];
	[controller release];
	[feed release];
}

- (void) showAllFriends
{
	NSLog(@"showAllFriends");
	if(![currentAccount isSessionValid])
	{
		NSLog(@"session is not valid, need to login...");
		[self showNoFriends];
		return;
	}
	
	FacebookFriendFeed * feed=[[FacebookFriendFeed alloc] initWithFacebookAccount:currentAccount];
	//FriendsTableViewController * controller=[[FriendsTableViewController alloc] initWithFeed:feed title:@"My Friends"];
	PhoneFriendsGridViewController * controller=[[PhoneFriendsGridViewController alloc] initWithFeed:feed title:@"My Friends"];
	
	
	tabBar.selectedItem=[tabBar.items objectAtIndex:kTabBarFriendsTag];
	[controller setTabBar:tabBar];
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

- (void) showRecent
{
	if(![currentAccount isSessionValid])
	{
		[self login];
		return;
	}
	
	FacebookRecentAlbumFeed * feed=[[FacebookRecentAlbumFeed alloc] initWithFacebookAccount:currentAccount];
	AlbumsTableViewController * controller=[[AlbumsTableViewController alloc] initWithFeed:feed title:@"Recent Albums"];
	tabBar.selectedItem=[tabBar.items objectAtIndex:kTabBarRecentTag];
	[controller setTabBar:tabBar];
	[navController setViewControllers:[NSArray arrayWithObjects:controller,nil] animated:NO];
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
