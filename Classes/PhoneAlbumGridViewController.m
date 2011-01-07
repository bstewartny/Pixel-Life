#import "PhoneAlbumGridViewController.h"
#import "Album.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "PixelLifeAppDelegate.h"
#import "FacebookAlbumCommentsFeed.h"
#import "FacebookAccount.h"
#import "PicturesScrollViewController.h"
#import "PictureGridViewCell.h"

@implementation PhoneAlbumGridViewController
@synthesize album;

- (id) initWithAlbum:(Album*)album
{
	if(self=[super initWithFeed:album.pictureFeed title:album.name])
	{
		self.album=album;
	}
	return self;
}
- (CGSize) portraitGridCellSizeForGridView: (AQGridView *) aGridView
{
    return ( CGSizeMake(76.0, 80.0) );
}
- (AQGridViewCell *) gridView: (AQGridView *) aGridView cellForItemAtIndex: (NSUInteger) index
{
    static NSString * cellIdentifier = @"CellIdentifier";
	
    PictureGridViewCell * photoCell = (PictureGridViewCell *)[aGridView dequeueReusableCellWithIdentifier: cellIdentifier];
	if ( photoCell == nil )
	{
		photoCell = [[[PictureGridViewCell alloc] initWithFrame: CGRectMake(0.0, 0.0, 76.0, 76.0)
											  reuseIdentifier: cellIdentifier] autorelease];
		//photoCell.showBorder=YES; // not for profile pics...
		
		photoCell.selectionStyle = AQGridViewCellSelectionStyleBlueGray;
	}
	
	Picture * picture=(Picture*)[items objectAtIndex:index];
	
	photoCell.picture=picture;
	
	return photoCell;
}
- (void) gridView: (AQGridView *) gridView didSelectItemAtIndex: (NSUInteger) index
{
	if(index<0 || index>([items count]-1))
	{
		// some bug in grid view allows bogus selections sometimes...
		return;
	}
	PicturesScrollViewController * controller=[[PicturesScrollViewController alloc] initWithPictures:items phoneMode:YES];
	
	controller.currentItemIndex=index;
	
	[[self navigationController] pushViewController:controller animated:YES];
	
	[controller release];
}


- (void) dealloc
{
	[album release];
	[super dealloc];
}
@end
