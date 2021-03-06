#import "FriendsGridViewController.h"
#import "Friend.h"
#import "PhotoGridViewCell.h"
#import "FriendGridViewCell.h"
#import "AlbumsGridViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "BlankToolbar.h"
#import "Picture.h"
#import "FriendSearchResultTableViewCell.h"

@implementation FriendsGridViewController

- (NSString*) noDataMessage
{
	return @"No friends found on Facebook.";
}

- (AQGridViewCell *) gridView: (AQGridView *) aGridView cellForItemAtIndex: (NSUInteger) index
{
    static NSString * cellIdentifier = @"CellIdentifier";
	
	FriendGridViewCell * photoCell = (FriendGridViewCell *)[aGridView dequeueReusableCellWithIdentifier: cellIdentifier];
	if ( photoCell == nil )
	{
		photoCell = [[[FriendGridViewCell alloc] initWithFrame: CGRectMake(0.0, 0.0, 192.0, 192.0)
											  reuseIdentifier: cellIdentifier] autorelease];
		
		//photoCell.selectionStyle = AQGridViewCellSelectionStyleBlueGray;
		photoCell.selectionStyle=AQGridViewCellSelectionStyleNone;
		
	}
	
	Friend  * friend=(Friend*)[items objectAtIndex:index];
	photoCell.picture=friend.picture;

	return photoCell;
}

- (CGSize) portraitGridCellSizeForGridView: (AQGridView *) aGridView
{
	return CGSizeMake(192.0, 192.0);
	//return ( CGSizeMake(170.0, 170.0) );
}

- (void) gridView: (AQGridView *) gridView didSelectItemAtIndex: (NSUInteger) index
{
	if(index<0 || index>([items count]-1))
	{
		// some bug in grid view allows bogus selections sometimes...
		return;
	}

	Friend  * friend=(Friend*)[items objectAtIndex:index];
	
	[self showFriendAlbums:friend];
}

- (void) showFriendAlbums:(Friend*)friend
{
	AlbumsGridViewController * controller=[[AlbumsGridViewController alloc] initWithFeed:friend.albumFeed title:[NSString stringWithFormat:@"%@'s Albums",friend.name]];
	
	[[self navigationController] pushViewController:controller animated:NO];
		
	[controller release];
}

- (void) viewDidLoad
{
	[super viewDidLoad];
	
	
	
	
	
	[self setupSearchController];
}

- (void) viewWillAppear:(BOOL)animated
{
	
	
	[self layoutSubviews];
	[super viewWillAppear:animated];
}


- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView
{
	searchController.searchResultsTableView.backgroundColor=[UIColor blackColor];
	searchController.searchResultsTableView.separatorColor=[UIColor blackColor];
	searchController.searchResultsTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
}

- (void) setupSearchController
{
	
	self.gridView.resizesCellWidthToFit=YES;
	self.gridView.separatorStyle=AQGridViewCellSeparatorStyleNone;
	
	
	filteredItems=[[NSMutableArray alloc] init];

	searchBar=[[UISearchBar alloc] initWithFrame:CGRectMake(0,5,150,30)];
	searchBar.backgroundColor=[UIColor clearColor];
	searchBar.opaque=NO;
	searchBar.barStyle=UIBarStyleBlack;
	//searchBar.autoresizingMask=UIViewAutoresizingNone;
	
	searchController=[[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
	searchController.delegate=self;
	searchController.searchResultsDelegate=self;
	searchController.searchResultsDataSource=self;
	searchController.searchResultsTableView.backgroundColor=[UIColor blackColor];
	searchController.searchResultsTableView.separatorColor=[UIColor blackColor];
	searchController.searchResultsTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
	
	self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc] initWithCustomView:searchBar] autorelease];
}


- (void) layoutSubviews
{
	// yet another cocoa hack in order to work around some sdk bug... need to reset frame after device was rotated in
	// another view, otherwise UISearchDisplayController makes the search box too big...
	CGRect f=searchBar.frame;
	if(f.size.width>150)
	{
		f.size.width=150;
		searchBar.frame=f;
	}
	//searchBar.frame=CGRectMake(0,5,150,30);
	
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
}


- (void)filterContentForSearchText:(NSString*)searchText
{
	[filteredItems removeAllObjects]; 
	
	for (Friend	*f in items)
	{
		// see if full name starts with search text
		NSComparisonResult result = [f.name compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
        if (result == NSOrderedSame)
		{
			[filteredItems addObject:f];
			continue;
		}
		// see if first name starts with search text
		result = [f.first_name compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
		if (result == NSOrderedSame)
		{
			[filteredItems addObject:f];
			continue;
		}
		// see if last name starts with search text
		result = [f.last_name compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
        if (result == NSOrderedSame)
		{
			[filteredItems addObject:f];
			continue;
		}
		
		// split full name on white space and try each word seperately...
		NSArray * parts=[f.name componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		
		if([parts count]>2)
		{
			BOOL part_matched=NO;
			for(NSString * part in parts)
			{
				result = [part compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
				if (result == NSOrderedSame)
				{
					part_matched=YES;
					[filteredItems addObject:f];
					break;
				}
			}
			if(part_matched)
			{
				continue;
			}
		}
	
		// split last name on white space and try each word seperately...
		parts=[f.last_name componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		
		if([parts count]>1)
		{
			BOOL part_matched=NO;
			for(NSString * part in parts)
			{
				result = [part compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
				if (result == NSOrderedSame)
				{
					part_matched=YES;
					[filteredItems addObject:f];
					break;
				}
			}
			if(part_matched)
			{
				continue;
			}
		}
	}
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
	[self filterContentForSearchText:searchString];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
	[self filterContentForSearchText:[self.searchDisplayController.searchBar text]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [filteredItems count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	Friend * friend=[filteredItems objectAtIndex:indexPath.row];
	// need to dismiss search results popover now...
	[searchController setActive:NO animated:YES];
	[self showFriendAlbums:friend];
}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
}*/

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	[cell load];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	FriendSearchResultTableViewCell * cell = [[[FriendSearchResultTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
	
	cell.selectionStyle=UITableViewCellSelectionStyleNone;
	cell.textLabel.textColor=[UIColor whiteColor];
	
	Friend *friend= [filteredItems objectAtIndex:indexPath.row];
	 
	cell.nameLabel.text=friend.name;
	
	//cell.textLabel.text = friend.name;
	cell.picture=friend.picture;
	
	if([friend.picture hasLoadedThumbnail])
	{
		cell.imageView.image=friend.picture.thumbnail;
	}
	
	return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 84.0;
}








- (void) dealloc
{
	[searchBar release];
	[searchController release];
	[filteredItems release];
	[super dealloc];
}

@end
