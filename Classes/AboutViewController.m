#import "AboutViewController.h"
#import <MessageUI/MessageUI.h>
#import "CustomCellBackgroundView.h"
#import <QuartzCore/QuartzCore.h>

@implementation AboutViewController
@synthesize tableView;

- (id) init
{
	if([[[UIApplication sharedApplication] delegate] isPhone])
	{
		NSLog(@"using PhoneAboutView nib...");
		self=[super initWithNibName:@"PhoneAboutView" bundle:nil];
		//self.tableView.backgroundView=nil;
		//self.tableView.backgroundColor=[UIColor blackColor];
		
	}
	else 
	{
		NSLog(@"using AboutView nib...");
		
		self=[super initWithNibName:@"AboutView" bundle:nil];
		//self.tableView.backgroundView=[[[UIView alloc] init] autorelease];
		/*UIView * bg=[[UIView alloc] init];
		bg.backgroundColor=[UIColor blackColor];
		bg.opaque=YES;
		self.tableView.backgroundView=bg;
		[bg release];
		 
		self.tableView.backgroundColor=[UIColor clearColor];*/
		
	}

	return self;
}
- (void) viewDidLoad
{
	if(![[[UIApplication sharedApplication] delegate] isPhone])
	{
		UIView * bg=[[UIView alloc] init];
		bg.backgroundColor=[UIColor viewFlipsideBackgroundColor];
		bg.opaque=YES;
		self.tableView.backgroundView=bg;
		[bg release];
	}
	else 
	{
		UIView * bg=[[UIView alloc] init];
		bg.backgroundColor=[UIColor blackColor];
		bg.opaque=YES;
		self.tableView.backgroundView=bg;
		[bg release];
	}

}
- (IBAction) done
{
	NSLog(@"done clicked");
	
	[[self parentViewController] dismissModalViewControllerAnimated:YES];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return YES;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}
/*- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	if(section==0)
	{
		return 140;
	}
	else {
		return 22;//[super tableView:tableView heightForHeaderInSection:section];
	}

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	if(section==2)
	{
		return 100;
	}
	else {
		return 22;//[super tableView:tableView heightForHeaderInSection:section];
	}
	
}*/
// Section header & footer information. Views are preferred over title should you decide to provide both

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
	if(section!=2) return nil;
	
	// show icon...
	
	UIView * v=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
	v.autoresizingMask=UIViewAutoresizingFlexibleWidth;
	v.backgroundColor=[UIColor clearColor];
	
	 	
	UILabel *l=[[UILabel alloc] initWithFrame:CGRectMake(0, 4, 320, 22)];
	l.autoresizingMask=UIViewAutoresizingFlexibleWidth;
	//l.font=[UIFont systemFontOfSize:16];
	l.font=[UIFont fontWithName:@"Verdana" size:16];
	l.textColor=[UIColor lightGrayColor];
	l.backgroundColor=[UIColor clearColor];
	l.text=@"OmegaMuse, LLC";
	l.textAlignment=UITextAlignmentCenter;
	[v addSubview:l];
	
	[l release];
	
	return [v autorelease];
}
/*- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	if(section!=0) return nil;
	
	UIImage * icon=[UIImage imageNamed:@"aboutlogo.png"];
	 
	const float colorMasking[6] = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0}; 
	
	icon = [UIImage imageWithCGImage: CGImageCreateWithMaskingColors(icon.CGImage, colorMasking)];
	
	UIView * v=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 130)];
	v.autoresizingMask=UIViewAutoresizingFlexibleWidth;
	v.backgroundColor=[UIColor clearColor];
	
	int left=5;
	if(![[[UIApplication sharedApplication] delegate] isPhone])
	{
		left=29;
	}
	
	
	
	UIImageView * iv=[[UIImageView alloc] initWithFrame:CGRectMake(left, 5, icon.size.width, icon.size.height)];
	iv.image=icon;
	iv.backgroundColor=[UIColor blueColor];
	iv.opaque=NO;
	iv.layer.cornerRadius=24;
	iv.clipsToBounds=YES;
	
	[v addSubview:iv];
	
	[iv release];
	
	UILabel *l=[[UILabel alloc] initWithFrame:CGRectMake(10+icon.size.width+left, 5+(icon.size.height/2)-11, 200, 22)];
	l.font=[UIFont boldSystemFontOfSize:20];
	l.textColor=[UIColor whiteColor];
	l.backgroundColor=[UIColor clearColor];
	l.text=@"Pixel Life";
	
	[v addSubview:l];
	
	[l release];
	
	return [v autorelease];
	
	
}*/
/*
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	if(section==2)
	{
		return @"OmegaMuse, LLC";
	}
	else {
		return nil;
	}

}*/

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	
	 
	 UITableViewCell * cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil] autorelease];
	 
	 cell.selectionStyle=UITableViewCellSelectionStyleNone;
	 
	 cell.backgroundColor=[UIColor clearColor];
	 
	 CustomCellBackgroundView * gbView=[[[CustomCellBackgroundView alloc] initWithFrame:CGRectZero] autorelease];
	 
	 cell.backgroundView=gbView;
	 
	 gbView.fillColor=[UIColor darkGrayColor]; 
	 gbView.borderColor=[UIColor grayColor];
	 
	 cell.backgroundView.alpha=0.5;
	 
	 cell.textLabel.textColor=[UIColor whiteColor];
	 
	 cell.detailTextLabel.textColor=[UIColor whiteColor];
	 
	 
	 [cell.backgroundView setPosition:CustomCellBackgroundViewPositionSingle];

	    
    // Configure the cell...
	switch (indexPath.section) {
		case 0:
			cell.textLabel.text=@"Version";
			cell.detailTextLabel.text=@"1.0";
			cell.accessoryType=UITableViewCellAccessoryNone;
			cell.selectionStyle=UITableViewCellSelectionStyleNone;
			break;
		case 1:
			cell.textLabel.text=@"feedback@omegamuse.com";
			cell.detailTextLabel.text=nil;
			cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
			cell.selectionStyle=UITableViewCellSelectionStyleNone;
			break;
		case 2:
			cell.textLabel.text=@"http://www.omegamuse.com";
			cell.detailTextLabel.text=nil;
			cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
			cell.selectionStyle=UITableViewCellSelectionStyleNone;
			break;
		default:
			break;
	}
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
    switch (indexPath.section) {
		case 0:
			// do nothing...
			break;
		case 1:
		{
			MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
			
			picker.mailComposeDelegate = self; // <- very important step if you want feedbacks on what the user did with your email sheet
			
			[picker setToRecipients:[NSArray arrayWithObject:@"feedback@omegamuse.com"]];
			[picker setSubject:@"Pixel Life Feedback"];
			
			picker.navigationBar.barStyle = UIBarStyleBlack; // choose your style, unfortunately, Translucent colors behave quirky.
			
			[self presentModalViewController:picker animated:YES];
			
			[picker release];
		}
			break;
		case 2:
			// go to web site (open safari)
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.omegamuse.com"]];
			break;
		default:
			break;
	}
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{ 
	// did user send email? if so mark last published date of newsletter to now...
	
	if(result==MFMailComposeResultSent)
	{
		
	}
	
	[self dismissModalViewControllerAnimated:YES];
}

- (void)dealloc {
	[tableView release];
    [super dealloc];
}


@end

