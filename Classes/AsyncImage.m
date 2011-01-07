#import "AsyncImage.h"
#import "ASIHTTPRequest.h"
#import "PixelLifeAppDelegate.h"

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

- (UIImage*) getImageFromCacheWithUrl:(NSString*)withUrl
{
	return [[[PixelLifeAppDelegate sharedAppDelegate] imageCache] imageForUrl:withUrl];
}

- (void) addImageToCache:(UIImage*)image withUrl:(NSString*)withUrl
{
	[[[PixelLifeAppDelegate sharedAppDelegate] imageCache] setImage:image forUrl:withUrl];
}

- (BOOL) hasLoadedImage
{
	return (image!=nil);
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
			[self loadImage:[NSURL URLWithString:self.url]];
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
			
			//NSLog(@"calling dealloc from imageRequestDone...");
		
			[self dealloc];
		}
		else 
		{
			NSData *data = [request responseData];
			
			UIImage *remoteImage = [[UIImage alloc] initWithData:data];
			
			self.image = remoteImage;
			
			[self addImageToCache:remoteImage withUrl:self.url];
			
			if ([delegate respondsToSelector:@selector(image:didLoadImage:)])
			{
				[delegate image:self didLoadImage:remoteImage];
			}
			
			[remoteImage release];
			
			[self releaseRequest:request];
		}
	}
}

- (void)releaseRequest:(ASIHTTPRequest*)request
{
	//NSLog(@"releaseRequest: %@",[request description]);
	@try 
	{
		if(request==imageRequest)
		{
			//NSLog(@"releasing imageRequest...");
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
		NSError *error = [request error];
		
		[self releaseRequest:request];
		
		if(dealloc_called)
		{
			//NSLog(@"calling dealloc from requestWentWrong...");
			[self dealloc];
		}
		else 
		{
			if ([delegate respondsToSelector:@selector(image:couldNotLoadImageError:)])
			{
				[delegate image:self couldNotLoadImageError:error];
			}
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
			//NSLog(@"got image from app cache...");
			self.image = cachedImage;
			if ([delegate respondsToSelector:@selector(picture:didLoadImage:)])
			{
				[delegate picture:self didLoadImage:cachedImage];
			}
		}
		else 
		{
			if(imageRequest==nil) // otherwise request already submitted...
			{
				imageRequest = [self createAndSubmitImageRequest:url];
			}
		}
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
    NSOperationQueue *queue = [PixelLifeAppDelegate sharedAppDelegate].downloadQueue;
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
		//NSLog(@"Picture.dealloc: imageRequest still exists, cancelling request...");
		[self cancelRequest:imageRequest];
	}
	else 
	{
		delegate=nil;
		[image release];
		[url release];
		//NSLog(@"AsyncImage.dealloc completed...");
		[super dealloc];
	}
}  

@end
