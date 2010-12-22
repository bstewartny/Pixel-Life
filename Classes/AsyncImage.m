//
//  AsyncImage.m
//  PhotoExplorer
//
//  Created by Robert Stewart on 12/22/10.
//  Copyright 2010 Evernote. All rights reserved.
//

#import "AsyncImage.h"
#import "ASIHTTPRequest.h"
#import "PhotoExplorerAppDelegate.h"

@implementation AsyncImage
@synthesize image,url,delegate;

- (void) setUrl:(NSString*)u
{
	if(u!=url)
	{
		[url release];
		url=[u retain];
		self.image=nil;
	}
}

- (UIImage*) getImageFromCacheWithUrl:(NSString*)url
{
	return [[[PhotoExplorerAppDelegate sharedAppDelegate] imageCache] imageForUrl:url];
}

- (void) addImageToCache:(UIImage*)image withUrl:(NSString*)url
{
	[[[PhotoExplorerAppDelegate sharedAppDelegate] imageCache] setImage:image forUrl:url];
}

- (BOOL) hasLoadedImage
{
	return (image!=nil);
}

- (void) setImage:(UIImage *)newImage
{
	@synchronized(self)
	{
		if(newImage!=image)
		{
			[image release];
			image=[newImage retain];
		}
	}
}

- (UIImage*)image
{
	@synchronized(self)
	{
		if(image==nil)
		{
			UIImage * cachedImage=[self getImageFromCacheWithUrl:self.url];
			if(cachedImage)
			{
				self.image=cachedImage;
				return cachedImage;
			}
			if(!downloadFailed)
			{
				NSURL * url=[NSURL URLWithString:self.url];
				[self loadImage:url];
			}
		}
	}
	
	return image;
}

- (void)imageRequestDone:(ASIHTTPRequest *)request
{
	@synchronized(self)
	{
		if([request didUseCachedResponse])
		{
			NSLog(@"Got image from cache...");
		}
		if(dealloc_called)
		{
			[self releaseRequest:request];
			NSLog(@"calling dealloc from imageRequestDone...");
			[self dealloc];
			return;
		}
		NSData *data = [request responseData];
		
		UIImage *remoteImage = [[UIImage alloc] initWithData:data];
		self.image = remoteImage;
		[self addImageToCache:remoteImage withUrl:self.url];
		if ([delegate respondsToSelector:@selector(picture:didLoadImage:)])
		{
			[delegate picture:self didLoadImage:remoteImage];
		}
		[remoteImage release];
		
		[self releaseRequest:request];
	}
}

- (void)releaseRequest:(ASIHTTPRequest*)request
{
	NSLog(@"releaseRequest: %@",[request description]);
	@try 
	{
		if(request==imageRequest)
		{
			NSLog(@"releasing imageRequest...");
			[imageRequest release];
			imageRequest=nil;
		}
	}
	@catch (NSException * e) {
		NSLog(@"Error releasing request");
	}
}

- (void)requestWentWrong:(ASIHTTPRequest *)request
{
	@synchronized(self)
	{
		//downloadFailed=YES;
		NSError *error = [request error];
		
		[self releaseRequest:request];
		
		if(dealloc_called)
		{
			NSLog(@"calling dealloc from requestWentWrong...");
			[self dealloc];
			return;
		}
		
		if ([delegate respondsToSelector:@selector(picture:couldNotLoadImageError:)])
		{
			[delegate picture:self couldNotLoadImageError:error];
		}
	}
}

- (void)loadImage:(NSURL *)url
{
	@synchronized(self)
	{
		UIImage * cachedImage=[self getImageFromCacheWithUrl:self.url];
		if(cachedImage)
		{
			NSLog(@"got image from app cache...");
			self.image = cachedImage;
			if ([delegate respondsToSelector:@selector(picture:didLoadImage:)])
			{
				[delegate picture:self didLoadImage:cachedImage];
			}
			return;
		}
		
		if(downloadFailed) return;
		
		if(imageRequest)
		{
			// already submitted...
			return;
		}
		imageRequest = [self createAndSubmitImageRequest:url];
	}
}

- (ASIHTTPRequest*)createAndSubmitImageRequest:(NSURL*)url
{
	ASIHTTPRequest * request = [[ASIHTTPRequest alloc] initWithURL:url];
	[request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
	[request setSecondsToCache:60*60*24*3]; // Cache for 3 days
	[request setDelegate:self];
    [request setDidFinishSelector:@selector(imageRequestDone:)];
    [request setDidFailSelector:@selector(requestWentWrong:)];
    NSOperationQueue *queue = [PhotoExplorerAppDelegate sharedAppDelegate].downloadQueue;
    [queue addOperation:request];
	return  request;
}

- (void)cancelRequest:(ASIHTTPRequest*)request
{
	@try 
	{
		[request cancel];
	}
	@catch (NSException * e) 
	{
		NSLog(@"Error calling request.cancel");
	}
}

- (void) dealloc
{
	dealloc_called=YES;
	if(imageRequest)
	{
		NSLog(@"Picture.dealloc: imageRequest still exists, cancelling request...");
		[self cancelRequest:imageRequest];
		return;
	}
	delegate=nil;
	[image release];
	[url release];
	NSLog(@"AsyncImage.dealloc completed...");
	[super dealloc];
}


@end
