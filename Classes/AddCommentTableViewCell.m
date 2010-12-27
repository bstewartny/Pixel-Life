#import "AddCommentTableViewCell.h"


@implementation AddCommentTableViewCell
@synthesize messageTextView;

- (IBAction) addButtonTouch:(id)sender
{
	/*if([messageTextView.text isEqualToString:@"Add Comment..."])
	{
		messageTextView.text=@"";
	}*/
	//[messageTextView becomeFirstResponder];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
	if([textView.text isEqualToString:@"Add Comment..."])
	{
		textView.text=@"";
		textView.textColor=[UIColor whiteColor];
	}
	
	// scroll to make it visible...
	UITableView * tableView=[self superview];
	
	//[tableView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationTop];
	
	//if(tableView==nil)
	//{
	///	NSLog(@"tableView is nil!!!");
	//}
	//if(![tableView isKindOfClass:[UITableView class]])
	//{
	//	NSLog(@"not a tableView!!!!");
	//}
	/*
	
	origFrame=[tableView superview].frame;
	
	[tableView superview].frame=CGRectMake(origFrame.origin.x, origFrame.origin.y, origFrame.size.width,origFrame.size.height-200);
	
	NSIndexPath* ip = [NSIndexPath indexPathForRow:[tableView numberOfRowsInSection:0] - 1 inSection:0];
	
	NSLog(@"got ip for last row: %@",[ip description]);
	NSLog(@"scroll to last row...");
	*/
	
	[tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:NO];
	
	//[tableView scrollToRowAtIndexPath:[tableView indexPathForCell:self] atScrollPosition:UITableViewScrollPositionTop animated:YES];

	 }

- (void)textViewDidEndEditing:(UITextView *)textView
{
	// put tableview back to correct size...
	/*if(origFrame.size.width>0)
	{
		UITableView * tableView=[self superview];
		
		[tableView superview].frame=origFrame;
		origFrame=CGRectZero;
	}*/
}
/*- (void)textViewDidChange:(UITextView *)inTextView {
	
    NSString *text = inTextView.text;
	
    if ([text length] > 0 && [text characterAtIndex:[text length] -1] == '\n') {
        inTextView.text = [text substringToIndex:[text length] -1];
        [inTextView resignFirstResponder];
        [self sendMessage];		
    }
}*/
/*
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
	[textView resignFirstResponder];
	return YES;
}*/
- (IBAction) sendMessage:(id)sender;
{
	[messageTextView resignFirstResponder];
	[self.superview resignFirstResponder];
	messageTextView.text=@"";
	/*if([messageTextView.text length]>0)
	{
		UIAlertView * test=[[UIAlertView alloc] initWithTitle:@"Send Comment" message:messageTextView.text delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		
		messageTextView.text=@"";
		
		[test show];
		
		[test release];
	}*/
}

- (void) load
{
	
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}

- (void)dealloc {
	[messageTextView release];
    [super dealloc];
}


@end
