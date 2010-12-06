//
//  Feed.m
//  PhotoExplorer
//
//  Created by Robert Stewart on 12/4/10.
//  Copyright 2010 Evernote. All rights reserved.
//

#import "Feed.h"
#import "ASIHTTPRequest.h"
#import "PhotoExplorerAppDelegate.h"

@implementation Feed
@synthesize delegate;

- (void)dealloc 
{
    delegate = nil;
    
    [super dealloc];
}

- (void)fetch
{
	NSLog(@"Feed.fetch");
    ASIHTTPRequest *request = [self createFetchRequest]; //[[ASIHTTPRequest alloc] initWithURL:url];
    if(request)
	{
		NSLog(@"Got request, adding operation queue...");
		[request setDelegate:self];
		[request setDidFinishSelector:@selector(requestDone:)];
		[request setDidFailSelector:@selector(requestWentWrong:)];
		NSOperationQueue *queue = [PhotoExplorerAppDelegate sharedAppDelegate].downloadQueue;
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
	NSLog(@"Feed.requestDone");
    NSData *data = [request responseData];
	
	NSArray * items=[self getItemsFromResponseData:data];
	
	if([delegate respondsToSelector:@selector(feed:didFindItems:)])
    {
        [delegate feed:self didFindItems:items];
    }
}

- (void)requestWentWrong:(ASIHTTPRequest *)request
{
	NSLog(@"Feed.requestWentWrong");
    
    NSError *error = [request error];
	
    if([delegate respondsToSelector:@selector(feed:didFailWithError:)])
    {
        [delegate feed:self didFailWithError:[error description]];
    }
}

@end
