#import "PhoneFriendsGridViewController.h"
#import "PictureGridViewCell.h"
#import "Friend.h"
#import "Picture.h"
#import "AlbumsTableViewController.h"
#import "PictureTableViewCell.h"
#import "FriendSearchResultTableViewCell.h"

@implementation PhoneFriendsGridViewController
@synthesize tabBar;

- (AQGridViewCell *) gridView: (AQGridView *) aGridView cellForItemAtIndex: (NSUInteger) index
{
    static NSString * cellIdentifier = @"CellIdentifier";
	
    PictureGridViewCell * photoCell = (PictureGridViewCell *)[aGridView dequeueReusableCellWithIdentifier: cellIdentifier];
	if ( photoCell == nil )
	{
		photoCell = [[[PictureGridViewCell alloc] initWithFrame: CGRectMake(0.0, 0.0, 76.0, 76.0)
												reuseIdentifier: cellIdentifier] autorelease];
		photoCell.selectionStyle = AQGridViewCellSelectionStyleBlueGray;
	}
	
	Friend  * friend=(Friend*)[items objectAtIndex:index];
	photoCell.picture=friend.picture;
	 
	return photoCell;
}
 
- (CGSize) portraitGridCellSizeForGridView: (AQGridView *) aGridView
{
    return ( CGSizeMake(76.0, 80.0) );
}

- (void) showFriendAlbums:(Friend*)friend
{
	AlbumsTableViewController * controller=[[AlbumsTableViewController alloc] initWithFeed:friend.albumFeed title:[NSString stringWithFormat:@"%@'s Albums",friend.name]];
	
	[[self navigationController] pushViewController:controller animated:YES];
	
	[controller release];
}

- (void) setupSearchController
{
	searchBar=[[UISearchBar alloc] initWithFrame:CGRectMake(0,-44,self.view.bounds.size.width,44)];
	searchBar.autoresizingMask=UIViewAutoresizingFlexibleWidth;
	searchBar.backgroundColor=[UIColor clearColor];
	searchBar.opaque=NO;
	searchBar.barStyle=UIBarStyleBlack;
	
	[self.view addSubview:searchBar];
	
	searchController=[[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
	searchController.delegate=self;
	searchController.searchResultsDelegate=self;
	searchController.searchResultsDataSource=self;
	searchController.searchResultsTableView.backgroundColor=[UIColor blackColor];
	searchController.searchResultsTableView.separatorColor=[UIColor blackColor];
	searchController.searchResultsTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
														
	filteredItems=[[NSMutableArray alloc] init];
		
	self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(search:)] autorelease];
}

- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
	[UIView beginAnimations:nil context:NULL];
	CGRect f=searchBar.frame;
	f.origin.y=-44;
	searchBar.frame=f;
	[UIView commitAnimations];
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView
{
	searchController.searchResultsTableView.backgroundColor=[UIColor blackColor];
	searchController.searchResultsTableView.separatorColor=[UIColor blackColor];
	searchController.searchResultsTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
}

- (void) search:(id)sender
{
	[UIView beginAnimations:nil context:NULL];
	CGRect f=searchBar.frame;
	f.origin.y=0;
	searchBar.frame=f;
	[UIView commitAnimations];

	[searchController.searchBar becomeFirstResponder];
}

- (void) layoutSubviews
{
	CGRect f=searchBar.frame;
	f.origin.y=-44;
	searchBar.frame=f;
	CGRect s=[[UIScreen mainScreen] bounds];
	//tabBar.frame=CGRectMake(0, (s.size.height-tabBar.frame.size.height)-20, s.size.width, tabBar.frame.size.height);
	
}

- (void) setTabBar:(UITabBar*)t
{
	if(![t isEqual:tabBar])
	{
		BOOL needsTableFrameAdjusted=(tabBar==nil);
		
		[tabBar removeFromSuperview];
		[tabBar release];
		tabBar=[t retain];
		
		CGRect s=[[UIScreen mainScreen] bounds];
		
		if(needsTableFrameAdjusted)
		{
			CGRect t=gridView.frame;
			t.size.height=t.size.height-tabBar.frame.size.height;
			gridView.frame=t;
		}
		
		tabBar.frame=CGRectMake(0, (s.size.height-tabBar.frame.size.height)-20, s.size.width, tabBar.frame.size.height);
		
		NSLog(@"tabBar frame=%@",NSStringFromCGRect(tabBar.frame));
		NSLog(@"self.view frame=%@",NSStringFromCGRect(self.view.frame));
		
		[self.view addSubview:tabBar];
	}
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	[cell load];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	FriendSearchResultTableViewCell * cell = [[[FriendSearchResultTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
	
	cell.selectionStyle=UITableViewCellSelectionStyleNone;
	cell.textLabel.textColor=[UIColor whiteColor];
	
	Friend *friend;
	
	if([tableView isEqual:self.searchDisplayController.searchResultsTableView])
	{
		friend= [filteredItems objectAtIndex:indexPath.row];
	}
	else 
	{
		return nil;
		//friend= [items objectAtIndex:indexPath.row];
	}
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
	[tabBar release];
	[super dealloc];
}

@end
