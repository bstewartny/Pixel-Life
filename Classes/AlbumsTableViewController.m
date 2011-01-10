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

- (id)initWithFeed:(Feed*)feed title:(NSString*)title
{
    if(self=[super initWithFeed:feed title:title withNibName:@"AlbumsTableView"])
    {
	
    }
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	PictureTableViewCell * cell = [[[PictureTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil] autorelease];
	
	cell.selectionStyle=UITableViewCellSelectionStyleNone;
	cell.textLabel.textColor=[UIColor whiteColor];
	cell.detailTextLabel.textColor=[UIColor lightGrayColor];
	
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	Album *album=[items objectAtIndex:indexPath.row];
	// need to dismiss search results popover now...
	PhoneAlbumGridViewController * albumController=[[PhoneAlbumGridViewController alloc] initWithAlbum:album];
	
	[[self navigationController] pushViewController:albumController animated:YES];
	
	[albumController release];
}
 

@end
