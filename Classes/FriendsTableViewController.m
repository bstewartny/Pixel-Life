#import "FriendsTableViewController.h"
#import "PixelLifeAppDelegate.h"
#import "Reachability.h"
#import "Feed.h"
#import "Friend.h"
#import "AlbumsTableViewController.h"
#import "PictureTableViewCell.h"
#import "Picture.h"

@implementation FriendsTableViewController
@synthesize searchBar;

- (id)initWithFeed:(Feed*)feed title:(NSString*)title
{
    if(self=[super initWithFeed:feed title:title withNibName:@"FriendsTableView"])
    {
		self.searchDisplayController.searchBar.barStyle=UIBarStyleBlack;
		self.searchDisplayController.searchResultsTableView.backgroundColor=[UIColor blackColor];
		self.searchDisplayController.searchResultsTableView.separatorColor=[UIColor blackColor];
		self.searchDisplayController.searchResultsTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
		filteredItems=[[NSMutableArray alloc] init];
		
		
		self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(search:)] autorelease];
    }
    return self;
}

- (void) search:(id)sender
{
	[self.searchDisplayController.searchBar becomeFirstResponder];
}
	
- (void)filterContentForSearchText:(NSString*)searchText
{
	//NSLog(@"filterContentForSearchText: %@",searchText);
	
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
	//NSLog(@"searchDisplayController:shouldReloadTableForSearchString %@",searchString);
	
    [self filterContentForSearchText:searchString];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
	//NSLog(@"searchDisplayController:shouldReloadTableForSearchScope ");
	
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView
{
	self.searchDisplayController.searchResultsTableView.backgroundColor=[UIColor blackColor];
	self.searchDisplayController.searchResultsTableView.separatorColor=[UIColor blackColor];
	self.searchDisplayController.searchResultsTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
}

- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
	searching=YES;
}

- (void) searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller
{
	searching=YES;
}

- (void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
	searching=NO;
}

- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
	searching=NO;
}

- (void) loadVisibleCells
{
	if(searching)
	{
		for(PictureTableViewCell * cell in [self.searchDisplayController.searchResultsTableView visibleCells])
		{
			[cell load];
		}
	}
	else 
	{
		[super loadVisibleCells];
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if([tableView isEqual:self.searchDisplayController.searchResultsTableView])
	{
		return [filteredItems count];
	}
	else {
		return [items count];
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	PictureTableViewCell * cell = [[[PictureTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
	
	cell.selectionStyle=UITableViewCellSelectionStyleNone;
	cell.textLabel.textColor=[UIColor whiteColor];
	
	Friend *friend;
	
	if([tableView isEqual:self.searchDisplayController.searchResultsTableView])
	{
		friend= [filteredItems objectAtIndex:indexPath.row];
	}
	else 
	{
		friend= [items objectAtIndex:indexPath.row];
	}
	
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
	Friend * friend;

	if([tableView isEqual:self.searchDisplayController.searchResultsTableView])
	{
		friend= [filteredItems objectAtIndex:indexPath.row];
	}
	else 
	{
		friend= [items objectAtIndex:indexPath.row];
	}
	
	AlbumsTableViewController * controller=[[AlbumsTableViewController alloc] initWithFeed:friend.albumFeed title:[NSString stringWithFormat:@"%@'s Albums",friend.name]];
	
	[[self navigationController] pushViewController:controller animated:YES];
	
	[controller release];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	if (self.tableView.contentOffset.y <
		self.searchDisplayController.searchBar.frame.size.height)
    {
		self.tableView.contentOffset =
        CGPointMake(0, self.searchDisplayController.searchBar.frame.size.height);
    }
}

- (void)dealloc 
{
	[filteredItems release];
	[searchBar release];
    [super dealloc];
}

@end
