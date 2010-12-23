#import "Picture.h"
#import "AsyncImage.h"

@implementation Picture
@synthesize imageURL,commentCount,delegate,width,height,thumbnailURL,description;

- (id) init
{
	if(self=[super init])
	{
		asyncImage=[[AsyncImage alloc] init];
		asyncImage.delegate=self;
		asyncThumbnail=[[AsyncImage alloc] init];
		asyncThumbnail.delegate=self;
	}
	return self;
}

- (void)image:(AsyncImage *)item couldNotLoadImageError:(NSError *)error
{
	if ([delegate respondsToSelector:@selector(picture:couldNotLoadImageError:)])
	{
		[delegate picture:self couldNotLoadImageError:error];
	}
}

- (void)image:(AsyncImage *)item didLoadImage:(UIImage *)image
{
	if ([delegate respondsToSelector:@selector(picture:didLoadImage:)])
	{
		[delegate picture:self didLoadImage:image];
	}
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
}

- (BOOL) hasLoadedThumbnail
{
	return [asyncThumbnail hasLoadedImage];
}

- (UIImage*)thumbnail
{
	return asyncThumbnail.image;
} 

- (UIImage*)image
{
	return asyncImage.image;
}
- (void) unloadImage
{
	[asyncImage setImage:nil];
}

- (void) dealloc
{
	[asyncImage setDelegate:nil];
	[asyncImage release];
	[asyncThumbnail setDelegate:nil];
	[asyncThumbnail release];
	delegate=nil;
	[description release];
	NSLog(@"Picture.dealloc completed...");
	[super dealloc];
}
@end
