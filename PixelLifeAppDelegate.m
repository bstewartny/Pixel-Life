#import "PixelLifeAppDelegate.h"
#import "FBConnect.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "ASIDownloadCache.h"
#import "ImageCache.h"
#import "Reachability.h"
#import "FacebookAccount.h"
#import "FeedViewController.h"
#import "PLNavigationController.h"

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
    
	[application setStatusBarStyle:UIStatusBarStyleBlackOpaque];
	
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



- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(actionSheet.tag==kActionSheetSettings)
	{
		if(buttonIndex==0)
		{
			// facebook accounts
			[self showAccounts];
		}
		/*if(buttonIndex==0)
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
		}*/
	}
}


- (void) isPhone
{
	return NO;
}

- (void) setupWindow
{
	// subclass
}

- (void) showAllFriends
{
}
- (void) showAllLists
{
}
- (void) showNoFriends
{
}
- (void) showMyAlbums
{
}

- (void) showAccounts
{
}
- (void)login 
{
	[self showAccounts];
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
	FeedViewController * feedController=(FeedViewController*)self.navController.topViewController;
	[feedController refresh];
}




- (ASIHTTPRequest*) createCommentRequest:(NSString*)message uid:(NSString*)uid
{
	NSString * url=[NSString stringWithFormat:@"https://graph.facebook.com/%@/comments",uid];
	
	ASIFormDataRequest * request=[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]];
	
	request.requestMethod=@"POST";
	
	[request addPostValue:currentAccount.accessToken forKey:@"access_token"];
	[request addPostValue:message forKey:@"message"];
	
	return request;
}
- (void) sendComment:(NSString*)comment uid:(NSString*)uid
{
	if([comment length]>0)
	{
		// push to queue
		ASIHTTPRequest *request = [self createCommentRequest:comment uid:uid];  
		if(request)
		{
			[request setDelegate:self];
			[request setDidFinishSelector:@selector(sendCommentRequestDone:)];
			[request setDidFailSelector:@selector(sendCommentRequestWentWrong:)];
			[downloadQueue addOperation:request];
			[request release];
		}
	}
}
- (void)sendCommentRequestDone:(ASIHTTPRequest *)request
{
	// done
}

- (void)sendCommentRequestWentWrong:(ASIHTTPRequest *)request
{
	NSError *error = [request error];
	
	UIAlertView * alertView=[[UIAlertView alloc] initWithTitle:@"Sending comment failed" message:[error description] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}



- (ASIHTTPRequest*) createLikeRequest:(NSString*)uid
{
	NSString * url=[NSString stringWithFormat:@"https://graph.facebook.com/%@/likes",uid];
	
	ASIFormDataRequest * request=[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]];
	
	request.requestMethod=@"POST";
	
	[request addPostValue:currentAccount.accessToken forKey:@"access_token"];
	
	return request;
}
- (void) likeGraphObject:(NSString*)uid
{
	// push to queue
	ASIHTTPRequest *request = [self createLikeRequest:uid];  
	if(request)
	{
		[request setDelegate:self];
		[request setDidFinishSelector:@selector(sendLikeRequestDone:)];
		[request setDidFailSelector:@selector(sendLikeRequestWentWrong:)];
		[downloadQueue addOperation:request];
		[request release];
	}	
}
- (void)sendLikeRequestDone:(ASIHTTPRequest *)request
{
	// done
	NSLog(@"sendLikeRequestDone");
}

- (void)sendLikeRequestWentWrong:(ASIHTTPRequest *)request
{
	NSError *error = [request error];
	
	UIAlertView * alertView=[[UIAlertView alloc] initWithTitle:@"Like failed" message:[error description] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
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
