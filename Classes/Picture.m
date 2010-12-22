#import "Picture.h"
#import "ASIHTTPRequest.h"
#import "PhotoExplorerAppDelegate.h"
#import "AsyncImage.h"

@implementation Picture
@synthesize imageURL,commentCount,delegate,width,height,thumbnailURL,description,asyncImage,asyncThumbnail;

- (id) init
{
	if(self=[super init])
	{
		asyncImage=[[AsyncImage alloc] init];
		asyncThumbnail=[[AsyncImage alloc] init];
	}
	return self;
}

- (void) setImageURL:(NSString *)url
{
	asyncImage.url=url;
}

- (void) setThumbnailURL:(NSString *)url
{
	asyncThumbnail.url=url;
}

- (NSString*) thumbnailURL
{
	return asyncThumbnail.url;
}

- (NSString*) imageURL
{
	return asyncImage.url;
}

- (BOOL) hasLoadedImage
{
	return [asyncImage hasLoadedImage];
	//return downloadFailed || (image!=nil);
}

- (BOOL) hasLoadedThumbnail
{
	return [asyncThumbnail hasLoadedImage];
	//return downloadFailed || (thumbnail!=nil);
}

- (UIImage*)thumbnail
{
	return asyncThumbnail.image;
	/*
	@synchronized(self)
	{
		if(thumbnail==nil)
		{
			UIImage * cachedImage=[self getImageFromCacheWithUrl:self.thumbnailURL];
			if(cachedImage)
			{
				self.thumbnail=cachedImage;
				return cachedImage;
			}
			
			if(!downloadFailed)
			{
				NSURL * url=[NSURL URLWithString:self.thumbnailURL];
				[self loadThumbnail:url];
			}
		}
	}
	
	return thumbnail;*/
} 
/*
- (UIImage*) getImageFromCacheWithUrl:(NSString*)url
{
	return [[[[UIApplication sharedApplication] delegate] imageCache] imageForUrl:url];
}
- (void) addImageToCache:(UIImage*)image withUrl:(NSString*)url
{
	[[[[UIApplication sharedApplication] delegate] imageCache] setImage:image forUrl:url];
}
*/
/*
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
}*/
/*
- (void) setThumbnail:(UIImage *)newImage
{
	@synchronized(self)
	{
		if(newImage!=thumbnail)
		{
			[thumbnail release];
			thumbnail=[newImage retain];
		}
	}
}*/

- (UIImage*)image
{
	return asyncImage.image;
	/*
	@synchronized(self)
	{
		if(image==nil)
		{
			UIImage * cachedImage=[self getImageFromCacheWithUrl:self.imageURL];
			if(cachedImage)
			{
				self.image=cachedImage;
				return cachedImage;
			}
			if(!downloadFailed)
			{
				NSURL * url=[NSURL URLWithString:self.imageURL];
				[self loadImage:url];
			}
		}
	}
	
	return image;*/
}
/*
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
		[self addImageToCache:remoteImage withUrl:self.imageURL];
		if ([delegate respondsToSelector:@selector(picture:didLoadImage:)])
		{
			[delegate picture:self didLoadImage:remoteImage];
		}
		[remoteImage release];
		
		[self releaseRequest:request];
	}
}*/
/*
- (void)releaseRequest:(ASIHTTPRequest*)request
{
	NSLog(@"releaseRequest: %@",[request description]);
	@try 
	{
		if(request==thumbnailRequest)
		{
			NSLog(@"releasing thumbnailRequest...");
			[thumbnailRequest release];
			thumbnailRequest=nil;
		}
		else 
		{
			if(request==imageRequest)
			{
				NSLog(@"releasing imageRequest...");
				[imageRequest release];
				imageRequest=nil;
			}
		}
	}
	@catch (NSException * e) {
		NSLog(@"Error releasing request");
	}
}

- (void)thumbnailRequestDone:(ASIHTTPRequest *)request
{
	@synchronized(self)
	{
		if([request didUseCachedResponse])
		{
			NSLog(@"Got thumbnail from cache...");
		}
		
		if(dealloc_called)
		{
			[self releaseRequest:request];
			NSLog(@"calling dealloc from thumbnailRequestDone...");
			[self dealloc];
			return;
		}
		else 
		{
			NSData *data = [request responseData];
			
			UIImage *remoteImage = [[UIImage alloc] initWithData:data];
			self.thumbnail = remoteImage;
			[self addImageToCache:remoteImage withUrl:self.thumbnailURL]; 
			if ([delegate respondsToSelector:@selector(picture:didLoadImage:)])
			{
				[delegate picture:self didLoadImage:remoteImage];
			}
			[remoteImage release];
			
			[self releaseRequest:request];
		}
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
		UIImage * cachedImage=[self getImageFromCacheWithUrl:self.imageURL];
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

- (void)loadThumbnail:(NSURL *)url
{
	@synchronized(self)
	{
		UIImage * cachedImage=[self getImageFromCacheWithUrl:self.thumbnailURL];
		if(cachedImage)
		{
			NSLog(@"got image from app cache...");
			self.thumbnail = cachedImage;
			if ([delegate respondsToSelector:@selector(picture:didLoadImage:)])
			{
				[delegate picture:self didLoadImage:cachedImage];
			}
			return;
		}
		
		if(downloadFailed) return;
		if(thumbnailRequest)
		{
			// already submitted...
			return;
		}
		thumbnailRequest = [self createAndSubmitImageRequest:url];
	}
}

- (ASIHTTPRequest*)createAndSubmitImageRequest:(NSURL*)url
{
	ASIHTTPRequest * request = [[ASIHTTPRequest alloc] initWithURL:url];
	[request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
	[request setSecondsToCache:60*60*24*3]; // Cache for 3 days
	[request setDelegate:self];
    [request setDidFinishSelector:@selector(thumbnailRequestDone:)];
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
*/
- (void) dealloc
{
	[asyncImage release];
	[asyncThumbnail release];
	//@synchronized(self)
	//{
		/*dealloc_called=YES;
		if(imageRequest)
		{
			NSLog(@"Picture.dealloc: imageRequest still exists, cancelling request...");
			[self cancelRequest:imageRequest];
			return;
		}
		if(thumbnailRequest)
		{
			NSLog(@"Picture.dealloc: thumbnailRequest still exists, cancelling request...");
			[self cancelRequest:thumbnailRequest];
			return;
		}*/
	//}
	delegate=nil;
	//[image release];
	//[imageURL release];
	//[thumbnail release];
	//[thumbnailURL release];
	[description release];
	NSLog(@"Picture.dealloc completed...");
	[super dealloc];
}
@end
