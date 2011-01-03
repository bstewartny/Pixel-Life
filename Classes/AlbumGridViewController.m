#import "AlbumGridViewController.h"
#import "Album.h"
#import "BlankToolbar.h"
#import "PhotoCommentsViewController.h"
#import "BlankToolbar.h"
#import "AddCommentViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "PhotoExplorerAppDelegate.h"
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
	/*
	b=[[UIBarButtonItem	alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	b.width=10;
	[toolItems addObject:b];
	[b release];
	
	b=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_frame.png"] style:UIBarButtonItemStylePlain target:self action:@selector(slideshow:)];
	[toolItems addObject:b];
	[b release];
	*/
	
	
	/*b=[[UIBarButtonItem	alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	b.width=10;
	[toolItems addObject:b];
	[b release];
	
	b=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(action:)];
	[toolItems addObject:b];
	[b release];
	*/
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
	UIActionSheet * sheet=[[UIActionSheet alloc] initWithTitle:@"Album Actions" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Email photos",@"Save photos",nil];
	sheet.tag=kAlbumActionActionSheet;
	[sheet showFromBarButtonItem:sender animated:YES];
	
	[sheet release];
}

- (void) likePhoto
{
	// push to queue
	ASIHTTPRequest *request = [self createLikeRequest];  
	if(request)
	{
		[request setDelegate:self];
		[request setDidFinishSelector:@selector(sendLikeRequestDone:)];
		[request setDidFailSelector:@selector(sendLikeRequestWentWrong:)];
		NSOperationQueue *queue = [PhotoExplorerAppDelegate sharedAppDelegate].downloadQueue;
		[queue addOperation:request];
		[request release];
	}	
}

- (ASIHTTPRequest*) createLikeRequest
{
	FacebookAccount * account=[PhotoExplorerAppDelegate sharedAppDelegate].currentAccount;
	
	NSString * url=[NSString stringWithFormat:@"https://graph.facebook.com/%@/likes",album.uid];
	
	ASIFormDataRequest * request=[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]];
	
	request.requestMethod=@"POST";
	
	[request addPostValue:account.accessToken forKey:@"access_token"];
	
	return request;
}

- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	showCommentsButton.enabled=(album.commentCount>0);
}

- (void)sendLikeRequestDone:(ASIHTTPRequest *)request
{
	NSLog(@"sendCommentRequestDone");
	
	// refresh comments for picture...
}

- (void)sendLikeRequestWentWrong:(ASIHTTPRequest *)request
{
	NSError *error = [request error];
	
	UIAlertView * alertView=[[UIAlertView alloc] initWithTitle:@"Error liking photo" message:[error description] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}
/*
- (void) startSlideshow
{
	if([items count]>0)
	{
		PicturesScrollViewController * controller=[[PicturesScrollViewController alloc] initWithPictures:items];
		
		controller.currentItemIndex=0;
		controller.slideshowMode=YES;
		
		[[self navigationController] pushViewController:controller animated:YES];
		
		//[controller startSlideshow];
		
		[controller release];
	}
}
*/
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(actionSheet.tag==kAlbumSlideshowActionSheet)
	{
		if (buttonIndex==0) {
			// start slideshow...
			[self startSlideshow];
		}
	}
	if(actionSheet.tag==kAlbumLikeActionSheet)
	{
		if(buttonIndex==0)
		{
			// like on facebook
			[self likePhoto];
		}
		/*if(buttonIndex==1)
		 {
		 // add to local favorites
		 }*/
	}
	if(actionSheet.tag==kAlbumActionActionSheet)
	{
		if(buttonIndex==0)
		{
			// email photo
			/*if ([MFMailComposeViewController canSendMail]) 
			{
				Picture * picture=[self.pictures objectAtIndex:currentItemIndex];
				
				if([picture hasLoadedImage])
				{
					UIImage * image=picture.image;
					if(image!=nil)
					{
						// create mail composer object
						MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
						
						// make this view the delegate
						mailer.mailComposeDelegate = self;
						
						NSData *myData = UIImageJPEGRepresentation(image, 1.0);
						
						[mailer addAttachmentData:myData mimeType:@"image/png" fileName:@"image.png"];
						
						
						[mailer setMessageBody:@"" isHTML:YES];
						
						// present user with composer screen
						[self presentModalViewController:mailer animated:YES];
						
						// release composer object
						[mailer release];
					}
				}
			} */
		}
		if(buttonIndex==1)
		{
			// add to local library
			/*Picture * picture=[self.pictures objectAtIndex:currentItemIndex];
			
			if([picture hasLoadedImage])
			{
				UIImage * image=picture.image;
				if(image!=nil)
				{
					UIImageWriteToSavedPhotosAlbum(image,nil,nil,nil);
				}
			}*/
		}
	}
}

- (void) showComments:(id)sender
{
	if(showCommentsPopover)
	{
		return;
	}
	
	FacebookAccount * account=[PhotoExplorerAppDelegate sharedAppDelegate].currentAccount;
	
	FacebookAlbumCommentsFeed * feed=[[FacebookAlbumCommentsFeed alloc] initWithFacebookAccount:account  album:album];
	
	PhotoCommentsViewController * controller=[[PhotoCommentsViewController alloc] initWithFeed:feed  title:@"Album Comments"];
	
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
	
	//cancelRemoveBars=YES;
	
	//Picture * picture=[self.pictures objectAtIndex:currentItemIndex];
	
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
		// push to queue
		ASIHTTPRequest *request = [self createCommentRequest:comment];  
		if(request)
		{
			[request setDelegate:self];
			[request setDidFinishSelector:@selector(sendCommentRequestDone:)];
			[request setDidFailSelector:@selector(sendCommentRequestWentWrong:)];
			NSOperationQueue *queue = [PhotoExplorerAppDelegate sharedAppDelegate].downloadQueue;
			[queue addOperation:request];
			[request release];
		}
	}
}
- (ASIHTTPRequest*) createCommentRequest:(NSString*)message
{
	FacebookAccount * account=[PhotoExplorerAppDelegate sharedAppDelegate].currentAccount;
	
	NSString * url=[NSString stringWithFormat:@"https://graph.facebook.com/%@/comments",album.uid];
	
	ASIFormDataRequest * request=[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]];
	
	request.requestMethod=@"POST";
	
	[request addPostValue:account.accessToken forKey:@"access_token"];
	[request addPostValue:message forKey:@"message"];
	//request.userInfo=[NSDictionary dictionaryWithObjectsAndKeys:picture,@"picture",nil];
	
	return request;
}

- (void)sendCommentRequestDone:(ASIHTTPRequest *)request
{
	NSLog(@"sendCommentRequestDone");
	
	album.commentCount++;
	
	showCommentsButton.enabled=YES;
}

- (void)sendCommentRequestWentWrong:(ASIHTTPRequest *)request
{
	NSError *error = [request error];
	
	UIAlertView * alertView=[[UIAlertView alloc] initWithTitle:@"Error sending comment" message:[error description] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

- (void) addFavorite:(id)sender
{
	// add photo to users favorite items list
	UIActionSheet * sheet=[[UIActionSheet alloc] initWithTitle:@"I like this album..." delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Like on Facebook",nil];
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
