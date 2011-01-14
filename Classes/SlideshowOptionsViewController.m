#import "SlideshowOptionsViewController.h"
#import "BlankToolbar.h"

@implementation SlideshowOptionsViewController
@synthesize fillScreen,sortOrder,delaySeconds,tableView,delegate;

- (IBAction) startSlideshow:(id)sender
{
	[delegate startSlideshowWithDelaySeconds:self.delaySeconds andSortOrder:self.sortOrder fillScreen:self.fillScreen];
}

- (id) init
{
	if(self=[super initWithNibName:@"SlideshowOptionsView" bundle:nil])
	{
		
	}
	return self;
}

- (void) viewDidLoad
{
	[super viewDidLoad];
	self.navigationItem.title=@"Slideshow Options";
	self.title=@"Slideshow Options";
	
	fillScreen=YES;
	sortOrder=SlideshowOrderBySequential;
	delaySeconds=3;
	
	[tableView reloadData];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	switch (section) 
	{
		case 0:
			return @"Expand Photos to fill screen";
		case 1:
			return @"Time Delay Between Photos";
		//case 2:
		//	return @"Display Order";
		default:
			return nil;
	}
}

- (CGSize) contentSizeForViewInPopover
{
	return CGSizeMake(320,520);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 3;
	//return 4;
}

- (void) fillScreenSwitch:(UISwitch*)sw
{
	self.fillScreen=sw.isOn;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell * cell=[[[UITableViewCell alloc] initWithStyle:UITableViewStylePlain reuseIdentifier:nil] autorelease];
	cell.selectionStyle=UITableViewCellSelectionStyleBlue;

	switch (indexPath.section) {
		case 0:
			cell.selectionStyle=UITableViewCellSelectionStyleNone;

			cell.textLabel.text=@"Fill Screen";
			UISwitch * s=[[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
			[s setOn:fillScreen animated:NO];
			[s addTarget:self action:@selector(fillScreenSwitch:) forControlEvents:UIControlEventValueChanged];
			cell.accessoryView=s;
			[s release];
			
			break;
			
		case 1:
			
		{
			switch(indexPath.row)
			{
				case 0:
					cell.textLabel.text=@"3 Seconds";
					cell.tag=3;
					if(delaySeconds==3)
					{
						cell.accessoryType=UITableViewCellAccessoryCheckmark;
					}
					break;
				case 1:
					cell.textLabel.text=@"6 Seconds";
					cell.tag=6;
					if(delaySeconds==6)
					{
						cell.accessoryType=UITableViewCellAccessoryCheckmark;
					}
					break;
				case 2:
					cell.textLabel.text=@"10 Seconds";
					cell.tag=10;
					if(delaySeconds==10)
					{
						cell.accessoryType=UITableViewCellAccessoryCheckmark;
					}
					break;
			}
		}
			
			break;
			
		/*case 2:
			switch(indexPath.row)
		{
			case 0:
				cell.textLabel.text=@"Oldest to newest";
				cell.tag=SlideshowOrderByDate;
				if(sortOrder==SlideshowOrderByDate)
				{
					cell.accessoryType=UITableViewCellAccessoryCheckmark;
				}
				break;
			case 1:
				cell.textLabel.text=@"Random order";
				cell.tag=SlideshowOrderByRandom;
				if(sortOrder==SlideshowOrderByRandom)
				{
					cell.accessoryType=UITableViewCellAccessoryCheckmark;
				}
				break;
			case 2:
				cell.textLabel.text=@"Sequential";
				cell.tag=SlideshowOrderBySequential;
				if(sortOrder==SlideshowOrderBySequential)
				{
					cell.accessoryType=UITableViewCellAccessoryCheckmark;
				}
				break;
		}
			
			break;*/
		//case 3:
		case 2:
		{
			cell.backgroundColor=[UIColor blueColor];
			cell.textLabel.textColor=[UIColor whiteColor];
			cell.textLabel.text=@"Start Slideshow"; 
			cell.textLabel.textAlignment=UITextAlignmentCenter;
			cell.selectionStyle=UITableViewCellSelectionStyleGray;
			
		}
			break;
			
	}
	
	return cell;
	
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	switch (section) {
		case 0:
			return 1;
		case 1:
			return 3;
		//case 2:
		//	return 3;
		default:
			return 1;
	}
}

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch (indexPath.section) {
		 
		case 1:
		{
			switch(indexPath.row)
			{
				case 0:
					delaySeconds=3;
					break;
				case 1:
					delaySeconds=6;
					break;
				case 2:
					delaySeconds=10;
					break;
			}
		}
			break;
		
		/*case 2:
		{
			switch(indexPath.row)
			{
				case 0:
					sortOrder=SlideshowOrderByDate;
					break;
				case 1:
					sortOrder=SlideshowOrderByRandom;
					break;
				case 2:
					sortOrder=SlideshowOrderBySequential;
					break;
			}
		}
			
			break;*/
		//case 3:
		case 2:
			[self startSlideshow:nil];
			break;
		 
	}
	[theTableView reloadData];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
	return YES;
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


- (void)dealloc 
{
	delegate=nil;
	[tableView release];
    [super dealloc];
}


@end
