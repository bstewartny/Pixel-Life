//
//  PictureFeed.m
//  PhotoExplorer
//
//  Created by Robert Stewart on 12/4/10.
//  Copyright 2010 Evernote. All rights reserved.
//

#import "PictureFeed.h"
#import "Picture.h"
#import "ASIHTTPRequest.h"
#import "PhotoExplorerAppDelegate.h"

@implementation PictureFeed
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

- (NSArray*)getPicturesFromResponseData:(NSData*)data
{
	// handle in subclass
}

- (void)requestDone:(ASIHTTPRequest *)request
{
    NSData *data = [request responseData];
	
	NSArray * pictures=[self getPicturesFromResponseData:data];
	
	if([delegate respondsToSelector:@selector(pictureFeed:didFindPictures:)])
    {
        [delegate pictureFeed:self didFindPictures:pictures];
    }
}

- (void)requestWentWrong:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
	
    if([delegate respondsToSelector:@selector(pictureFeed:didFailWithError:)])
    {
        [delegate pictureFeed:self didFailWithError:[error description]];
    }
}

@end
