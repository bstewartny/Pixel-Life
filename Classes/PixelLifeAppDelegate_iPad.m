#import "PixelLifeAppDelegate_iPad.h"
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
#import "BlankToolbar.h"
#import "Reachability.h"
#import "FacebookAccount.h"
#import "FacebookAccountsViewController.h"

@implementation PixelLifeAppDelegate_iPad

- (void)setupWindow
{	
	navController=[[UINavigationController alloc] init] ;
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
	[controller release];
}
- (void) showNoFriends
{
	FriendsGridViewController * controller=[[FriendsGridViewController alloc] initWithFeed:nil title:@"All Friends"];
	[self addSettingsButtonToController:controller];
	controller.navigationItem.titleView=segmentedControl;
	segmentedControl.selectedSegmentIndex=2;
	[navController setViewControllers:[NSArray arrayWithObject:controller] animated:NO];
	[controller release];
}
- (void) showAllFriends
{
	
	if(![currentAccount isSessionValid])
	{
		[self login];
		return;
	}
	
	FacebookFriendFeed * feed=[[FacebookFriendFeed alloc] initWithFacebookAccount:currentAccount];
	
	FriendsGridViewController * controller=[[FriendsGridViewController alloc] initWithFeed:feed title:@"All Friends"];
	[self addSettingsButtonToController:controller];
	controller.navigationItem.titleView=segmentedControl;
	segmentedControl.selectedSegmentIndex=2;
	[navController setViewControllers:[NSArray arrayWithObject:controller] animated:NO];
	[feed release];
	[controller release];
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
	[controller release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
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
	FacebookAccountsViewController * accountsView=[[FacebookAccountsViewController alloc] initWithAccounts:facebookAccounts];
	accountsView.modalPresentationStyle=UIModalPresentationFormSheet;
	accountsView.delegate=self;
	
	[navController.topViewController presentModalViewController:accountsView animated:YES];
	
	[accountsView release];
}



- (void) settings:(id)sender
{
	UIActionSheet * actionSheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Clear cached images" otherButtonTitles:@"Facebook accounts",@"Logout",nil];
	
	actionSheet.tag=kActionSheetSettings;
	
	[actionSheet showFromBarButtonItem:sender animated:YES];
	
	[actionSheet release];
}

- (void)dealloc {
	[segmentedControl release];
    [super dealloc];
}


@end
