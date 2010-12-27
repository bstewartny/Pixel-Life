#import "ImageCache.h"

@implementation ImageCache

- (id) init
{
	if(self=[super init])
	{
		cache=[[NSMutableDictionary alloc] init];
	}
	return self;
}

- (UIImage*) imageForUrl:(NSString*)url
{
	if(url==nil) return nil;
	@synchronized(cache)
	{
		return (UIImage*)[cache objectForKey:url];
	}
}

- (void) clear
{
	@synchronized(cache)
	{
		[cache removeAllObjects];
	}
}

- (void) setImage:(UIImage*)image forUrl:(NSString*)url
{
	if(image!=nil && url!=nil)
	{
		// only cache thumbnail style images
		if(image.size.width<=200 && image.size.height<=200)
		{
			@synchronized(cache)
			{
				[cache setObject:image forKey:url];
			}
		}
	}
}

- (void) dealloc
{
	[cache release];
	[super dealloc];
}


@end
