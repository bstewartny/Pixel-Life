#import "FriendListsTableViewController.h"
#import "FriendsTableViewController.h"
#import "FriendList.h"
#import "PictureTableViewCell.h"
#import "Picture.h"
#import "Reachability.h"
@implementation FriendListsTableViewController

- (id)initWithFeed:(Feed*)feed title:(NSString*)title
{
    if(self=[super initWithFeed:feed title:title withNibName:@"FriendListsTableView"])
    {
	
    }
    return self;
}
- (NSString*) noDataMessage
{
	
	Reachability *reachManager = [Reachability reachabilityWithHostName:@"www.facebook.com"];
    NetworkStatus remoteHostStatus = [reachManager currentReachabilityStatus];
    if (remoteHostStatus == NotReachable)
    {
		return @"Facebook is unreachable.";
	}
	else 
	{
		return @"Create lists on Facebook.";
	}
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	PictureTableViewCell * cell = [[[PictureTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
	
	cell.selectionStyle=UITableViewCellSelectionStyleNone;
	cell.textLabel.textColor=[UIColor whiteColor];
	
	FriendList  * list=(FriendList*)[items objectAtIndex:indexPath.row];
	cell.picture=list.picture;
	cell.textLabel.text=list.name;
	
	if([list.picture hasLoadedThumbnail])
	{
		cell.imageView.image=list.picture.thumbnail;
	}
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	FriendList  * list=(FriendList*)[items objectAtIndex:indexPath.row];
	
	FriendsTableViewController * controller=[[FriendsTableViewController alloc] initWithFeed:list.friendFeed title:list.name];
	
	[[self navigationController] pushViewController:controller animated:YES];
	
	[controller release];
}


@end
