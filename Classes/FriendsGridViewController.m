#import "FriendsGridViewController.h"
#import "Friend.h"
#import "PhotoGridViewCell.h"
#import "FriendGridViewCell.h"
#import "AlbumsGridViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "BlankToolbar.h"
#import "Picture.h"

@implementation FriendsGridViewController

- (AQGridViewCell *) gridView: (AQGridView *) aGridView cellForItemAtIndex: (NSUInteger) index
{
    static NSString * cellIdentifier = @"CellIdentifier";
	
	FriendGridViewCell * photoCell = (FriendGridViewCell *)[aGridView dequeueReusableCellWithIdentifier: cellIdentifier];
	if ( photoCell == nil )
	{
		photoCell = [[[FriendGridViewCell alloc] initWithFrame: CGRectMake(0.0, 0.0, 170.0, 170.0)
											  reuseIdentifier: cellIdentifier] autorelease];
		
		photoCell.selectionStyle = AQGridViewCellSelectionStyleBlueGray;
	}
	
	Friend  * friend=(Friend*)[items objectAtIndex:index];
	photoCell.picture=friend.picture;

	return photoCell;
}

- (CGSize) portraitGridCellSizeForGridView: (AQGridView *) aGridView
{
	return ( CGSizeMake(170.0, 170.0) );
}

- (void) gridView: (AQGridView *) gridView didSelectItemAtIndex: (NSUInteger) index
{
	Friend  * friend=(Friend*)[items objectAtIndex:index];
	
	[self showFriendAlbums:friend];
}
- (void) showFriendAlbums:(Friend*)friend
{
	AlbumsGridViewController * controller=[[AlbumsGridViewController alloc] initWithFeed:friend.albumFeed title:[NSString stringWithFormat:@"%@'s Albums",friend.name]];
	
	[[self navigationController] pushViewController:controller animated:YES];
	
	[controller release];
}

- (void) viewDidLoad
{
	[super viewDidLoad];
	
	filteredItems=[[NSMutableArray alloc] init];

	searchBar=[[UISearchBar alloc] initWithFrame:CGRectMake(0,5,150,30)];
	searchBar.backgroundColor=[UIColor clearColor];
	searchBar.opaque=NO;
	searchBar.barStyle=UIBarStyleBlack;
	
	searchController=[[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
	searchController.delegate=self;
	searchController.searchResultsDelegate=self;
	searchController.searchResultsDataSource=self;
	
	self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc] initWithCustomView:searchBar] autorelease];
}

- (void)filterContentForSearchText:(NSString*)searchText
{
	NSLog(@"filterContentForSearchText: %@",searchText);
	
	[filteredItems removeAllObjects]; 
	
	for (Friend	*f in items)
	{
		NSComparisonResult result = [f.name compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
        if (result == NSOrderedSame)
		{
			[filteredItems addObject:f];
			continue;
		}
		result = [f.first_name compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
		if (result == NSOrderedSame)
		{
			[filteredItems addObject:f];
			continue;
		}
		result = [f.last_name compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
        if (result == NSOrderedSame)
		{
			[filteredItems addObject:f];
			continue;
		}
	}
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
	NSLog(@"searchDisplayController:shouldReloadTableForSearchString %@",searchString);
	
    [self filterContentForSearchText:searchString];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
	NSLog(@"searchDisplayController:shouldReloadTableForSearchScope ");
	
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSLog(@"numberOfRowsInSection");
	return [filteredItems count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@"didSelectRowAtIndexPath");
	Friend * friend=[filteredItems objectAtIndex:indexPath.row];
	// need to dismiss search results popover now...
	[searchController setActive:NO animated:YES];
	[self showFriendAlbums:friend];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@"cellForRowAtIndexPath");
	static NSString *kCellID = @"cellID";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
	}
	
	Friend *friend = [filteredItems objectAtIndex:indexPath.row];
    
	cell.textLabel.text = friend.name;
	
	return cell;
}

- (void) dealloc
{
	[searchBar release];
	[searchController release];
	[filteredItems release];
	[super dealloc];
}

@end
