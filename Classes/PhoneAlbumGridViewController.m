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
		// push to queue
		ASIHTTPRequest *request = [self createCommentRequest:comment];  
		if(request)
		{
			[request setDelegate:self];
			[request setDidFinishSelector:@selector(sendCommentRequestDone:)];
			[request setDidFailSelector:@selector(sendCommentRequestWentWrong:)];
			NSOperationQueue *queue = [PixelLifeAppDelegate sharedAppDelegate].downloadQueue;
			[queue addOperation:request];
			[request release];
		}
	}
}

- (ASIHTTPRequest*) createCommentRequest:(NSString*)message
{
	FacebookAccount * account=[PixelLifeAppDelegate sharedAppDelegate].currentAccount;
	
	NSString * url=[NSString stringWithFormat:@"https://graph.facebook.com/%@/comments",album.uid];
	
	ASIFormDataRequest * request=[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]];
	
	request.requestMethod=@"POST";
	
	[request addPostValue:account.accessToken forKey:@"access_token"];
	[request addPostValue:message forKey:@"message"];
	
	return request;
}

- (void)sendCommentRequestDone:(ASIHTTPRequest *)request
{
	album.commentCount++;
	showCommentsButton.enabled=(album.commentCount>0);
}

- (void)sendCommentRequestWentWrong:(ASIHTTPRequest *)request
{
	NSError *error = [request error];
	
	UIAlertView * alertView=[[UIAlertView alloc] initWithTitle:@"Error sending comment" message:[error description] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}
- (void) dealloc
{
	[showCommentsButton release];
	[album release];
	[super dealloc];
}
@end
