#import "Feed.h"
#import "ASIHTTPRequest.h"
#import "PixelLifeAppDelegate.h"

@implementation Feed
@synthesize delegate;

- (void)dealloc 
{
    delegate = nil;
    [super dealloc];
}

- (void)fetch
{
	ASIHTTPRequest *request = [self createFetchRequest]; //[[ASIHTTPRequest alloc] initWithURL:url];
    if(request)
	{
		//NSLog(@"Fetching feed: %@",[request.url description]);
		[request setDelegate:self];
		[request setDidFinishSelector:@selector(requestDone:)];
		[request setDidFailSelector:@selector(requestWentWrong:)];
		NSOperationQueue *queue = [PixelLifeAppDelegate sharedAppDelegate].downloadQueue;
		[queue addOperation:request];
		[request release];
	}
}

- (ASIHTTPRequest*)createFetchRequest
{
	// handle in subclass
}

- (NSArray*)getItemsFromResponseData:(NSData*)data
{
	// handle in subclass
}

- (void)requestDone:(ASIHTTPRequest *)request
{
	if([request didUseCachedResponse])
	{
		NSLog(@"Got response from cache for: %@",[request.url description]);
	}

    NSData *data = [request responseData];
	
	NSArray * items=[self getItemsFromResponseData:data];
	
	if([delegate respondsToSelector:@selector(feed:didFindItems:)])
    {
        [delegate feed:self didFindItems:items];
    }
}

- (void)requestWentWrong:(ASIHTTPRequest *)request
{
	NSError *error = [request error];
	
    if([delegate respondsToSelector:@selector(feed:didFailWithError:)])
    {
        [delegate feed:self didFailWithError:[error description]];
    }
}

@end
