#import "AddCommentViewController.h"
#import "Picture.h"

@implementation AddCommentViewController
@synthesize messageTextView,picture,delegate;

- (id)initWithPicture:(Picture*)picture
{
    if(self=[super initWithNibName:@"AddCommentView" bundle:nil])
	{
		self.picture=picture;
	}
    return self;
}


- (IBAction) send:(id)sender
{
	[messageTextView resignFirstResponder];
	// send it...
	// TODO: submit to processing queue (check internet connection first)
	// close popover...
	[delegate sendComment:messageTextView.text];
}
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/
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

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
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
	[picture release];
    [super dealloc];
}


@end
