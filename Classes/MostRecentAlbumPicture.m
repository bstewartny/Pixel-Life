#import "MostRecentAlbumPicture.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"
#import "PixelLifeAppDelegate.h"

@implementation MostRecentAlbumPicture
@synthesize albumId,accessToken;

- (void) dealloc
{
	[albumId release];
	albumId=nil;
	[accessToken release];
	accessToken=nil;
	[super dealloc];
}


- (UIImage*)thumbnail
{
	if(asyncThumbnail.url)
	{	
		return asyncThumbnail.image;
	}
	else 
	{
		[self getImageUrlsFromAlbum];
		return nil;
	}
} 

- (UIImage*)image
{
	if(asyncImage.url)
	{
		return asyncImage.image;
	}
	else 
	{
		[self getImageUrlsFromAlbum];
		return nil;
	}
}

- (NSString*) escapeQueryValue:(NSString*)value
{
	NSString * v= (NSString *)CFURLCreateStringByAddingPercentEscapes(
																	  NULL, /* allocator */
																	  (CFStringRef)value,
																	  NULL, /* charactersToLeaveUnescaped */
																	  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
																	  kCFStringEncodingUTF8);
	return [v autorelease];
}

- (NSArray*)getJsonFromResponseData:(NSData*)data
{
	return [[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease] JSONValue];
}

- (void) getImageUrlsFromAlbum
{
	// get URLs of most recent image from album using facebook api
	NSString * query=[NSString stringWithFormat:@"select pid,aid,src,src_height,src_width from photo where aid ='%@' order by created desc limit 1",albumId];
	
	NSString * escaped_query=[self escapeQueryValue:query];
	
	NSString* escaped_token = [self escapeQueryValue:accessToken];
	
	NSString * url=[NSString stringWithFormat:@"https://api.facebook.com/method/fql.query?format=JSON&access_token=%@&query=%@",escaped_token,escaped_query];
	
	ASIHTTPRequest * request=[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
	[request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
	[request setSecondsToCache:60*3]; // Cache for 3 minutes
	[request setDelegate:self];
	
	[request setDidFinishSelector:@selector(getImageUrlsFromAlbumDone:)];
	[request setDidFailSelector:@selector(getImageUrlsFromAlbumWentWrong:)];
	
	NSOperationQueue *queue = [PixelLifeAppDelegate sharedAppDelegate].downloadQueue;
	[queue addOperation:request];
	[request release];
}

- (void)getImageUrlsFromAlbumDone:(ASIHTTPRequest *)request
{
	if([request didUseCachedResponse])
	{
		NSLog(@"Got response from cache for: %@",[request.url description]);
	}
	
    NSData *data = [request responseData];
	
	NSArray * items=[self getJsonFromResponseData:data];
	
	if([items count]>0)
	{
		NSDictionary * item=[items objectAtIndex:0];
		
		// set urls...
		asyncImage.url=[item objectForKey:@"src"];
		asyncThumbnail.url=[item objectForKey:@"src"];
		
		self.width=[[item objectForKey:@"src_width"] intValue];
		self.height=[[item objectForKey:@"src_height"] intValue];
		
		if([asyncThumbnail.url length]>0)
		{
			// fire off aync image request... will call delegate when image is loaded
			UIImage * image=asyncThumbnail.image;
			// if image needs downloaded, we will have nil image, otherwise it already loaded (maybe from cache)
			if(image)
			{
				// notify delegate...(could have loaded image from cache)
				if ([delegate respondsToSelector:@selector(picture:didLoadImage:)])
				{
					[delegate picture:self didLoadImage:image];
				}
			}
		}
	}
}

- (void)getImageUrlsFromAlbumWentWrong:(ASIHTTPRequest *)request
{
	NSError *error = [request error];
	
	NSLog(@"getImageUrlsFromAlbumWentWrong: %@",[error description]);
}




@end
