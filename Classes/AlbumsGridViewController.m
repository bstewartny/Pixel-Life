#import "AlbumsGridViewController.h"
#import "Album.h"
#import "AlbumGridViewCell.h"
#import "PictureFeedGridViewController.h"
#import "AlbumGridViewController.h"
#import "BlankToolbar.h"

@implementation AlbumsGridViewController
 
- (void) slideshow:(id)sender
{
	UIActionSheet * sheet=[[UIActionSheet alloc] initWithTitle:@"Slideshow" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Start Slideshow",nil];
	sheet.tag=kAlbumsSlideshowActionSheet;
	[sheet showFromBarButtonItem:sender animated:YES];
	
	[sheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(actionSheet.tag==kAlbumsSlideshowActionSheet)
	{
		if (buttonIndex==0) {
			// start slideshow...
		}
	}
}

- (NSString*) noDataMessage
{
	return @"No shared albums found.";
}

- (void) viewWillAppear:(BOOL)animated
{
	
	
	if([self.navigationItem.titleView isKindOfClass:[UISegmentedControl class]])
	{
		UISegmentedControl * sc=[(UISegmentedControl*)self.navigationItem.titleView retain];
		[sc sizeToFit];
		self.navigationItem.titleView=nil;
		self.navigationItem.titleView=sc;
		[sc release];
		
		/*CGRect frame=self.navigationItem.titleView.frame;
		frame.size.width=300;
		self.navigationItem.titleView.frame=frame;*/
	
	}
	
	[super viewWillAppear:animated];
}
- (AQGridViewCell *) gridView: (AQGridView *) aGridView cellForItemAtIndex: (NSUInteger) index
{
    static NSString * cellIdentifier = @"CellIdentifier";
	
    AlbumGridViewCell * photoCell = (AlbumGridViewCell *)[aGridView dequeueReusableCellWithIdentifier: cellIdentifier];
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
	AlbumGridViewController * albumController=[[AlbumGridViewController alloc] initWithAlbum:album];
	
	[[self navigationController] pushViewController:albumController animated:YES];
	
	[albumController release];
}

- (CGSize) portraitGridCellSizeForGridView: (AQGridView *) aGridView
{
    return ( CGSizeMake(224.0, 244.0) );
}
 
@end
