#import "Picture.h"
#import "ASIHTTPRequest.h"
#import "PhotoExplorerAppDelegate.h"

@implementation Picture
@synthesize image,imageURL,comments,delegate,width,height,thumbnailURL,thumbnail,description;

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
- (void) setImage:(UIImage *)newImage
{
	if(newImage!=image)
	{
		[image release];
		image=[newImage retain];
	}
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
	if([request didUseCachedResponse])
	{
		NSLog(@"Got image from cache...");
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
		NSLog(@"calling dealloc from imageRequestDone...");
		[self dealloc];
		return;
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
	if([request didUseCachedResponse])
	{
		NSLog(@"Got thumbnail from cache...");
	}
	
	if(dealloc_called)
	{
		@try 
		{
			if([request isEqual:thumbnailRequest])
			{
				[thumbnailRequest release];
				thumbnailRequest=nil;
			}
			else 
			{
				if([request isEqual:imageRequest])
				{
					[imageRequest release];
					imageRequest=nil;
				}
			}
		}
		@catch (NSException * e) {
			NSLog(@"Error releasing request in thumbnailRequestDone");
		}
		 
		NSLog(@"calling dealloc from thumbnailRequestDone...");
		[self dealloc];
		return;
	}
	else 
	{
		NSData *data = [request responseData];
		
		UIImage *remoteImage = [[UIImage alloc] initWithData:data];
		self.thumbnail = remoteImage;
		if ([delegate respondsToSelector:@selector(picture:didLoadImage:)])
		{
			[delegate picture:self didLoadImage:remoteImage];
		}
		[remoteImage release];
		
		if([request isEqual:thumbnailRequest])
		{
			[thumbnailRequest release];
			thumbnailRequest=nil;
		}
		else 
		{
			if([request isEqual:imageRequest])
			{
				[imageRequest release];
				imageRequest=nil;
			}
		}
	}
}

- (void)requestWentWrong:(ASIHTTPRequest *)request
{
	downloadFailed=YES;
	NSError *error = [request error];
	
	if([request isEqual:thumbnailRequest])
	{
		[thumbnailRequest release];
		thumbnailRequest=nil;
	}
	else 
	{
		if([request isEqual:imageRequest])
		{
			[imageRequest release];
			imageRequest=nil;
		}
	}

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

- (void)loadImage:(NSURL *)url
{
	if(downloadFailed) return;
	imageRequest = [[ASIHTTPRequest alloc] initWithURL:url];
    [imageRequest setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
	[imageRequest setSecondsToCache:60*60*24*3]; // Cache for 3 days
	[imageRequest setDelegate:self];
    [imageRequest setDidFinishSelector:@selector(imageRequestDone:)];
    [imageRequest setDidFailSelector:@selector(requestWentWrong:)];
    NSOperationQueue *queue = [PhotoExplorerAppDelegate sharedAppDelegate].downloadQueue;
    [queue addOperation:imageRequest];
}

- (void)loadThumbnail:(NSURL *)url
{
	if(downloadFailed) return;
	thumbnailRequest = [[ASIHTTPRequest alloc] initWithURL:url];
	[thumbnailRequest setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
	[thumbnailRequest setSecondsToCache:60*60*24*3]; // Cache for 3 days
	[thumbnailRequest setDelegate:self];
    [thumbnailRequest setDidFinishSelector:@selector(thumbnailRequestDone:)];
    [thumbnailRequest setDidFailSelector:@selector(requestWentWrong:)];
    NSOperationQueue *queue = [PhotoExplorerAppDelegate sharedAppDelegate].downloadQueue;
    [queue addOperation:thumbnailRequest];
}

- (void) dealloc
{
	if(imageRequest)
	{
		NSLog(@"Picture.dealloc: imageRequest still exists, cancelling request...");
		dealloc_called=YES;
		@try {
			[imageRequest cancel];
		}
		@catch (NSException * e) {
			NSLog(@"Error calling imageRequest.cancel");
		}
		return;
	}
	if(thumbnailRequest)
	{
		NSLog(@"Picture.dealloc: thumbnailRequest still exists, cancelling request...");
		dealloc_called=YES;
		@try {
			[thumbnailRequest cancel];
		}
		@catch (NSException * e) {
			NSLog(@"Error calling thumbnailRequest.cancel");
		}
		return;
	}
	delegate=nil;
	[image release];
	[imageURL release];
	[thumbnail release];
	[thumbnailURL release];
	[description release];
	[comments release];
	NSLog(@"Picture.dealloc completed...");
	[super dealloc];
}
@end
