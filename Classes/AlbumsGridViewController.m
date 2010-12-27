#import "AlbumsGridViewController.h"
#import "Album.h"
#import "AlbumGridViewCell.h"
#import "PictureFeedGridViewController.h"

@implementation AlbumsGridViewController
 
- (NSString*) noDataMessage
{
	return @"No shared albums found on Facebook for this user.";
}


- (AQGridViewCell *) gridView: (AQGridView *) aGridView cellForItemAtIndex: (NSUInteger) index
{
    static NSString * cellIdentifier = @"CellIdentifier";
	
    AlbumGridViewCell * photoCell = nil; //(AlbumGridViewCell *)[aGridView dequeueReusableCellWithIdentifier: cellIdentifier];
	if ( photoCell == nil )
	{
		photoCell = [[[AlbumGridViewCell alloc] initWithFrame: CGRectMake(0.0, 0.0, 224.0, 244.0)
											  reuseIdentifier: cellIdentifier] autorelease];
		photoCell.showBorder=YES; // not for profile pics...
		
		photoCell.selectionStyle = AQGridViewCellSelectionStyleBlueGray;
	}
	
	Album * album=(Album*)[items objectAtIndex:index];
	photoCell.picture=[album picture];
	 
	return photoCell;
}

- (void) gridView: (AQGridView *) gridView didSelectItemAtIndex: (NSUInteger) index
{
	if(index<0 || index>([items count]-1))
	{
		// some bug in grid view allows bogus selections sometimes...
		return;
	}
	Album * album=(Album*)[items objectAtIndex:index];
	// show album...
	PictureFeedGridViewController * picturesController=[[PictureFeedGridViewController alloc] initWithFeed:album.pictureFeed title:album.name];
	[[self navigationController] pushViewController:picturesController animated:YES];
	
	[picturesController release];
}

- (CGSize) portraitGridCellSizeForGridView: (AQGridView *) aGridView
{
    return ( CGSizeMake(224.0, 244.0) );
}
 
@end
