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
#import "FacebookMyAlbumsFeed.h"
#import "FacebookFriendsAlbumsFeed.h"
#import "PictureFeedGridViewController.h"
#import "FacebookFriendsPhotosFeed.h"
#import "FacebookLikesFeed.h"
#import "Feed.h"
#import "TestAlbumFeed.h"
#import "TestPictureFeed.h"
#import	"TestFriendFeed.h"
#import "FBConnect.h"
#import "FacebookFriendFeed.h"
#import "UserSettings.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"
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
    
	ASIDownloadCache * cache=[ASIDownloadCache sharedCache];
	cache.shouldRespectCacheControlHeaders=NO;
	
	[cache setDefaultCachePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy|ASIFallbackToCacheIfLoadFailsCachePolicy];
	
	[ASIHTTPRequest setDefaultCache:cache];
	
	downloadQueue = [[NSOperationQueue alloc] init];
	
	[self loadArchivedData];
	
	facebook=[[Facebook alloc] init];
	
	facebook.accessToken=accessToken;
	facebook.expirationDate=expirationDate;
	
	navController=[[UINavigationController alloc] init] ;
	navController.navigationBar.barStyle=UIBarStyleBlack;
	
	segmentedControl=[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"My Albums",@"My Friends",@"Recent Photos",@"My Likes",nil]];
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
			[self showAllFriends];
			break;
		//case 1:
		//	[self showAllAlbums];
		//	break;
		case 2:
			[self showAllPictures];
			break;
		case 3:
			[self showAllLikes];
			break;
		//case 4:
		//	[self showAllEvents];
		//	break;
		default:
			break;
	}
}

- (void)login 
{
	if(![facebook isSessionValid])
	{
		[facebook authorize:kAppId permissions:[NSArray arrayWithObjects:
											@"read_stream",@"friends_photos", @"read_friendlist",@"user_photos",@"offline_access",nil] delegate:self];
	}
}

/**
 * Called when the user successfully logged in.
 */
- (void)fbDidLogin
{
	if([facebook isSessionValid])
	{
		accessToken=facebook.accessToken;
		expirationDate=facebook.expirationDate;
	
		[self showAllFriends];
	}
}

/**
 * Called when the user dismissed the dialog without logging in.
 */
- (void)fbDidNotLogin:(BOOL)cancelled
{
	accessToken=nil;
	expirationDate=nil;
}

/**
 * Called when the user logged out.
 */
- (void)fbDidLogout
{
	accessToken=nil;
	expirationDate=nil;
}
- (void) showMyAlbums
{
	if(![facebook isSessionValid])
	{
		[self login];
		return;
	}
	
	FacebookMyAlbumsFeed * feed=[[FacebookMyAlbumsFeed alloc] initWithFacebook:facebook];
	AlbumsGridViewController * controller=[[AlbumsGridViewController alloc] initWithFeed:feed title:@"My Albums"];
	controller.navigationItem.titleView=segmentedControl;
	segmentedControl.selectedSegmentIndex=0;
	[navController setViewControllers:[NSArray arrayWithObject:controller] animated:NO];
	[feed release];
	
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
	segmentedControl.selectedSegmentIndex=1;
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
	
	FacebookFriendsAlbumsFeed * feed=[[FacebookFriendsAlbumsFeed alloc] initWithFacebook:facebook];
	AlbumsGridViewController * controller=[[AlbumsGridViewController alloc] initWithFeed:feed title:@"All Albums"];
	controller.navigationItem.titleView=segmentedControl;
	segmentedControl.selectedSegmentIndex=1;
	[navController setViewControllers:[NSArray arrayWithObject:controller] animated:NO];
	[feed release];
}

- (void) showAllPictures
{
	if(![facebook isSessionValid])
	{
		[self login];
		return;
	}
	
	FacebookFriendsPhotosFeed * feed=[[FacebookFriendsPhotosFeed alloc] initWithFacebook:facebook];
	
	PictureFeedGridViewController * controller=[[PictureFeedGridViewController alloc] initWithFeed:feed title:@"All Pictures"];
	controller.navigationItem.titleView=segmentedControl;
	segmentedControl.selectedSegmentIndex=2;
	[navController setViewControllers:[NSArray arrayWithObject:controller] animated:NO];
	[feed release];
}

- (void) showAllLikes
{
	if(![facebook isSessionValid])
	{
		[self login];
		return;
	}
	
	FacebookLikesFeed * feed=[[FacebookLikesFeed alloc] initWithFacebook:facebook];
	
	FriendsGridViewController * controller=[[FriendsGridViewController alloc] initWithFeed:feed title:@"Likes"];
	controller.navigationItem.titleView=segmentedControl;
	segmentedControl.selectedSegmentIndex=3;
	[navController setViewControllers:[NSArray arrayWithObject:controller] animated:NO];
	[feed release];
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
	 segmentedControl.selectedSegmentIndex=4;
	[navController pushViewController:controller animated:YES];
	
	[testFeed release];*/
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
	
	@try {
		
		NSData * data =[[NSMutableData alloc]
						initWithContentsOfFile:filePath];
		
		if (data) 
		{
			NSKeyedUnarchiver * unarchiver = [[NSKeyedUnarchiver alloc]
											  initForReadingWithData:data];
		
			accessToken=[unarchiver decodeObjectForKey:@"accessToken"];
			expirationDate=[unarchiver decodeObjectForKey:@"expirationDate"];
			
			[unarchiver finishDecoding];
			
			[unarchiver	release];
			
			[data release];
		}
		
		
	}
	@catch (NSException * e) {
		NSLog(@"Exception in loadArchivedData");
		NSLog(@"Exception: %@",[e description]);
	}
	@finally 
	{
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
			
			[archiver encodeObject:accessToken forKey:@"accessToken"];
			[archiver encodeObject:expirationDate forKey:@"expirationDate"];
			
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
