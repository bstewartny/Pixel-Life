#import "PhotoCommentsViewController.h"
#import "PhotoExplorerAppDelegate.h"
#import "Reachability.h"
#import "Feed.h"
#import "CommentTableViewCell.h"
#import "Comment.h"
#import "AddCommentTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

#import "User.h"

@implementation PhotoCommentsViewController
@synthesize tableView;

- (id)initWithFeed:(Feed*)feed title:(NSString*)title
{
    if(self=[super initWithFeed:feed title:title withNibName:@"PhotoCommentsView"])
	{
		tableView.backgroundColor=[UIColor viewFlipsideBackgroundColor];
	}
    return self;
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
		cell=[[CommentTableViewCell alloc] initWithStyle:UITableViewStylePlain reuseIdentifier:cellIdentifier];
		
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
	}
	
	cell.comment=comment;
	
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
	[super dealloc];
}

@end
