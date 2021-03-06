#import "AddCommentViewController.h"

@implementation AddCommentViewController
@synthesize messageTextView,delegate;

- (id)init
{
    if(self=[super initWithNibName:@"AddCommentView" bundle:nil])
	{
		messageTextView.font=[UIFont fontWithName:@"Verdana" size:20];
	}
    return self;
}

- (IBAction) cancel:(id)sender
{
	[messageTextView resignFirstResponder];
	// send it...
	// TODO: submit to processing queue (check internet connection first)
	// close popover...
	[delegate sendComment:nil];
}

- (IBAction) send:(id)sender
{
	[messageTextView resignFirstResponder];
	// send it...
	// TODO: submit to processing queue (check internet connection first)
	// close popover...
	[delegate sendComment:messageTextView.text];
}

- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[messageTextView becomeFirstResponder];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return YES;
}

- (CGSize) contentSizeForViewInPopover
{
	return CGSizeMake(400,200);
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
		
	delegate=nil;
}

- (void)dealloc {
	delegate=nil;
	[messageTextView release];
	//[picture release];
    [super dealloc];
}


@end
