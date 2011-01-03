#import "AlbumsGridViewController.h"
#import "Album.h"
#import "AlbumGridViewCell.h"
#import "PictureFeedGridViewController.h"
#import "AlbumGridViewController.h"
#import "BlankToolbar.h"

@implementation AlbumsGridViewController
 
/*
- (void) viewDidLoad
{
	[super viewDidLoad];
	
	BlankToolbar * tools=[[BlankToolbar alloc] initWithFrame:CGRectMake(0, 0, 100, 44.01)];
	
	tools.backgroundColor=[UIColor clearColor];
	tools.opaque=NO;
	
	NSMutableArray * toolItems=[[NSMutableArray alloc] init];
	
	UIBarButtonItem * b;
	
	b=[[UIBarButtonItem	alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	[toolItems addObject:b];
	[b release];
	
	b=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_frame.png"] style:UIBarButtonItemStylePlain target:self action:@selector(slideshow:)];
	[toolItems addObject:b];
	[b release];
	
	[tools setItems:toolItems animated:NO];
	
	self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc] initWithCustomView:tools] autorelease];
	
	[tools release];
	[toolItems release];
	
}
*/
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
	//PictureFeedGridViewController * picturesController=[[PictureFeedGridViewController alloc] initWithFeed:album.pictureFeed title:album.name];
	AlbumGridViewController * albumController=[[AlbumGridViewController alloc] initWithAlbum:album];
	
	[[self navigationController] pushViewController:albumController animated:YES];
	
	[albumController release];
}

- (CGSize) portraitGridCellSizeForGridView: (AQGridView *) aGridView
{
    return ( CGSizeMake(224.0, 244.0) );
}
 
@end
