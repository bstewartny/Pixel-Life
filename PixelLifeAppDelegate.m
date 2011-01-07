#import "PixelLifeAppDelegate.h"
#import "FBConnect.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"
#import "ImageCache.h"
#import "Reachability.h"
#import "FacebookAccount.h"
#import "FeedViewController.h"

@implementation PixelLifeAppDelegate

@synthesize window;
@synthesize navController;
@synthesize downloadQueue;
@synthesize imageCache;
@synthesize facebookAccounts;
@synthesize currentAccount;

+ (PixelLifeAppDelegate*) sharedAppDelegate
{
	return (PixelLifeAppDelegate*)[[UIApplication sharedApplication] delegate];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
	ASIDownloadCache * cache=[ASIDownloadCache sharedCache];
	cache.shouldRespectCacheControlHeaders=YES;
	
	[cache setDefaultCachePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy|ASIFallbackToCacheIfLoadFailsCachePolicy];
	
	[ASIHTTPRequest setDefaultCache:cache];
	
	imageCache=[[ImageCache alloc] init];
	
	downloadQueue = [[NSOperationQueue alloc] init];
	
	[self loadArchivedData];
	
	[self setupWindow];
	
	return YES;
}

- (void) setupWindow
{
	// subclass
}

- (NSString *)dataFilePath
{
	NSArray * paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString * documentsDirectory = [paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:@"archive"];
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


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
	[imageCache clear];
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
	//NSLog(@"loadArchivedData");
	
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
		//NSLog(@"facebookAccounts==nil, creating new array...");
		
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
			//NSLog(@"Data saved ...");
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

- (void) refresh:(id)sender
{
	FeedViewController * feedController=self.navController.topViewController;
	[feedController refresh];
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
	[navController release];
	[downloadQueue release];
	[imageCache release];
    [window release];
	[facebookAccounts release];
	[currentAccount release];
    [super dealloc];
}


@end
