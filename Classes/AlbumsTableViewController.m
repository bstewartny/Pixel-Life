#import "AlbumsTableViewController.h"
#import "PixelLifeAppDelegate.h"
#import "Reachability.h"
#import "Feed.h"
#import "Friend.h"
#import "Album.h"
#import "PictureTableViewCell.h"
#import "Picture.h"
#import "PhoneAlbumGridViewController.h"

@implementation AlbumsTableViewController
@synthesize tableView;

- (id)initWithFeed:(Feed*)feed title:(NSString*)title
{
    if(self=[super initWithFeed:feed title:title withNibName:@"FriendsTableView"])
	{
		/*self.gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		 self.gridView.autoresizesSubviews = YES;
		 self.gridView.delegate = self;
		 self.gridView.dataSource = self;
		 
		 self.gridView.separatorStyle = AQGridViewCellSeparatorStyleEmptySpace;
		 self.gridView.resizesCellWidthToFit = YES;
		 self.gridView.separatorColor = [UIColor blackColor];
		 self.gridView.backgroundColor=[UIColor blackColor];*/
    }
    return self;
}
- (void) reloadData
{
	[tableView reloadData];
	
	//[gridView updateVisibleGridCellsNow];
	[self loadVisibleCells];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView; 
{
    // Method is called when the decelerating comes to a stop.
    // Pass visible cells to the cell loading function. If possible change 
    // scrollView to a pointer to your table cell to avoid compiler warnings
    [self loadVisibleCells]; 
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
{
    if (!decelerate) 
    {
        [self loadVisibleCells]; 
    }
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	[self loadVisibleCells]; 
}

- (void) loadVisibleCells
{
	for(PictureTableViewCell * cell in [tableView visibleCells])
	{
		[cell load];
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	//NSLog(@"numberOfRowsInSection");
	return [items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *kCellID = @"cellID";
	
	PictureTableViewCell *cell = nil;// [tableView dequeueReusableCellWithIdentifier:kCellID];
	if (cell == nil)
	{
		cell = [[[PictureTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
		cell.textLabel.textColor=[UIColor whiteColor];
		cell.detailTextLabel.textColor=[UIColor lightGrayColor];
		//cell.useLargeImage=YES;
	}
	
	Album *album = [items objectAtIndex:indexPath.row];
    
	cell.textLabel.text = album.name;
	cell.detailTextLabel.text=[NSString stringWithFormat:@"%d photos",album.count];
	cell.picture=album.picture;
	if([album.picture hasLoadedThumbnail])
	{
		cell.imageView.image=album.picture.thumbnail;
	}
	return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60.0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	//NSLog(@"didSelectRowAtIndexPath");
	Album *album=[items objectAtIndex:indexPath.row];
	// need to dismiss search results popover now...
	//[searchController setActive:NO animated:YES];
	PhoneAlbumGridViewController * albumController=[[PhoneAlbumGridViewController alloc] initWithAlbum:album];
	
	[[self navigationController] pushViewController:albumController animated:YES];
	
	[albumController release];
}
 
- (void)dealloc {
	[tableView release];
    [super dealloc];
}


@end
