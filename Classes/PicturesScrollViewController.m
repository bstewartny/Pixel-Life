#import "PicturesScrollViewController.h"
#import "Picture.h"
#import "PictureImageView.h"
#import "FriendPictureImageView.h"
#import "User.h"
#import "FacebookPhotoCommentsFeed.h"
#import "PhotoCommentsViewController.h"
#import "BlankToolbar.h"
#import <QuartzCore/QuartzCore.h>
#import "AddCommentViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "PhotoExplorerAppDelegate.h"
#import "FacebookAccount.h"

//#import "PictureScrollView.h"

@implementation PicturesScrollViewController
@synthesize scrollView, toolbar,pictures,infoFirstNameLabel,infoLastNameLabel,infoNumCommentsLabel,commentCountLabel,infoView,currentItemIndex,infoImageView,infoUserLabel,infoNameLabel,infoDateLabel;

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{ 
	[self dismissModalViewControllerAnimated:YES];
}

- (id)initWithPictures:(NSArray*)pictures
{
    if(self=[super initWithNibName:@"PicturesScrollView" bundle:nil])
	{
		self.pictures=pictures;
		 
		self.view.backgroundColor=[UIColor blackColor];
		
		BlankToolbar * tools=[[BlankToolbar alloc] initWithFrame:CGRectMake(0, 0, 250, 44.01)];
		
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
		
		b=[[UIBarButtonItem	alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
		b.width=10;
		[toolItems addObject:b];
		[b release];
		
		b=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(action:)];
		[toolItems addObject:b];
		[b release];
		
		[tools setItems:toolItems animated:NO];
		
		self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc] initWithCustomView:tools] autorelease];
		
		[tools release];
		
		
		UISwipeGestureRecognizer * swup=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUp:)];
		swup.direction=UISwipeGestureRecognizerDirectionUp;
		[self.infoView addGestureRecognizer:swup];
		
		UISwipeGestureRecognizer * swdwn=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDown:)];
		swdwn.direction=UISwipeGestureRecognizerDirectionDown;
		[self.infoView addGestureRecognizer:swdwn];
		
		
		
		UITapGestureRecognizer * gr2=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
		
		gr2.numberOfTapsRequired=2;
		
		[self.scrollView addGestureRecognizer:gr2];
		
		UITapGestureRecognizer * gr=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
		gr.numberOfTapsRequired=1;
		[gr requireGestureRecognizerToFail:gr2];
		[self.scrollView addGestureRecognizer:gr];
		
		[gr release];
		[gr2 release];
		
		
		
		format = [[NSDateFormatter alloc] init];
		[format setDateFormat:@"MMM d, yyyy"];
		
		picViews=[[NSMutableArray alloc] init];
		
		
		
		
		
		
		
		
		
		
		
		
		
		self.wantsFullScreenLayout=YES;
		
		
		
		
		
		
	}
    return self;
}

- (IBAction) showComments:(id)sender
{
	if(showCommentsPopover)
	{
		return;
	}
	
	cancelRemoveBars=YES;
	
	Picture * picture=[self.pictures objectAtIndex:currentItemIndex];
	
	FacebookAccount * account=[PhotoExplorerAppDelegate sharedAppDelegate].currentAccount;
	
	FacebookPhotoCommentsFeed * feed=[[FacebookPhotoCommentsFeed alloc] initWithFacebookAccount:account  picture:picture];
	
	PhotoCommentsViewController * controller=[[PhotoCommentsViewController alloc] initWithFeed:feed  title:@"Comments"];
	
	[feed release];
	
	showCommentsPopover=[[UIPopoverController alloc] initWithContentViewController:controller];
	
	showCommentsPopover.delegate=self;
	
	[showCommentsPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
	
	[controller release];
}

- (IBAction) addComment:(id)sender
{
	if(addCommentPopover)
	{
		return;
	}
	
	cancelRemoveBars=YES;
	
	AddCommentViewController * controller=[[AddCommentViewController alloc] init];
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
	Picture * picture=[self.pictures objectAtIndex:currentItemIndex];

	FacebookAccount * account=[PhotoExplorerAppDelegate sharedAppDelegate].currentAccount;
	
	NSString * url=[NSString stringWithFormat:@"https://graph.facebook.com/%@/comments",picture.uid];
	
	ASIFormDataRequest * request=[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]];
	
	request.requestMethod=@"POST";
	
	[request addPostValue:account.accessToken forKey:@"access_token"];
	[request addPostValue:message forKey:@"message"];
	request.userInfo=[NSDictionary dictionaryWithObjectsAndKeys:picture,@"picture",nil];
	
	return request;
}

- (void)sendCommentRequestDone:(ASIHTTPRequest *)request
{
	NSLog(@"sendCommentRequestDone");
	
	Picture * picture=[request.userInfo objectForKey:@"picture"];
	
	if(picture)
	{
		picture.commentCount++;
	}
	
	// refresh comments for picture...
	[self updateInfoView];
}

- (void)sendCommentRequestWentWrong:(ASIHTTPRequest *)request
{
	NSError *error = [request error];

	UIAlertView * alertView=[[UIAlertView alloc] initWithTitle:@"Error sending comment" message:[error userInfo] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

- (IBAction) addFavorite:(id)sender
{
	// add photo to users favorite items list
	UIActionSheet * sheet=[[UIActionSheet alloc] initWithTitle:@"I like this photo..." delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Like on Facebook",nil];
	sheet.tag=kLikeActionSheet;
	[sheet showFromBarButtonItem:sender animated:YES];
	
	[sheet release];
}

- (IBAction) action:(id)sender
{
	UIActionSheet * sheet=[[UIActionSheet alloc] initWithTitle:@"Photo Actions" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Email photo",@"Save photo",nil];
	sheet.tag=kActionActionSheet;
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
	Picture * picture=[self.pictures objectAtIndex:currentItemIndex];
	
	FacebookAccount * account=[PhotoExplorerAppDelegate sharedAppDelegate].currentAccount;
	
	NSString * url=[NSString stringWithFormat:@"https://graph.facebook.com/%@/likes",picture.uid];
	
	ASIFormDataRequest * request=[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]];
	
	request.requestMethod=@"POST";
	
	[request addPostValue:account.accessToken forKey:@"access_token"];
	
	return request;
}

- (void)sendLikeRequestDone:(ASIHTTPRequest *)request
{
	NSLog(@"sendCommentRequestDone");
	
	// refresh comments for picture...
}

- (void)sendLikeRequestWentWrong:(ASIHTTPRequest *)request
{
	NSError *error = [request error];
	
	UIAlertView * alertView=[[UIAlertView alloc] initWithTitle:@"Error liking photo" message:[error userInfo] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(actionSheet.tag==kLikeActionSheet)
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
	if(actionSheet.tag==kActionActionSheet)
	{
		if(buttonIndex==0)
		{
			// email photo
			if ([MFMailComposeViewController canSendMail]) 
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
			} 
		}
		if(buttonIndex==1)
		{
			// add to local library
			Picture * picture=[self.pictures objectAtIndex:currentItemIndex];
			
			if([picture hasLoadedImage])
			{
				UIImage * image=picture.image;
				if(image!=nil)
				{
					UIImageWriteToSavedPhotosAlbum(image,nil,nil,nil);
				}
			}
		}
	}
}
- (void) swipeUp:(UIGestureRecognizer*)gr
{
	if(self.infoView.frame.size.height==192)
	{
		[UIView beginAnimations:@"swipeup" context:nil];
		self.infoView.frame=CGRectMake(0, self.infoView.frame.origin.y-100, self.infoView.frame.size.width, self.infoView.frame.size.height+100);
		[UIView commitAnimations];
	}
}

- (void) swipeDown:(UIGestureRecognizer*)gr
{
	if(self.infoView.frame.size.height > 192)
	{
		[UIView beginAnimations:@"swipeup" context:nil];
		self.infoView.frame=CGRectMake(0, self.infoView.frame.origin.y+100, self.infoView.frame.size.width, self.infoView.frame.size.height-100);
		[UIView commitAnimations];
	}
	else 
	{
		[self toggleNavigationBar];
	}
}

- (void) singleTap:(UIGestureRecognizer*)gr
{
	[self toggleNavigationBar];
}

- (void) doubleTap:(UIGestureRecognizer*)gr
{
	[self toggleZoom];
}

- (void) toggleZoom
{
	PictureImageView * picView=[picViews objectAtIndex:currentItemIndex];
	//[UIView beginAnimations:@"zoom" context:nil];
	//[UIView setAnimationDuration:3.0];
	 
	
	if(picView.contentMode==UIViewContentModeScaleAspectFit)
	{
		picView.contentMode=UIViewContentModeScaleAspectFill;
	}
	else 
	{
		picView.contentMode=UIViewContentModeScaleAspectFit;
	}
	//[UIView commitAnimations];
}

- (CGRect) getBounds
{
	CGRect b= scrollView.bounds;
	
	if(b.size.width==1024 && b.size.height==704)
	{
		//b.size.height=748;
		b.size.height=768;
		
	}
	if (b.size.width==768 && b.size.height==960) {
		//b.size.height=1004;
		b.size.height=1024;
	}
	return b;
}

-(void) addPicturesToScrollView
{
	CGFloat left=0;
	CGFloat top=0;
	
	CGRect frame=[self getBounds];
	
	CGFloat width=frame.size.width;
	CGFloat height=frame.size.height;
	
	[picViews removeAllObjects];
	
	for(Picture * picture in pictures)
	{
		CGFloat x=left;
		CGFloat y=top;
		
		CGRect frame=CGRectMake(x,y,width,height);
		
		PictureImageView * picView=[[PictureImageView alloc] initWithFrame:frame picture:picture];
		
		[scrollView addSubview:picView];
		
		[picViews addObject:picView];
		
		[picView release];
		
		left+=width;
	}
	[scrollView setContentSize:CGSizeMake([pictures count]*width, height)];
}

- (void) setPictureFrames
{
	CGFloat left=0;
	CGFloat top=0;
	
	CGRect frame=[self getBounds];
	
	CGFloat width=frame.size.width;
	CGFloat height=frame.size.height;
	
	for(UIView * picView in picViews)
	{
		CGFloat x=left;
		CGFloat y=top;
		
		CGRect frame=CGRectMake(x,y,width,height);
		picView.frame=frame;
		[picView setNeedsDisplay];
		
		left+=width;
	}
	[scrollView setContentSize:CGSizeMake([pictures count]*width, height)];
	[scrollView setNeedsDisplay];
}
 
- (void)viewDidLoad 
{
    [super viewDidLoad];
	scrollView.backgroundColor=[UIColor blackColor];
}

- (void)toggleNavigationBar 
{
	BOOL statusBarHidden=[[UIApplication sharedApplication] isStatusBarHidden];
	
	if(statusBarHidden)
	{
		[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
		[self.navigationController setNavigationBarHidden:NO animated:NO];
	}
	
	/*CGRect rect = self.navigationController.navigationBar.frame;
    rect.origin.y = rect.origin.y < 0 ?
		rect.origin.y + rect.size.height
		:	rect.origin.y - rect.size.height;
	*/
	CGRect rect2=infoView.frame;
		rect2.origin.y= rect2.origin.y>=self.view.frame.size.height ?
			self.view.frame.size.height-rect2.size.height :
			self.view.frame.size.height;
	
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:UINavigationControllerHideShowBarDuration];
	
	//self.navigationController.navigationBar.frame = rect;
    
	infoView.frame=rect2;
	
	[UIView commitAnimations];
	
	if(!statusBarHidden)
	{
		[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    	[self.navigationController setNavigationBarHidden:YES animated:YES];
	}
	
	[self.navigationController.view setNeedsLayout];
}

-(void)toggleNavigationBarWithTimer:(NSTimer*)theTimer { 
	if (cancelRemoveBars) return;
	[self performSelectorOnMainThread:@selector(toggleNavigationBar) withObject:nil waitUntilDone:NO];
}

- (void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	if(!cancelRemoveBars)
	{
		NSTimer * myTimer = [NSTimer scheduledTimerWithTimeInterval:6.0 target:self selector:@selector(toggleNavigationBarWithTimer:) userInfo:nil repeats:NO];
	}
}

- (void) viewWillDisappear:(BOOL)animated
{
	self.navigationController.navigationBar.translucent=NO;
	[self.navigationController setNavigationBarHidden:NO animated:NO];
	[[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleBlackOpaque animated:NO];
	[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
	[super viewWillDisappear:animated];
}

- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	self.navigationController.navigationBar.translucent=YES;
	[[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleBlackTranslucent animated:NO];
	[self addPicturesToScrollView];
	[self goToCurrentItem];
	[self loadVisiblePictures]; 
}

- (void) goToCurrentItem
{
	scrollView.contentOffset=CGPointMake(currentItemIndex * scrollView.bounds.size.width, 0);
	self.navigationItem.title=[NSString stringWithFormat:@"%d of %d",currentItemIndex+1,[pictures count]];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	[self loadVisiblePictures]; 
}

- (void) loadVisiblePictures
{
	UIView * prev=nil;
	BOOL prevLoaded=NO;
	int i=0;
	
	BOOL unloadImages=NO;
	
	if([scrollView.subviews count] > 20)
	{
		unloadImages=YES;
	}
	
	for(UIView * picView in picViews)
	{
		if(CGRectIntersectsRect(picView.frame, scrollView.bounds))
		{
			NSLog(@"Found intersection rect...setting currentItemIndex=%d");
			currentItemIndex=i;
			[picView load];
		}
		
		i++;
	}
	
	int prevItemIndex=-1;
	// also preload prev and next images
	if(currentItemIndex>0)
	{
		prevItemIndex=currentItemIndex-1;
		[[picViews objectAtIndex:prevItemIndex] load];
	}
	int nextItemindex=-1;
	if(currentItemIndex < ([pictures count]-1))
	{
		nextItemindex=currentItemIndex+1;
		[[picViews objectAtIndex:nextItemindex] load];
	}
	if(unloadImages)
	{
		i=0;
		for(UIView * picView in picViews)
		{
			if(prevItemIndex>-1)
			{
				if(i<prevItemIndex)
				{
					[picView unload];
				}
			}
			if(nextItemindex>-1)
			{
				if (i>nextItemindex) 
				{
					[picView unload];
				}
			}
			i++;
		}
	}

	self.navigationItem.title=[NSString stringWithFormat:@"%d of %d",currentItemIndex+1,[pictures count]];
	
	// show info view...
	[self updateInfoView];
}

- (void) updateInfoView
{
	NSLog(@"updateInfoView: currentItemIndex=%d",currentItemIndex );
		  
	Picture * currentPicture=[pictures objectAtIndex:currentItemIndex];
	
	NSLog(@"updateInfoView: %@",currentPicture.name);
	
	infoNameLabel.text=currentPicture.name;//[currentPicture.name stringByAppendingFormat:@"\n\n\n\n\n\n\n\n\n\n"];
	
	infoDateLabel.text=[format stringFromDate:currentPicture.created_date];
	
	if(currentPicture.commentCount>0)
	{
		if(currentPicture.commentCount==1)
		{
			infoNumCommentsLabel.text=@"1 comment";
		}
		else 
		{
			infoNumCommentsLabel.text=[NSString stringWithFormat:@"%d comments",currentPicture.commentCount];
		}
	}
	else 
	{	
		infoNumCommentsLabel.text=@"";
	}
/*	
	if(currentPicture.commentCount>0)
	{
		if(currentPicture.commentCount==1)
		{
			infoUserLabel.text=[NSString stringWithFormat:@"by %@ on %@ - 1 comment",currentPicture.user.name,[format stringFromDate:currentPicture.created_date]];
		}
		else 
		{
			infoUserLabel.text=[NSString stringWithFormat:@"by %@ on %@ - %d comments",currentPicture.user.name,[format stringFromDate:currentPicture.created_date],currentPicture.commentCount];
		}
	}
	else 
	{		
		infoUserLabel.text=[NSString stringWithFormat:@"by %@ on %@",currentPicture.user.name,[format stringFromDate:currentPicture.created_date]];
	}
*/
	
	infoImageView.user=currentPicture.user;
	[infoImageView load];
	/*
	infoImageView.picture=[currentPicture.user picture];
	[infoImageView load];
	*/
	if (currentPicture.commentCount>0) 
	{
		showCommentsButton.enabled=YES;
	}
	else 
	{
		showCommentsButton.enabled=NO;
	}
}

- (void) showInfoView
{
	CGRect rect2=infoView.frame;
	rect2.origin.y= self.view.frame.size.height-rect2.size.height;	
	self.infoView.frame=rect2;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	self.scrollView.hidden=YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	[self setPictureFrames];
	[self goToCurrentItem];
	[self loadVisiblePictures];
	self.scrollView.hidden=NO;
	// show info view again because navigation bar will re-show if it was hidden...
	//[self showInfoView];
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

- (void)dealloc 
{
	[pictures release];
	[toolbar release];
	[scrollView release];
	[infoImageView release];
	[infoUserLabel release];
	[infoNameLabel release];
	[infoDateLabel release];
	[picViews release];
	[format release];
	[commentCountLabel release];
	[showCommentsPopover release];
	showCommentsPopover=nil;
	[addCommentPopover release];
	addCommentPopover=nil;
	[infoView release];
	[infoFirstNameLabel release];
	[infoLastNameLabel release];
	[infoNumCommentsLabel release];
	
    [super dealloc];
}

@end
