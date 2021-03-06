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
#import "FacebookAccount.h"
#import "PhoneAddCommentViewController.h"
 

@implementation PhotoCommentsViewController
@synthesize tableView;
@synthesize delegate;
@synthesize pictureComment;

- (id)initWithFeed:(Feed*)feed title:(NSString*)title  phoneMode:(BOOL)mode
{
	phoneMode=mode;
	
	if(phoneMode)
	{
		self=[super initWithFeed:feed title:title withNibName:@"PhonePhotoCommentsView"];
	}
	else 
	{
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
	PhoneAddCommentViewController * controller=[[PhoneAddCommentViewController alloc] init];
	controller.delegate=delegate;
	controller.modalPresentationStyle=UIModalPresentationFullScreen;
		
	[self presentModalViewController:controller animated:YES];
		
	[controller release];
}

- (void) popViewController:(id)sender
{
	[self.navigationController popViewControllerAnimated:NO];
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
	Comment * comment;
	
	if(pictureComment)
	{
		if(indexPath.row==0)
		{
			comment=pictureComment;
		}
		else 
		{
			comment=[items objectAtIndex:indexPath.row-1];
		}
	}
	else 
	{
		comment=[items objectAtIndex:indexPath.row];
	}
	
	CommentTableViewCell * cell=[[[CommentTableViewCell alloc] initWithStyle:UITableViewStylePlain reuseIdentifier:nil] autorelease];
		
	cell.selectionStyle=UITableViewCellSelectionStyleNone;
	
	cell.comment=comment;
	[cell load];
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if(pictureComment)
	{
		return [items count] +1;
	}
	else {
		return [items count];
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	Comment * comment;
	
	if(pictureComment)
	{
		if(indexPath.row==0)
		{
			comment=pictureComment;
		}
		else 
		{
			comment=[items objectAtIndex:indexPath.row-1];
		}
	}
	else 
	{
		comment=[items objectAtIndex:indexPath.row];
	}
	if(phoneMode)
	{
		return [CommentTableViewCell cellHeightForComment:comment withCellWidth:320.0];
	}
	else 
	{
		return [CommentTableViewCell cellHeightForComment:comment withCellWidth:self.contentSizeForViewInPopover.width];
	}
}

- (CGSize) contentSizeForViewInPopover
{
	return CGSizeMake(320.0, 600);
}

- (void)dealloc {
	[tableView release];
	[pictureComment release];
	[super dealloc];
}

@end
