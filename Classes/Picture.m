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
@synthesize image,imageURL,delegate;

- (BOOL) hasLoadedImage
{
	return downloadFailed || (image!=nil);
}

- (UIImage*)image
{
	if(image==nil)
	{
		if(!downloadFailed)
		{
			NSURL * url=[NSURL URLWithString:self.imageURL];
			[self loadURL:url];
		}
	}
	
	return image;
}
- (void)requestDone:(ASIHTTPRequest *)request
{
	NSLog(@"Picture.requestDone");
	NSData *data = [request responseData];
    
	UIImage *remoteImage = [[UIImage alloc] initWithData:data];
    self.image = remoteImage;
    if ([delegate respondsToSelector:@selector(picture:didLoadImage:)])
    {
        [delegate picture:self didLoadImage:remoteImage];
    }
    [remoteImage release];
}

- (void)requestWentWrong:(ASIHTTPRequest *)request
{
	downloadFailed=YES;
	NSLog(@"Picture.requestWentWrong");
	NSError *error = [request error];
    if ([delegate respondsToSelector:@selector(picture:couldNotLoadImageError:)])
    {
        [delegate picture:self couldNotLoadImageError:error];
    }
}

- (void)loadURL:(NSURL *)url
{
	if(downloadFailed) return;
	NSLog(@"Picture.loadURL: %@",[url description]);
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(requestDone:)];
    [request setDidFailSelector:@selector(requestWentWrong:)];
    NSOperationQueue *queue = [PhotoExplorerAppDelegate sharedAppDelegate].downloadQueue;
    [queue addOperation:request];
    [request release];    
}

- (void) dealloc
{
	delegate=nil;
	[image release];
	[imageURL release];
	[super dealloc];
}
@end
