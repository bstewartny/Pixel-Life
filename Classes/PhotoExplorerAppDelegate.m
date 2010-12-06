//
//  PhotoExplorerAppDelegate.m
//  PhotoExplorer
//
//  Created by Robert Stewart on 12/4/10.
//  Copyright 2010 Evernote. All rights reserved.
//

#import "PhotoExplorerAppDelegate.h"
#import "AlbumsGridViewController.h"
#import "FriendsGridViewController.h"
#import "PictureFeedGridViewController.h"
#import "Feed.h"
#import "TestAlbumFeed.h"
#import "TestPictureFeed.h"
#import	"TestFriendFeed.h"
#import "FBConnect.h"
#import "FacebookFriendFeed.h"

// Your Facebook APP Id must be set before running this example
// See http://www.facebook.com/developers/createapp.php
// Also, your application must bind to the fb[app_id]:// URL
// scheme (substitue [app_id] for your real Facebook app id).
static NSString* kAppId = @"144746058889817";

@implementation PhotoExplorerAppDelegate

@synthesize window;
@synthesize downloadQueue;
@synthesize navController;
@synthesize facebook;

+ (PhotoExplorerAppDelegate *)sharedAppDelegate
{
    return (PhotoExplorerAppDelegate *)[UIApplication sharedApplication].delegate;
}

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
	downloadQueue = [[NSOperationQueue alloc] init];
	
	facebook=[[Facebook alloc] init];
	
	navController=[[UINavigationController alloc] init] ;
	navController.navigationBar.barStyle=UIBarStyleBlack;
	
	segmentedControl=[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Friends",@"Albums",@"Photos",@"Events",nil]];
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

- (void) segmentedControlValueChanged:(id)sender
{
	switch ([sender selectedSegmentIndex]) {
		case 0:
			[self showAllFriends];
			break;
		case 1:
			[self showAllAlbums];
			break;
		case 2:
			[self showAllPictures];
			break;
		case 3:
			[self showAllEvents];
			break;
		default:
			break;
	}
}

- (void)login 
{
	if(![facebook isSessionValid])
	{
		[facebook authorize:kAppId permissions:[NSArray arrayWithObjects:
											@"read_stream",@"friends_photos", @"user_photos",@"offline_access",nil] delegate:self];
	}
}

/**
 * Called when the user successfully logged in.
 */
- (void)fbDidLogin
{
	if([facebook isSessionValid])
	{
		[self showAllFriends];
	}
}

/**
 * Called when the user dismissed the dialog without logging in.
 */
- (void)fbDidNotLogin:(BOOL)cancelled
{
	
}

/**
 * Called when the user logged out.
 */
- (void)fbDidLogout
{
	
}



- (void) showAllFriends
{
	// do facebook login if needed
	if(![facebook isSessionValid])
	{
		[self login];
		return;
	}
	
	FacebookFriendFeed * feed=[[FacebookFriendFeed alloc] initWithFacebook:facebook];
	
	//TestFriendFeed * testFeed=[[TestFriendFeed alloc] init];
	FriendsGridViewController * controller=[[FriendsGridViewController alloc] initWithFeed:feed title:@"All Friends"];
	controller.navigationItem.titleView=segmentedControl;
	segmentedControl.selectedSegmentIndex=0;
	[navController setViewControllers:[NSArray arrayWithObject:controller] animated:NO];
	[feed release];
}

- (void) showAllAlbums
{
	if(![facebook isSessionValid])
	{
		[self login];
		return;
	}
	
	TestAlbumFeed * testFeed=[[TestAlbumFeed alloc] init];
	AlbumsGridViewController * controller=[[AlbumsGridViewController alloc] initWithFeed:testFeed title:@"All Albums"];
	controller.navigationItem.titleView=segmentedControl;
	segmentedControl.selectedSegmentIndex=1;
	[navController setViewControllers:[NSArray arrayWithObject:controller] animated:NO];
	[testFeed release];
}

- (void) showAllPictures
{
	if(![facebook isSessionValid])
	{
		[self login];
		return;
	}
	
	TestPictureFeed * testFeed=[[TestPictureFeed alloc] init];
	PictureFeedGridViewController * controller=[[PictureFeedGridViewController alloc] initWithFeed:testFeed title:@"All Pictures"];
	controller.navigationItem.titleView=segmentedControl;
	segmentedControl.selectedSegmentIndex=2;
	[navController setViewControllers:[NSArray arrayWithObject:controller] animated:NO];
	[testFeed release];
}

- (void) showAllEvents
{
	if(![facebook isSessionValid])
	{
		[self login];
		return;
	}
	
	/*
	[navController popToRootViewControllerAnimated:YES];
	TestEventFeed * testFeed=[[TestEventFeed alloc] init];
	EventFeedGridViewController * controller=[[EventFeedGridViewController alloc] initWithFeed:testFeed];
	 controller.navigationItem.titleView=segmentedControl;
	 segmentedControl.selectedSegmentIndex=3;
	[navController pushViewController:controller animated:YES];
	
	[testFeed release];*/
}



- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
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
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	[downloadQueue release];
	[navController release];
	[segmentedControl release];
	[facebook release];
    [window release];
    [super dealloc];
}


@end
