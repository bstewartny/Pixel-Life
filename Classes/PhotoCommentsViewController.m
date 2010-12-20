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
@synthesize tableView,comments;

- (id)initWithComments:(NSArray*)comments title:(NSString*)title
{
    if(self=[super initWithNibName:@"PhotoCommentsView" bundle:nil])
	{
		self.comments=comments;
		self.navigationItem.title=title;
		self.title=title;
    }
    return self;
}

- (IBAction) close:(id)sender
{
	[[self parentViewController] dismissModalViewControllerAnimated:YES]; 
}

- (void)showLoadingView
{
	//[spinningWheel startAnimating];
	//[self.view bringSubviewToFront:spinningWheel];
}

- (void)hideLoadingView
{
	//[spinningWheel stopAnimating];
	//[self.view sendSubviewToBack:spinningWheel];
}

- (void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[tableView reloadData];
	[self loadVisibleCells];
}

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation
{
    return YES;
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

- (UITableViewCell *)loadCellFromNibNamed:(NSString*)nib
{
	NSArray * topLevelObjects=[[NSBundle mainBundle] loadNibNamed:nib owner:nil options:nil];
	
	for(id currentObject in topLevelObjects)
	{
		if([currentObject isKindOfClass:[UITableViewCell class]])
		{
			return currentObject;
		}
	}
	return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	//if(indexPath.row==[comments count])
	//{
	//if(indexPath.section==1)
	//{
	//	// add new comment row
	//	AddCommentTableViewCell * cell=(AddCommentTableViewCell*)[self loadCellFromNibNamed:@"AddCommentTableViewCell"];
	//	cell.selectionStyle=UITableViewCellSelectionStyleNone;
	//	return cell;
	//}
	
	Comment * comment=[comments objectAtIndex:indexPath.row];
	
	/*UITableViewCell * cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
	
	cell.backgroundColor=[UIColor viewFlipsideBackgroundColor];
	
	cell.imageView.image=[UIImage imageNamed:@"icon.png"];
	
	///cell.imageView.frame=CGRectMake(5,5,50,50);
	//cell.imageView.autoresizingMask=UIViewAutoresizingFlexibleBottomMargin |
	//								UIViewAutoresizingFlexibleRightMargin;	
	
	cell.textLabel.text=comment.user.name;
	cell.textLabel.textColor=[UIColor whiteColor];
	cell.textLabel.font=[UIFont boldSystemFontOfSize:14];
	
	//cell.detailTextLabel.text = @"Multi-Line\nText";
	cell.detailTextLabel.textColor=[UIColor whiteColor];
	cell.detailTextLabel.numberOfLines = 10;
	cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
	
	cell.detailTextLabel.text=comment.message;
	
	return cell;
	*/
	static NSString * cellIdentifier = @"CommentTableViewCellIdentifier";
	
	CommentTableViewCell * cell=(CommentTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if(cell==nil)
	{
		cell=(CommentTableViewCell*)[self loadCellFromNibNamed:@"CommentTableViewCell"];
		
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
	
	}
	
	cell.comment=comment;
	
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [comments count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@"heightForRowAtIndexPath");
	
	CGFloat width=self.contentSizeForViewInPopover.width-80;
	
	Comment * comment=[comments objectAtIndex:indexPath.row];
	
	return [CommentTableViewCell cellHeightForComment:comment];
	/*
	CGSize constraint = CGSizeMake(width, 20000.0f);
	
	CGSize size=[comment.message sizeWithFont:[UIFont systemFontOfSize:17.0] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
	
	NSLog(@"message: %@",comment.message);
	
	NSLog(@"system size=%@",NSStringFromCGSize(size));

	CGSize size2=[comment.message sizeWithFont:[UIFont fontWithName:@"Helvetica" size:17.0] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
	
	NSLog(@"helvetica size=%@",NSStringFromCGSize(size2));
	
	if(size.height>34.0)
	{
		CGFloat newHeight=size.height+32.0;
		
		NSLog(@"setting cell height to %f", newHeight);
		
		return newHeight;  
	}
	else 
	{
		return 65.0;
	}*/
}

- (CGSize) contentSizeForViewInPopover
{
	return CGSizeMake(320.0, 600);
}

- (void)dealloc {
	[comments release];
	[tableView release];
	[super dealloc];
}

@end
