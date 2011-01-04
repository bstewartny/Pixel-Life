#import "PictureFeedGridViewController.h"
#import "Picture.h"
#import "PhotoGridViewCell.h"
#import "PictureViewController.h"
#import "PicturesScrollViewController.h"

@implementation PictureFeedGridViewController

- (AQGridViewCell *) gridView: (AQGridView *) aGridView cellForItemAtIndex: (NSUInteger) index
{
    static NSString * cellIdentifier = @"CellIdentifier";
   
    PhotoGridViewCell * photoCell = (PhotoGridViewCell *)[aGridView dequeueReusableCellWithIdentifier: cellIdentifier];
	if ( photoCell == nil )
	{
		photoCell = [[[PhotoGridViewCell alloc] initWithFrame: CGRectMake(0.0, 0.0, 168.0, 168.0)
												 reuseIdentifier: cellIdentifier] autorelease];
		photoCell.showBorder=YES; // not for profile pics...
		
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
	PicturesScrollViewController * controller=[[PicturesScrollViewController alloc] initWithPictures:items];
	
	controller.currentItemIndex=index;
	
	[[self navigationController] pushViewController:controller animated:YES];
	
	[controller release];
}
 
@end
