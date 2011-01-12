#import "AlbumGridViewController.h"
#import "Album.h"
#import "BlankToolbar.h"
#import "PhotoCommentsViewController.h"
#import "BlankToolbar.h"
#import "AddCommentViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "PixelLifeAppDelegate.h"
#import "FacebookAlbumCommentsFeed.h"
#import "FacebookAccount.h"
#import "PicturesScrollViewController.h"

@implementation AlbumGridViewController
@synthesize album;

- (id) initWithAlbum:(Album*)album
{
	if(self=[super initWithFeed:album.pictureFeed title:album.name])
	{
		self.album=album;
	}
	return self;
}

- (void) viewDidLoad
{
	[super viewDidLoad];
	
	BlankToolbar * tools=[[BlankToolbar alloc] initWithFrame:CGRectMake(0, 0, 220, 44.01)];
	
	tools.backgroundColor=[UIColor clearColor];
	tools.opaque=NO;
	
	NSMutableArray * toolItems=[[NSMutableArray alloc] init];
	
	UIBarButtonItem * b;
	
	b=[[UIBarButtonItem	alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	[toolItems addObject:b];
	[b release];
	
	b=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_post.png"] style:UIBarButtonItemStylePlain target:self action:@selector(showComments:)];
	[toolItems addObject:b];
	showCommentsButton=b;
	b.enabled=NO;
	[b release];
	
	b=[[UIBarButtonItem	alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	b.width=10;
	[toolItems addObject:b];
	[b release];
	
	b=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_comment_add.png"] style:UIBarButtonItemStylePlain target:self action:@selector(addComment:)];
	[toolItems addObject:b];
	[b release];
	
	b=[[UIBarButtonItem	alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	b.width=10;
	[toolItems addObject:b];
	[b release];
	
	b=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_favorities_add.png"] style:UIBarButtonItemStylePlain target:self action:@selector(addFavorite:)];
	[toolItems addObject:b];
	[b release];
	
	[tools setItems:toolItems animated:NO];
	
	self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc] initWithCustomView:tools] autorelease];
	
	[tools release];
	[toolItems release];
	
}

- (void) slideshow:(id)sender
{
	UIActionSheet * sheet=[[UIActionSheet alloc] initWithTitle:@"Slideshow" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Start Slideshow",nil];
	sheet.tag=kAlbumSlideshowActionSheet;
	[sheet showFromBarButtonItem:sender animated:YES];
	
	[sheet release];
}

- (void) action:(id)sender
{
	UIActionSheet * sheet=[[UIActionSheet alloc] initWithTitle:@"Album Actions" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Email photos",@"Save photos",nil];
	sheet.tag=kAlbumActionActionSheet;
	[sheet showFromBarButtonItem:sender animated:YES];
	
	[sheet release];
}

- (void) likeAlbum
{
	[[PixelLifeAppDelegate sharedAppDelegate] likeGraphObject:album.uid];	
}

- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	showCommentsButton.enabled=(album.commentCount>0);
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(actionSheet.tag==kAlbumLikeActionSheet)
	{
		if(buttonIndex==0)
		{
			// like on facebook
			[self likeAlbum];
		}
	}
}

- (void) showComments:(id)sender
{
	if(showCommentsPopover)
	{
		return;
	}
	
	FacebookAccount * account=[PixelLifeAppDelegate sharedAppDelegate].currentAccount;
	
	FacebookAlbumCommentsFeed * feed=[[FacebookAlbumCommentsFeed alloc] initWithFacebookAccount:account  album:album];
	
	PhotoCommentsViewController * controller=[[PhotoCommentsViewController alloc] initWithFeed:feed  title:@"Album Comments" phoneMode:NO];
	
	[feed release];
	
	showCommentsPopover=[[UIPopoverController alloc] initWithContentViewController:controller];
	
	showCommentsPopover.delegate=self;
	
	[showCommentsPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
	
	[controller release];

}

- (void) addComment:(id)sender
{
	if(addCommentPopover)
	{
		return;
	}
	
	AddCommentViewController * controller=[[AddCommentViewController alloc] init] ;//]WithPicture:picture];
	controller.delegate=self;
	
	addCommentPopover=[[UIPopoverController alloc] initWithContentViewController:controller];
	addCommentPopover.delegate=self;
	
	[addCommentPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
	
	[controller release];
}

- (void) sendComment:(NSString*)comment
{
	[addCommentPopover dismissPopoverAnimated:YES];
	
	if([comment length]>0)
	{
		[[PixelLifeAppDelegate sharedAppDelegate] sendComment:comment uid:album.uid];
		album.commentCount++;
		showCommentsButton.enabled=(album.commentCount>0);
	}
}

- (void) addFavorite:(id)sender
{
	// add photo to users favorite items list
	UIActionSheet * sheet=[[UIActionSheet alloc] initWithTitle:@"I like this album..." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Like on Facebook",nil];
	sheet.tag=kAlbumLikeActionSheet;
	[sheet showFromBarButtonItem:sender animated:YES];
	
	[sheet release];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
	if(popoverController==showCommentsPopover)
	{
		[showCommentsPopover release];
		showCommentsPopover=nil;
	}
	else 
	{
		if(popoverController==addCommentPopover)
		{
			[addCommentPopover release];
			addCommentPopover=nil;
		}
	}
}

- (void) dealloc
{
	[album release];
	[showCommentsPopover release];
	showCommentsPopover=nil;
	[addCommentPopover release];
	addCommentPopover=nil;
	[super dealloc];
}
@end
