#import "PicturesScrollViewController.h"
#import "Picture.h"
#import "PictureImageView.h"
#import "PictureImageScrollView.h"
#import "FriendPictureImageView.h"
#import "User.h"
#import "FacebookPhotoCommentsFeed.h"
#import "PhotoCommentsViewController.h"
#import "BlankToolbar.h"
#import <QuartzCore/QuartzCore.h>
#import "AddCommentViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "PixelLifeAppDelegate.h"
#import "FacebookAccount.h"
#import "SlideshowOptionsViewController.h"
#import "PhoneAddCommentViewController.h"
#import "Comment.h"
#import "Friend.h"
#define PADDING  10

@implementation PicturesScrollViewController
@synthesize showCommentsButton,scrollView, toolbar,pictures,infoFirstNameLabel,infoLastNameLabel,infoNumCommentsLabel,commentCountLabel,infoView,currentItemIndex,infoImageView,infoUserLabel,infoNameLabel,infoDateLabel;
@synthesize slideshowMode;

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{ 
	[self dismissModalViewControllerAnimated:YES];
}

- (id)initWithPictures:(NSArray*)thePictures phoneMode:(BOOL)mode
{
	phoneMode=mode;
	self.pictures=thePictures;
	
	
	if(phoneMode)
	{
		self=[super initWithNibName:@"PhonePicturesScrollView" bundle:nil];
	}
	else 
	{
		self=[super initWithNibName:@"PicturesScrollView" bundle:nil];
	}

    if(self)
	{
		self.view.backgroundColor=[UIColor blackColor];
		
		CGRect f=self.scrollView.frame;
		
		f.origin.x-=PADDING;
		f.size.width+=(2*PADDING);
		
		self.scrollView.frame=f;
		
		if(phoneMode)
		{
			[infoView removeFromSuperview];
			[infoView release];
			infoView=nil;
		}
		
		if(!phoneMode)
		{
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
			self.showCommentsButton=b;
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
			
			b=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_frame.png"] style:UIBarButtonItemStylePlain target:self action:@selector(showSlideshowOptions:)];
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
			[toolItems release];
			
			UISwipeGestureRecognizer * swup=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUp:)];
			swup.direction=UISwipeGestureRecognizerDirectionUp;
			[self.infoView addGestureRecognizer:swup];
			[swup release];
			
			UISwipeGestureRecognizer * swdwn=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDown:)];
			swdwn.direction=UISwipeGestureRecognizerDirectionDown;
			[self.infoView addGestureRecognizer:swdwn];
			[swdwn release];
		}
		
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

- (void) showSlideshowOptions:(id)sender
{
	if(slideshowOptionsPopover)
	{
		return;
	}
	
	cancelRemoveBars=YES;
	
	SlideshowOptionsViewController * controller=[[SlideshowOptionsViewController alloc] init];
	
	controller.sortOrder=sortOrder;
	controller.fillScreen=fillScreen;
	controller.delaySeconds=delaySeconds;
	
	controller.delegate=self;
	UINavigationController * nav=[[UINavigationController alloc] initWithRootViewController:controller];
	
	slideshowOptionsPopover=[[UIPopoverController alloc] initWithContentViewController:nav];
	
	slideshowOptionsPopover.delegate=self;
	
	[slideshowOptionsPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
	
	[nav release];
	[controller release];
}



- (void) showCommentsPhone:(id)sender
{
	Picture * picture=[self.pictures objectAtIndex:currentItemIndex];
	
	FacebookAccount * account=[PixelLifeAppDelegate sharedAppDelegate].currentAccount;
	
	FacebookPhotoCommentsFeed * feed=[[FacebookPhotoCommentsFeed alloc] initWithFacebookAccount:account  picture:picture];
	
	PhotoCommentsViewController * controller=[[PhotoCommentsViewController alloc] initWithFeed:feed  title:@"Comments" phoneMode:phoneMode];
	controller.delegate=self;
	
	if([picture.name length]>0)
	{
		Comment * pictureComment=[[Comment alloc] init];
		pictureComment.message=picture.name;
		pictureComment.picture=[[picture user] picture];
		pictureComment.user=[picture user];
		pictureComment.created_date=[picture created_date];
		pictureComment.updated_date=[picture updated_date];
		controller.pictureComment=pictureComment;
		
		[pictureComment release];
	}
	
	[feed release];
	controller.modalPresentationStyle=UIModalPresentationFullScreen;
	
	[self presentModalViewController:controller animated:YES];

	[controller release];
}

- (void) showCommentsPad:(id)sender
{
	if(showCommentsPopover)
	{
		return;
	}
	
	cancelRemoveBars=YES;
	
	Picture * picture=[self.pictures objectAtIndex:currentItemIndex];
	
	FacebookAccount * account=[PixelLifeAppDelegate sharedAppDelegate].currentAccount;
	
	FacebookPhotoCommentsFeed * feed=[[FacebookPhotoCommentsFeed alloc] initWithFacebookAccount:account  picture:picture];
	
	PhotoCommentsViewController * controller=[[PhotoCommentsViewController alloc] initWithFeed:feed  title:@"Comments"  phoneMode:phoneMode];
	
	[feed release];
	
	showCommentsPopover=[[UIPopoverController alloc] initWithContentViewController:controller];
	
	showCommentsPopover.delegate=self;
	
	[showCommentsPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
	
	[controller release];
}
- (IBAction) showComments:(id)sender
{
	if(phoneMode)
	{
		[self showCommentsPhone:sender];
	}
	else 
	{
		[self showCommentsPad:sender];
	}
}


- (void) addCommentPhone:(id)sender
{
	cancelRemoveBars=YES;
	
	PhoneAddCommentViewController * controller=[[PhoneAddCommentViewController alloc] init];
	controller.delegate=self;
	controller.modalPresentationStyle=UIModalPresentationFullScreen;
	
	[self presentModalViewController:controller animated:YES];
	
	[controller release];
}
	
- (void) addCommentPad:(id)sender
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

- (IBAction) addComment:(id)sender
{
	if(phoneMode)
	{
		[self addCommentPhone:sender];
	}
	else 
	{
		[self addCommentPad:sender];
	}
}
- (void) sendComment:(NSString*)comment
{
	if(!phoneMode)
	{
		[addCommentPopover dismissPopoverAnimated:YES];
		addCommentPopover=nil;
	}
	else 
	{
		[self dismissModalViewControllerAnimated:YES];
	}
	
	if([comment length]>0)
	{
		Picture * picture=[self.pictures objectAtIndex:currentItemIndex];
		[[PixelLifeAppDelegate sharedAppDelegate] sendComment:comment uid:picture.uid];
		picture.commentCount++;
		showCommentsButton.enabled=(picture.commentCount>0);
	}
}

- (IBAction) addFavorite:(id)sender
{
	UIActionSheet * sheet=[[UIActionSheet alloc] initWithTitle:@"I like this photo..." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Like on Facebook",nil];
	sheet.tag=kLikeActionSheet;
	[sheet showFromBarButtonItem:sender animated:YES];
	[sheet release];
}

- (IBAction) action:(id)sender
{
	UIActionSheet * sheet=[[UIActionSheet alloc] initWithTitle:@"Photo Actions" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Email photo",@"Save photo",nil];
	sheet.tag=kActionActionSheet;
	[sheet showFromBarButtonItem:sender animated:YES];
	[sheet release];
}

- (void) likePhoto
{
	Picture * picture=[self.pictures objectAtIndex:currentItemIndex];
	
	[[PixelLifeAppDelegate sharedAppDelegate] likeGraphObject:picture.uid];	
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
	[self cancelSlideshow];
	if(self.infoView.frame.size.height==192)
	{
		[UIView beginAnimations:@"swipeup" context:nil];
		self.infoView.frame=CGRectMake(0, self.infoView.frame.origin.y-100, self.infoView.frame.size.width, self.infoView.frame.size.height+100);
		[UIView commitAnimations];
	}
}

- (void) swipeDown:(UIGestureRecognizer*)gr
{
	[self cancelSlideshow];
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
	[self cancelSlideshow];
	[self toggleNavigationBar];
}

- (void) doubleTap:(UIGestureRecognizer*)gr
{
	[self cancelSlideshow];
	[self toggleZoomAtTouchPoint:[gr locationInView:scrollView]];
}

- (void) toggleZoomAtTouchPoint:(CGPoint)point
{
	CGPoint adj=point;
	adj.x-=scrollView.contentOffset.x;
	adj.y-=scrollView.contentOffset.y;
	
	PictureImageScrollView * picView=[picViews objectAtIndex:currentItemIndex];
	[picView toggleZoomAtTouchPoint:adj];
}

- (CGRect) getBounds
{
	if([[UIApplication sharedApplication]    statusBarOrientation]==UIInterfaceOrientationPortrait ||
	   [[UIApplication sharedApplication] statusBarOrientation]==UIInterfaceOrientationPortraitUpsideDown)
	{
		return [[UIScreen mainScreen] bounds];
	}
	else 
	{
		CGRect b=[[UIScreen mainScreen] bounds];
		CGFloat w=b.size.width;
		b.size.width=b.size.height;
		b.size.height=w;
		return b;
	}
}

-(void) addPicturesToScrollView
{
	CGFloat left=0;
	CGFloat top=0;
	NSInteger index=0;
	
	CGRect frame=[self getBounds];
	
	CGFloat width=frame.size.width;
	CGFloat height=frame.size.height;
	
	[picViews removeAllObjects];
	
	for(Picture * picture in pictures)
	{
		CGFloat x= (((2*PADDING) + width) * index) + PADDING;
		CGFloat y=top;
		
		CGRect frame=CGRectMake(x,y,width,height);
		PictureImageScrollView * picView=[[PictureImageScrollView alloc] initWithFrame:frame picture:picture];
		
		[scrollView addSubview:picView];
		
		[picViews addObject:picView];
		
		[picView release];
		
		left+=width;
		index++;
	}
	[scrollView setContentSize:CGSizeMake([pictures count]*(width+ (2*PADDING)), height)];
}

- (void) setPictureFrames
{
	CGFloat left=0;
	CGFloat top=0;
	NSInteger index=0;
	CGRect frame=[self getBounds];
	
	CGFloat width=frame.size.width;
	CGFloat height=frame.size.height;
	
	for(UIView * picView in picViews)
	{
		CGFloat x= (((2*PADDING) + width) * index) + PADDING;
		CGFloat y=top;
		
		CGRect frame=CGRectMake(x,y,width,height);
		
		[picView updateFrame:frame];
		
		[picView setNeedsLayout];
		[picView setNeedsDisplay];
		
		left+=width;
		index++;
	}
	[scrollView setContentSize:CGSizeMake([pictures count]*(width+ (2*PADDING)), height)];
	[scrollView setNeedsDisplay];
}
 
- (void)viewDidLoad 
{
    [super viewDidLoad];
	scrollView.backgroundColor=[UIColor blackColor];
	
	sortOrder=SlideshowOrderBySequential;
	fillScreen=YES;
	delaySeconds=3;
}

- (void)hideNavigationBarAndInfoView
{
	CGRect infoViewFrame=infoView.frame;
	infoViewFrame.origin.y= self.view.frame.size.height;
	
	CGRect toolbarFrame=toolbar.frame;
	toolbarFrame.origin.y=self.view.frame.size.height;
	
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:UINavigationControllerHideShowBarDuration];
	
	if(!phoneMode)
	{
		infoView.frame=infoViewFrame;
	}
	else 
	{
		toolbar.frame=toolbarFrame;
	}

	[UIView commitAnimations];
	
	[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
	[self.navigationController setNavigationBarHidden:YES animated:YES];
	
	[self.navigationController.view setNeedsLayout];
}

- (void) showNavigationBarAndInfoView
{
	[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
	[self.navigationController setNavigationBarHidden:NO animated:NO];
	
	CGRect infoViewFrame=infoView.frame;
	infoViewFrame.origin.y= self.view.frame.size.height-infoViewFrame.size.height;
	
	CGRect toolbarFrame=toolbar.frame;
	toolbarFrame.origin.y=self.view.frame.size.height-toolbarFrame.size.height;
	
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:UINavigationControllerHideShowBarDuration];
	if(!phoneMode)
	{
		infoView.frame=infoViewFrame;
	}
	else 
	{
		toolbar.frame=toolbarFrame;
	}

	[UIView commitAnimations];
	
	[self.navigationController.view setNeedsLayout];
}

- (void)toggleNavigationBar 
{
	BOOL statusBarHidden=[[UIApplication sharedApplication] isStatusBarHidden];
	
	if(statusBarHidden)
	{
		[self showNavigationBarAndInfoView];
	}
	else 
	{
		[self hideNavigationBarAndInfoView];
	}
}

-(void)hideNavigationBarWithTimer:(NSTimer*)theTimer { 
	if (cancelRemoveBars) return;
	if(slideshowMode) return;
	[self performSelectorOnMainThread:@selector(hideNavigationBarAndInfoView) withObject:nil waitUntilDone:NO];
}

- (void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	if(!cancelRemoveBars)
	{
		if(!slideshowMode)
		{
			NSTimer * myTimer = [NSTimer scheduledTimerWithTimeInterval:6.0 target:self selector:@selector(hideNavigationBarWithTimer:) userInfo:nil repeats:NO];
		}
	}
}

- (void) viewWillDisappear:(BOOL)animated
{
	cancelRemoveBars=YES;
	slideshowMode=NO;
	[super viewWillDisappear:animated];
}

- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	self.navigationController.navigationBar.translucent=YES;
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
	[self cancelSlideshow];
	[self loadVisiblePictures]; 
}

- (void) loadVisiblePictures
{
	int i=0;
	
	BOOL unloadImages=YES;
	
	for(UIView * picView in picViews)
	{
		if(CGRectIntersectsRect(picView.frame, scrollView.bounds))
		{
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
	Picture * currentPicture=[pictures objectAtIndex:currentItemIndex];
	
	if (currentPicture.commentCount>0) 
	{
		showCommentsButton.enabled=YES;
	}
	else 
	{
		showCommentsButton.enabled=NO;
	}
	
	if(!phoneMode)
	{
		infoNameLabel.text=currentPicture.name;
		
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
		
		infoImageView.user=currentPicture.user;
		[infoImageView load];
	}
}

- (void) showInfoView
{
	if(!phoneMode)
	{
		CGRect rect2=infoView.frame;
		rect2.origin.y= self.view.frame.size.height-rect2.size.height;	
		self.infoView.frame=rect2;
	}
	else 
	{
		CGRect rect2=toolbar.frame;
		rect2.origin.y= self.view.frame.size.height-rect2.size.height;	
		self.toolbar.frame=rect2;
	}
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
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
	if([popoverController isEqual:showCommentsPopover])
	{
		[showCommentsPopover release];
		showCommentsPopover=nil;
	}
	else 
	{
		if([popoverController isEqual:addCommentPopover])
		{
			[addCommentPopover release];
			addCommentPopover=nil;
		}
		else 
		{
			if([popoverController isEqual:slideshowOptionsPopover])
			{
				[slideshowOptionsPopover release];
				slideshowOptionsPopover=nil;
			}
		}
	}
}

- (void) didReceiveMemoryWarning
{
	UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"memory warning" message:@"didReceiveMemoryWarning" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
	[alert show];
	[alert release];
}
		
- (void) startSlideshowWithDelaySeconds:(NSInteger)optDelaySeconds andSortOrder:(SlideshowSortOrder)optSortOrder fillScreen:(BOOL)optFillScreen	
{	
	delaySeconds=optDelaySeconds;
	sortOrder=optSortOrder;
	fillScreen=optFillScreen;
	[slideshowOptionsPopover dismissPopoverAnimated:YES];
	slideshowOptionsPopover=nil;
	cancelRemoveBars=YES;
	[self cancelSlideshow];
	slideshowMode=YES;
	[self hideNavigationBarAndInfoView];
	
	PictureImageScrollView * picView=[picViews objectAtIndex:currentItemIndex];
	
	if(fillScreen)
	{
		[picView setImageContentMode:UIViewContentModeScaleAspectFill];
	}
	else 
	{
		[picView setImageContentMode:UIViewContentModeScaleAspectFit];
	}

	CATransition *applicationLoadViewIn = [CATransition animation];
	[applicationLoadViewIn setDuration:1];
	[applicationLoadViewIn setType:kCATransitionFade];
	[applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
	[[scrollView layer] addAnimation:applicationLoadViewIn forKey:kCATransitionFade];
	
	[self goToCurrentItem];
	[self loadVisiblePictures];
	
	slideshowTimer = [NSTimer scheduledTimerWithTimeInterval:(CGFloat)delaySeconds target:self selector:@selector(goToNextSlideshowItemWithTimer:) userInfo:nil repeats:YES];
}

- (void) cancelSlideshow
{
	slideshowMode=NO;
	if([slideshowTimer isValid])
	{
		[slideshowTimer invalidate];
		slideshowTimer=nil;
		
		// set all content modes back to aspect fit...
		for (PictureImageScrollView * picView in picViews)
		{
			[picView setImageContentMode:UIViewContentModeScaleAspectFit];
		}
	}
}

- (void) goToNextSlideshowItemWithTimer:(NSTimer*)timer
{
	if (!slideshowMode) return;
	[self performSelectorOnMainThread:@selector(goToNextSlideshowItem) withObject:nil waitUntilDone:NO];
}

- (void) goToNextSlideshowItem
{
	switch(sortOrder)
	{
		case SlideshowOrderByDate:
		{
			if(currentItemIndex < [pictures count]-1)
			{
				currentItemIndex++;
			}
			else 
			{
				currentItemIndex=0;
			}
		}
			break;
		case SlideshowOrderByRandom:
		{
			if(currentItemIndex < [pictures count]-1)
			{
				currentItemIndex++;
			}
			else 
			{
				currentItemIndex=0;
			}
		}
			break;
		case SlideshowOrderBySequential:
		{
			if(currentItemIndex < [pictures count]-1)
			{
				currentItemIndex++;
			}
			else 
			{
				currentItemIndex=0;
			}
		}
			break;
			
	}
	
	PictureImageScrollView * picView=[picViews objectAtIndex:currentItemIndex];
	 
	if(fillScreen)
	{
		[picView setImageContentMode:UIViewContentModeScaleAspectFill];
	}
	else 
	{
		[picView setImageContentMode:UIViewContentModeScaleAspectFit];
	}
	
	CATransition *applicationLoadViewIn = [CATransition animation];
	[applicationLoadViewIn setDuration:1];
	[applicationLoadViewIn setType:kCATransitionFade];
	[applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
	[[scrollView layer] addAnimation:applicationLoadViewIn forKey:kCATransitionFade];
	
	[self goToCurrentItem];
	[self loadVisiblePictures];
}

- (void)dealloc 
{
	[showCommentsButton release];
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
	[slideshowOptionsPopover release];
	slideshowOptionsPopover=nil;
	[infoView release];
	[infoFirstNameLabel release];
	[infoLastNameLabel release];
	[infoNumCommentsLabel release];
    [super dealloc];
}

@end
