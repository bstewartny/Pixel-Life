#import "PhoneAlbumGridViewController.h"
#import "Album.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "PixelLifeAppDelegate.h"
#import "FacebookAlbumCommentsFeed.h"
#import "FacebookAccount.h"
#import "PicturesScrollViewController.h"
#import "PictureGridViewCell.h"
#import "PhotoCommentsViewController.h"
#import "PhoneAddCommentViewController.h"

@implementation PhoneAlbumGridViewController
@synthesize album,showCommentsButton;

- (id) initWithAlbum:(Album*)album
{
	if(self=[super initWithFeed:album.pictureFeed title:album.name withNibName:@"PhoneAlbumGridView"])
	{
		self.gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		self.gridView.autoresizesSubviews = YES;
		self.gridView.delegate = self;
		self.gridView.dataSource = self;
		self.gridView.separatorStyle = AQGridViewCellSeparatorStyleEmptySpace;
		self.gridView.separatorColor = [UIColor blackColor];
		self.gridView.backgroundColor=[UIColor blackColor];
		
		self.album=album;
    }
    return self;
}

- (IBAction) showComments:(id)sender
{
	FacebookAccount * account=[PixelLifeAppDelegate sharedAppDelegate].currentAccount;
	
	FacebookAlbumCommentsFeed * feed=[[FacebookAlbumCommentsFeed alloc] initWithFacebookAccount:account  album:album];
	
	PhotoCommentsViewController * controller=[[PhotoCommentsViewController alloc] initWithFeed:feed  title:@"Comments" phoneMode:YES];
	controller.delegate=self;
	[feed release];
	
	controller.modalPresentationStyle=UIModalPresentationFullScreen;
	
	[self presentModalViewController:controller animated:YES];
	
	[controller release];
}

- (CGSize) portraitGridCellSizeForGridView: (AQGridView *) aGridView
{
    return ( CGSizeMake(76.0, 80.0) );
}

- (void) addFavorite:(id)sender
{
	// add photo to users favorite items list
	UIActionSheet * sheet=[[UIActionSheet alloc] initWithTitle:@"I like this album..." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Like on Facebook",nil];
	[sheet showFromBarButtonItem:sender animated:YES];
	
	[sheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex==0)
	{
		// like on facebook
		[self likeAlbum];
	}
 }

- (void) likeAlbum
{
	[[PixelLifeAppDelegate sharedAppDelegate] likeGraphObject:album.uid];	
}

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
	
	Picture * picture=(Picture*)[items objectAtIndex:index];
	
	photoCell.picture=picture;
	
	return photoCell;
}

- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	showCommentsButton.enabled=(album.commentCount>0);
}

- (void) gridView: (AQGridView *) gridView didSelectItemAtIndex: (NSUInteger) index
{
	if(index<0 || index>([items count]-1))
	{
		// some bug in grid view allows bogus selections sometimes...
		return;
	}
	PicturesScrollViewController * controller=[[PicturesScrollViewController alloc] initWithPictures:items phoneMode:YES];
	
	controller.currentItemIndex=index;
	
	[[self navigationController] pushViewController:controller animated:YES];
	
	[controller release];
}

- (IBAction) addComment:(id)sender
{
	PhoneAddCommentViewController * controller=[[PhoneAddCommentViewController alloc] init];
	controller.delegate=self;
	controller.modalPresentationStyle=UIModalPresentationFullScreen;

	[self presentModalViewController:controller animated:YES];

	[controller release];
}

- (void) sendComment:(NSString*)comment
{
	[self dismissModalViewControllerAnimated:YES];
	
	if([comment length]>0)
	{
		[[PixelLifeAppDelegate sharedAppDelegate] sendComment:comment uid:album.uid];
		album.commentCount++;
		showCommentsButton.enabled=(album.commentCount>0);
	}
}

- (void) dealloc
{
	[showCommentsButton release];
	[album release];
	[super dealloc];
}
@end
