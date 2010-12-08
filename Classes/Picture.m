//
//  Picture.m
//  PhotoExplorer
//
//  Created by Robert Stewart on 12/4/10.
//  Copyright 2010 Evernote. All rights reserved.
//

#import "Picture.h"
#import "ASIHTTPRequest.h"
#import "PhotoExplorerAppDelegate.h"

@implementation Picture
@synthesize image,imageURL,delegate,width,height,thumbnailURL,thumbnail,description;

- (BOOL) hasLoadedImage
{
	return downloadFailed || (image!=nil);
}

- (BOOL) hasLoadedThumbnail
{
	return downloadFailed || (thumbnail!=nil);
}

- (UIImage*)thumbnail
{
	if(thumbnail==nil)
	{
		if(!downloadFailed)
		{
			NSURL * url=[NSURL URLWithString:self.thumbnailURL];
			[self loadThumbnail:url];
		}
	}
	
	return thumbnail;
} 

- (UIImage*)image
{
	if(image==nil)
	{
		if(!downloadFailed)
		{
			NSURL * url=[NSURL URLWithString:self.imageURL];
			[self loadImage:url];
		}
	}
	
	return image;
}

- (void)imageRequestDone:(ASIHTTPRequest *)request
{
	//NSLog(@"Picture.requestDone");
	if([request didUseCachedResponse])
	{
		NSLog(@"Got image from cache...");
	}
	NSData *data = [request responseData];
    
	UIImage *remoteImage = [[UIImage alloc] initWithData:data];
    self.image = remoteImage;
    if ([delegate respondsToSelector:@selector(picture:didLoadImage:)])
    {
        [delegate picture:self didLoadImage:remoteImage];
    }
    [remoteImage release];
}

- (void)thumbnailRequestDone:(ASIHTTPRequest *)request
{
	//NSLog(@"Picture.requestDone");
	if([request didUseCachedResponse])
	{
		NSLog(@"Got thumbnail from cache...");
	}
	if([request isEqual:thumbnailRequest])
	{
		[thumbnailRequest release];
		thumbnailRequest=nil;
	}
	if([request isEqual:imageRequest])
	{
		[imageRequest release];
		imageRequest=nil;
	}
	if(dealloc_called)
	{
		NSLog(@"thumbnailRequestDone: dealloc was called, calling again...");
		[self dealloc];
		return;
	}
	
	NSData *data = [request responseData];
    
	UIImage *remoteImage = [[UIImage alloc] initWithData:data];
    self.thumbnail = remoteImage;
    if ([delegate respondsToSelector:@selector(picture:didLoadImage:)])
    {
        [delegate picture:self didLoadImage:remoteImage];
    }
    [remoteImage release];
	
	//[request release];
}

- (void)requestWentWrong:(ASIHTTPRequest *)request
{
	downloadFailed=YES;
	NSLog(@"Picture.requestWentWrong");
	NSError *error = [request error];
	
	if([request isEqual:thumbnailRequest])
	{
		[thumbnailRequest release];
		thumbnailRequest=nil;
	}
	if([request isEqual:imageRequest])
	{
		[imageRequest release];
		imageRequest=nil;
	}
	if(dealloc_called)
	{
		NSLog(@"requestWentWrong: dealloc was called, calling again...");
		[self dealloc];
		return;
	}
	
	
    if ([delegate respondsToSelector:@selector(picture:couldNotLoadImageError:)])
    {
        [delegate picture:self couldNotLoadImageError:error];
    }
	
}

- (void)loadImage:(NSURL *)url
{
	if(downloadFailed) return;
	NSLog(@"Picture.loadImage: %@",[url description]);
    imageRequest = [[ASIHTTPRequest alloc] initWithURL:url];
    [imageRequest setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
	[imageRequest setSecondsToCache:60*60*24*3]; // Cache for 3 days
	[imageRequest setDelegate:self];
    [imageRequest setDidFinishSelector:@selector(imageRequestDone:)];
    [imageRequest setDidFailSelector:@selector(requestWentWrong:)];
    NSOperationQueue *queue = [PhotoExplorerAppDelegate sharedAppDelegate].downloadQueue;
    [queue addOperation:imageRequest];
    //[request release];    
}

- (void)loadThumbnail:(NSURL *)url
{
	if(downloadFailed) return;
	NSLog(@"Picture.loadThumbnail: %@",[url description]);
    thumbnailRequest = [[ASIHTTPRequest alloc] initWithURL:url];
	[thumbnailRequest setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
	[thumbnailRequest setSecondsToCache:60*60*24*3]; // Cache for 3 days
	[thumbnailRequest setDelegate:self];
    [thumbnailRequest setDidFinishSelector:@selector(thumbnailRequestDone:)];
    [thumbnailRequest setDidFailSelector:@selector(requestWentWrong:)];
    NSOperationQueue *queue = [PhotoExplorerAppDelegate sharedAppDelegate].downloadQueue;
    [queue addOperation:thumbnailRequest];
    //[request release];    
}

- (void) dealloc
{
	
	NSLog(@"Picture.dealloc");
	
	if(imageRequest)
	{
		NSLog(@"imageRequest still non nil, return from daealloc");
		
		dealloc_called=YES;
		return;
		//NSLog(@"imageRequest.clearDelegatesAndCancel");
		//[imageRequest clearDelegatesAndCancel];
		
		//[imageRequest release];
	}
	if(thumbnailRequest)
	{
		NSLog(@"thumbnailRequest still non nil, return from daealloc");
		dealloc_called=YES;
		return;
		//NSLog(@"thumbnailRequest.clearDelegatesAndCancel");
		//[thumbnailRequest clearDelegatesAndCancel];
		//[thumbnailRequest release];
	}
	//NSLog(@"Picture dealloc...");
	delegate=nil;
	[image release];
	[imageURL release];
	[thumbnail release];
	[thumbnailURL release];
	[description release];
	
	[super dealloc];
}
@end
