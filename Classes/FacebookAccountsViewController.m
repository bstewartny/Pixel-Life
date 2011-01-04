#import "FacebookAccountsViewController.h"
#import "FacebookAccount.h"
#import "Facebook.h"
#import "PhotoExplorerAppDelegate.h"
#import "Reachability.h"
#import "FacebookAccountInfoFeed.h"

@implementation FacebookAccountsViewController
@synthesize accounts;
@synthesize delegate;
@synthesize tableView;

-(id) initWithAccounts:(NSMutableArray*)accounts
{
	if(self=[super initWithNibName:@"FacebookAccountsView" bundle:nil])
	{
		self.accounts=accounts;
		facebook=[[Facebook alloc] init];
		facebook.sessionDelegate=self;
	}
	return self;
}

- (IBAction) addAccount:(id)sender
{
	// verify we have internet connection...
	Reachability *reachManager = [Reachability reachabilityWithHostName:@"www.facebook.com"];
	NetworkStatus remoteHostStatus = [reachManager currentReachabilityStatus];
	if (remoteHostStatus == NotReachable)
	{
		// dont try to authorize...
		UIAlertView * alertView=[[UIAlertView alloc] initWithTitle:@"Facebook Unreachable" message:@"Internet connection required to login to Facebook." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		
		[alertView show];
		
		[alertView release];
		
		return;
	}
	 	
	// delete existing cookies so we can get a login screen
	NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	NSArray* facebookCookies = [cookies cookiesForURL:
								[NSURL URLWithString:@"http://login.facebook.com"]];
	
	for (NSHTTPCookie* cookie in facebookCookies) {
		[cookies deleteCookie:cookie];
	}
	
	// pop up facebook login screen
	facebook.accessToken=nil;
	facebook.expirationDate=nil;
	
	// TODO: dont use facebook/safari cookies here... it will override other accounts...
	[facebook authorize:kAppId permissions:[NSArray arrayWithObjects:
											@"read_stream",@"friends_photos", @"read_friendlists",@"user_photos",@"offline_access",nil] delegate:self];
	
}

- (void)feed:(Feed *)feed didFindItems:(NSArray *)items
{
	// save new account
	[[PhotoExplorerAppDelegate sharedAppDelegate] saveData];
	
	[tableView reloadData];
}

- (void)feed:(Feed *)feed didFailWithError:(NSString *)errorMsg
{
	UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Failed to get account information from Facebook.  Please try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	
	[alert show];
	
	[alert release];
	[tableView reloadData];
}


- (void)fbDidLogin
{
	NSLog(@"fbDidLogin");
	if([facebook isSessionValid])
	{
		//NSLog(@"session is valid, adding new account...");
		// get account info...
		// do graph request for "me"
		
		FacebookAccount * newAccount=[[FacebookAccount alloc] init];
		
		newAccount.name=@"Loading account...";
		newAccount.accessToken=facebook.accessToken;
		newAccount.expirationDate=facebook.expirationDate;
		
		[accounts addObject:newAccount];
		
		[infoFeed release];
		
		infoFeed=[[FacebookAccountInfoFeed alloc] initWithFacebookAccount:newAccount];
		
		infoFeed.delegate=self;
		
		[infoFeed fetch];
		
		[tableView reloadData];
		
		[newAccount release];
	}
	else 
	{
		NSLog(@"session is not valid...");
	}
}

- (void)fbDidLogout
{
	//NSLog(@"fbDidLogout");
}

- (void)fbDidNotLogin:(BOOL)cancelled
{
	//NSLog(@"fbDidNotLogin");
}

- (IBAction) editAccounts:(id)sender
{
	UIBarButtonItem * button=(UIBarButtonItem*)sender;
	// turn on editing mode and reload table
	
	if(tableView.editing)
	{
		tableView.editing=NO;
		button.style=UIBarButtonItemStyleBordered;
		button.title=@"Edit";
	}
	else 
	{
		tableView.editing=YES;
		button.style=UIBarButtonItemStyleDone;
		button.title=@"Done";
	}
	[tableView reloadData];
}

- (IBAction) done:(id)sender
{
	// close
	[self close];
}

- (void) close
{
	if ([accounts count]==1) 
	{
		if([[PhotoExplorerAppDelegate sharedAppDelegate] currentAccount]==nil)
		{
			[[PhotoExplorerAppDelegate sharedAppDelegate] setCurrentAccount:[accounts objectAtIndex:0]];
			
			[[PhotoExplorerAppDelegate sharedAppDelegate] showAllFriends];
		}
	}
	
	[[self parentViewController] dismissModalViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(indexPath.row < [accounts count])
	{
		// switch to selected user and close
		FacebookAccount * account=[accounts objectAtIndex:indexPath.row];
	
		[[PhotoExplorerAppDelegate sharedAppDelegate] setCurrentAccount:account];
		
		[[PhotoExplorerAppDelegate sharedAppDelegate] showAllFriends];
		
		[self close];
	}
	else 
	{
		[self addAccount:nil];
	}
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(indexPath.row < [accounts count])
	{
		return UITableViewCellEditingStyleDelete;
	}
	else 
	{
		return UITableViewCellEditingStyleNone;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString * identifier=@"cellIdentifier";
	
	UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:identifier];
	
	if(cell==nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
		//cell.accessoryType = UITableViewCellAccessoryCheckmark;
		cell.selectionStyle=UITableViewCellSelectionStyleNone;
	}
	
	if(indexPath.row < [accounts count])
	{	
		FacebookAccount * account=[accounts objectAtIndex:indexPath.row];
	
		FacebookAccount * currentAccount=[[PhotoExplorerAppDelegate sharedAppDelegate] currentAccount];
		
		if([account.name isEqualToString:[currentAccount name]])
		{
			cell.accessoryType=UITableViewCellAccessoryCheckmark;
		}
		else 
		{
			cell.accessoryType=UITableViewCellAccessoryNone;
		}
		
		//cell.editingStyle=UITableViewCellEditingStyleDelete;
		cell.textLabel.textColor=[UIColor blackColor];
		cell.textLabel.text=account.name;
	}
	else 
	{
		//cell.editingStyle=UITableViewCellEditingStyleNone;
		cell.textLabel.textColor=[UIColor grayColor];
		cell.textLabel.text=@"Tap here to add an account...";
	}

	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if(accounts==nil)
	{
		NSLog(@"accounts is nil!!!");
	}
	return [accounts count]+1;
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
	return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	// If row is deleted, remove it from the list.
	if (editingStyle == UITableViewCellEditingStyleDelete)
	{
		if(indexPath.row < [accounts count])
		{
			// delete your data item here
			FacebookAccount * account=[accounts objectAtIndex:indexPath.row];
			
			FacebookAccount * currentAccount=[PhotoExplorerAppDelegate sharedAppDelegate].currentAccount;
			
			if([account.name isEqualToString:[currentAccount name]])
			{
				[[PhotoExplorerAppDelegate sharedAppDelegate] setCurrentAccount:nil];
			}
			
			[accounts removeObjectAtIndex:indexPath.row];
			
			// Animate the deletion from the table.
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
		}
	}
}

- (void)dealloc 
{
	[tableView release];
	[accounts release];
	[facebook release];
	[infoFeed release];
    [super dealloc];
}

@end
