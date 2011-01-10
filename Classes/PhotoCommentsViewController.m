#import "PhotoCommentsViewController.h"
#import "PixelLifeAppDelegate.h"
#import "Reachability.h"
#import "Feed.h"
#import "CommentTableViewCell.h"
#import "Comment.h"
#import "AddCommentTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "BlankToolbar.h"
#import "User.h"
#import "AddCommentViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "Picture.h"
#import "FacebookAccount.h"
#import "PhoneAddCommentViewController.h"

@implementation PhotoCommentsViewController
@synthesize tableView;
@synthesize picture;

- (id)initWithFeed:(Feed*)feed title:(NSString*)title  phoneMode:(BOOL)mode
{
	phoneMode=mode;
	
	if(phoneMode)
	{
		self=[super initWithFeed:feed title:title withNibName:@"PhonePhotoCommentsView"];
	}
	else {
		self=[super initWithFeed:feed title:title withNibName:@"PhotoCommentsView"];
	}

	if(self)
	{
		tableView.backgroundColor=[UIColor viewFlipsideBackgroundColor];
	}
    return self;
}

- (IBAction) addComment:(id)sender
{
	if(phoneMode)
	{
		PhoneAddCommentViewController * controller=[[PhoneAddCommentViewController alloc] init];
		controller.delegate=self;
		controller.modalPresentationStyle=UIModalPresentationFullScreen;
		
		[self presentModalViewController:controller animated:YES];
		
		[controller release];
	}
	else 
	{
		AddCommentViewController * controller=[[AddCommentViewController alloc] init];
		controller.delegate=self;
		controller.modalPresentationStyle=UIModalPresentationFullScreen;
		
		[self presentModalViewController:controller animated:YES];
		
		[controller release];
		
	}

	 
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
	if(picture)
	{
		picture.commentCount++;
	}
	
	// refresh comments for picture...
	[self reloadFeed];
}

- (void)sendCommentRequestWentWrong:(ASIHTTPRequest *)request
{
	NSError *error = [request error];
	
	UIAlertView * alertView=[[UIAlertView alloc] initWithTitle:@"Error sending comment" message:[error description] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

- (void) popViewController:(id)sender
{
	[self.navigationController popViewControllerAnimated:NO];
	/*[CATransaction begin];
	CATransition *transition = [CATransition animation];
	transition.duration = 0.3;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	transition.type=kCATransitionPush;
	transition.subtype = kCATransitionFromTop;//kCATransitionMoveIn
	
	[self.view.layer addAnimation:transition forKey:nil];
	
	
	CATransition *ftransition = [CATransition animation];
	ftransition.duration = 0.3;
	ftransition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	ftransition.type=kCATransitionFade;
	//transition.subtype = kCATransitionFromTop;
	[CATransaction setValue:(id)kCFBooleanTrue
					 forKey:kCATransactionDisableActions];
	
	//[self.navigationController.view.layer addAnimation:ftransition forKey:nil];
	[self.navigationController popViewControllerAnimated:YES];
	[CATransaction commit];*/
	/*
	
	[CATransaction begin];
	
	CATransition *transition;
	transition = [CATransition animation];
	transition.type = kCATransitionPush;          // Use any animation type and subtype you like
	transition.subtype = kCATransitionFromTop;
	transition.duration = 0.3;
	
	CATransition *fadeTrans = [CATransition animation];
	fadeTrans.type = kCATransitionFade;
	fadeTrans.duration = 0.3;
	
	
	[CATransaction setValue:(id)kCFBooleanTrue
					 forKey:kCATransactionDisableActions];
	
	[self.view.layer addAnimation:transition forKey:nil];
	
	//[[[[self.view subviews] objectAtIndex:0] layer] addAnimation:transition forKey:nil];
	//[[[[self.view subviews] objectAtIndex:1] layer] addAnimation:fadeTrans forKey:nil];
	
	
	
	[self.navigationController popViewControllerAnimated:YES];
	
	[CATransaction commit];
	
	*/
	
}

- (IBAction) close:(id)sender
{
	[[self parentViewController] dismissModalViewControllerAnimated:YES]; 
}

- (void) reloadData
{
	[tableView reloadData];
	[self loadVisibleCells];
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	[self loadVisibleCells]; 
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView; 
{
    // Method is called when the decelerating comes to a stop.
    // Pass visible cells to the cell loading function. If possible change 
    // scrollView to a pointer to your table cell to avoid compiler warnings
    [self loadVisibleCells]; 
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
{
    if (!decelerate) 
    {
        [self loadVisibleCells]; 
    }
}

- (void) loadVisibleCells
{
	for(CommentTableViewCell * cell in [tableView visibleCells])
	{
		[cell load];
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	Comment * comment=[items objectAtIndex:indexPath.row];
	
	static NSString * cellIdentifier = @"CommentTableViewCellIdentifier";
	
	CommentTableViewCell * cell=nil;//(CommentTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if(cell==nil)
	{
		cell=[[[CommentTableViewCell alloc] initWithStyle:UITableViewStylePlain reuseIdentifier:cellIdentifier] autorelease];
		
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
	}
	
	cell.comment=comment;
	[cell load];
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [items count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	Comment * comment=[items objectAtIndex:indexPath.row];
	
	return [CommentTableViewCell cellHeightForComment:comment withCellWidth:self.contentSizeForViewInPopover.width];
}

- (CGSize) contentSizeForViewInPopover
{
	/*if([items count]<4)
	{
		CGFloat height=0;
		
		for(Comment * comment in items)
		{
			height+=[CommentTableViewCell cellHeightForComment:comment withCellWidth:320.0];
		}
		
		return CGSizeMake(320.0,height);
	}
	else 
	{*/
		return CGSizeMake(320.0, 600);
	//}
}

- (void)dealloc {
	[tableView release];
	[picture release];
	[super dealloc];
}

@end
