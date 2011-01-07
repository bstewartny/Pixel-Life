#import "FriendsTableViewController.h"
#import "PixelLifeAppDelegate.h"
#import "Reachability.h"
#import "Feed.h"
#import "Friend.h"
#import "AlbumsTableViewController.h"
#import "PictureTableViewCell.h"
#import "Picture.h"
@implementation FriendsTableViewController
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *kCellID = @"cellID";
	
	PictureTableViewCell *cell = nil;// [tableView dequeueReusableCellWithIdentifier:kCellID];
	if (cell == nil)
	{
		cell = [[[PictureTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
		//cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
		cell.textLabel.textColor=[UIColor whiteColor];
	}
	
	Friend *friend = [items objectAtIndex:indexPath.row];
    
	cell.textLabel.text = friend.name;
	cell.picture=friend.picture;
	if([friend.picture hasLoadedThumbnail])
	{
		cell.imageView.image=friend.picture.thumbnail;
	}
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	//NSLog(@"didSelectRowAtIndexPath");
	Friend * friend=[items objectAtIndex:indexPath.row];
	// need to dismiss search results popover now...
	//[searchController setActive:NO animated:YES];
	[self showFriendAlbums:friend];
}

- (void) showFriendAlbums:(Friend*)friend
{
	AlbumsTableViewController * controller=[[AlbumsTableViewController alloc] initWithFeed:friend.albumFeed title:[NSString stringWithFormat:@"%@'s Albums",friend.name]];
	
	[[self navigationController] pushViewController:controller animated:YES];
	
	[controller release];
}

- (void)dealloc {
	[tableView release];
    [super dealloc];
}


@end
