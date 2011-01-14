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
#define kMyAlbumsIndex 0
#define kMyListsIndex 1
#define kMyFriendsIndex 2

@implementation PixelLifeAppDelegate_iPad

- (void)setupWindow
{	
	navController=[[UINavigationController alloc] init] ;
	navController.navigationBar.barStyle=UIBarStyleBlack;
	
	self.window.backgroundColor=[UIColor blackColor];
		
	// Override point for customization after app launch. 
    [self.window addSubview:navController.view];
    [self.window makeKeyAndVisible];

	[self showAllFriends];
}

- (void) segmentedControlValueChanged:(id)sender
{
	switch ([sender selectedSegmentIndex]) {
		case kMyAlbumsIndex:
			[self showMyAlbums];
			break;
		case kMyListsIndex:
			[self showAllLists];
			break;
		case kMyFriendsIndex:
			[self showAllFriends];
			break;
		default:
			break;
	}
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
	[self addSegmentedControlTitleView:controller withSelectedIndex:kMyAlbumsIndex];
	[navController setViewControllers:[NSArray arrayWithObjects:controller,nil] animated:NO];
	[feed release];
	[controller release];
}

- (void) showNoFriends
{
	FriendsGridViewController * controller=[[FriendsGridViewController alloc] initWithFeed:nil title:@"My Friends"];
	[self addSettingsButtonToController:controller];
	[self addSegmentedControlTitleView:controller withSelectedIndex:kMyFriendsIndex];
	[navController setViewControllers:[NSArray arrayWithObjects:controller,nil] animated:NO];
	[controller release];
}

- (void) showAllFriends
{
	NSLog(@"showAllFriends");
	if(![currentAccount isSessionValid])
	{
		[self login];
		return;
	}
	
	FacebookFriendFeed * feed=[[FacebookFriendFeed alloc] initWithFacebookAccount:currentAccount];
	FriendsGridViewController * controller=[[FriendsGridViewController alloc] initWithFeed:feed title:@"My Friends"];
	[self addSettingsButtonToController:controller];
	[self addSegmentedControlTitleView:controller withSelectedIndex:kMyFriendsIndex];
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
	FriendListsGridViewController * controller=[[FriendListsGridViewController alloc] initWithFeed:feed title:@"My Lists"];
	[self addSettingsButtonToController:controller];
	[self addSegmentedControlTitleView:controller withSelectedIndex:kMyListsIndex];
	[navController setViewControllers:[NSArray arrayWithObjects:controller,nil] animated:NO];
	[feed release];
	[controller release];
}

- (void) addSegmentedControlTitleView:(UIViewController*)controller withSelectedIndex:(NSInteger)index
{
	UISegmentedControl * sc=[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"My Albums",@"My Lists",@"My Friends",nil]];\
	sc.segmentedControlStyle=UISegmentedControlStyleBar;
	[sc sizeToFit];
	sc.selectedSegmentIndex=index;
	[sc addTarget:self
		action:@selector(segmentedControlValueChanged:)
		forControlEvents:UIControlEventValueChanged];
	controller.navigationItem.titleView=sc;
	[sc release];
}

- (void) addSettingsButtonToController:(UIViewController*)controller
{
	BlankToolbar * tools=[[BlankToolbar alloc] initWithFrame:CGRectMake(0, 0, 150, 44.01)];
	
	tools.backgroundColor=[UIColor clearColor];
	tools.opaque=NO;
	
	NSMutableArray * toolItems=[[NSMutableArray alloc] init];
	
	UIBarButtonItem * b;
	
	b=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_settings.png"] style:UIBarButtonItemStylePlain target:self action:@selector(showSettingsActionSheet:)];
	[toolItems addObject:b];
	[b release];
	
	/*b=[[UIBarButtonItem	alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	b.width=10;
	[toolItems addObject:b];
	[b release];
	
	b=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_circle_arrow_right.png"] style:UIBarButtonItemStylePlain target:self action:@selector(refresh:)];
	[toolItems addObject:b];
	[b release];*/
	
	b=[[UIBarButtonItem	alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	[toolItems addObject:b];
	[b release];

	[tools setItems:toolItems animated:NO];
	
	controller.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc] initWithCustomView:tools] autorelease];
	
	[tools release];	
	[toolItems release];
}

- (void) showAccounts
{
	FacebookAccountsViewController * accountsView=[[FacebookAccountsViewController alloc] initWithAccounts:facebookAccounts];
	accountsView.modalPresentationStyle=UIModalPresentationFormSheet;
	accountsView.delegate=self;
	
	[navController.topViewController presentModalViewController:accountsView animated:YES];
	
	[accountsView release];
}

- (void) showSettingsActionSheet:(id)sender
{
	UIActionSheet * actionSheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Clear cached images" otherButtonTitles:@"Facebook accounts",@"Logout",nil];
	actionSheet.tag=kActionSheetSettings;
	[actionSheet showFromBarButtonItem:sender animated:YES];
	[actionSheet release];
}

- (void)dealloc 
{
    [super dealloc];
}


@end
