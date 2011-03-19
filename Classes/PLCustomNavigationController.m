#import "PLCustomNavigationController.h"
#import <QuartzCore/QuartzCore.h>

#define MAX_BACK_BUTTON_WIDTH 160.0

@implementation PLCustomNavigationController
@synthesize viewControllers;

- (id) init
{
	self=[super init];
	
	backToolbar=[[UIToolbar alloc] init];
	backToolbar.barStyle=UIBarStyleBlack;
	
	[backToolbar sizeToFit];
	backToolbar.autoresizingMask=UIViewAutoresizingFlexibleWidth;
	[self.view addSubview:backToolbar];

	toolbar=[[UIToolbar alloc] init];
	toolbar.barStyle=UIBarStyleBlack;
	
	[toolbar sizeToFit];
	toolbar.autoresizingMask=UIViewAutoresizingFlexibleWidth;
	
	viewControllers=[[NSMutableArray alloc] init];
	
	[self.view addSubview:toolbar];
	
	return self;
}

- (void)setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated
{
	if(animated)
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:0.3];
	}
	if (hidden) 
	{
		CGRect frame=toolbar.frame;
		frame.origin.y-=(frame.size.height+20);
		backToolbar.frame=frame;
		toolbar.frame=frame;
	}
	else 
	{
		CGRect frame=toolbar.frame;
		frame.origin.y=0;
		backToolbar.frame=frame;
		toolbar.frame=frame;
	}
	if(animated)
	{
		[UIView commitAnimations];
	}
}


- (CGRect) screenBounds
{
	if([[UIApplication sharedApplication]    statusBarOrientation]==UIInterfaceOrientationPortrait ||
	   [[UIApplication sharedApplication] statusBarOrientation]==UIInterfaceOrientationPortraitUpsideDown)
	{
		return [[UIScreen mainScreen] bounds];
	}
	else 
	{
		CGRect b=[[UIScreen mainScreen] bounds];
		CGFloat w=b.size.width;
		b.size.width=b.size.height;
		b.size.height=w;
		return b;
	}
}

- (void)setNavigationBarTranslucent:(BOOL)translucent
{
	toolbar.translucent=translucent;
	backToolbar.translucent=translucent;
	if(translucent)
	{
		[[[self topViewController] view  ]setFrame:[self screenBounds]];
	}
}

- (id)initWithRootViewController:(UIViewController *)rootViewController // Convenience method pushes the root view controller without animation.
{
	self=[self init];
	
	[self pushViewController:rootViewController animated:YES];
	
	return self;
}

- (void) setNavigationItem:(UINavigationItem*)item backButtonTitle:(NSString*)backButtonTitle
{
	NSMutableArray * tools=[[NSMutableArray alloc] init];
	
	if([backButtonTitle length]>0)
	{
		[tools addObject:[self backButtonWithTitle:backButtonTitle]];
	}
	else 
	{
		if(item.leftBarButtonItem)
		{
			[tools addObject:item.leftBarButtonItem];
		}
	}
	
	[tools addObject:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease]];
	
	// add title...
	if(item.titleView)
	{
		[tools addObject:[[[UIBarButtonItem	alloc] initWithCustomView:item.titleView] autorelease]];
	}
	else 
	{
		if ([item.title length]>0) 
		{
			UIFont * font=[UIFont boldSystemFontOfSize:17];
			CGSize size=[item.title sizeWithFont:font];
			
			UILabel * titleLabel=[[UILabel alloc] init];
			
			titleLabel.frame=CGRectMake(0, 0, size.width+10, size.height+4);
			
			titleLabel.font=font;
			titleLabel.textColor=[UIColor whiteColor];
			titleLabel.backgroundColor=[UIColor clearColor];
			titleLabel.text = item.title;
			
			[tools addObject:[[[UIBarButtonItem	alloc] initWithCustomView:titleLabel] autorelease]];
			
			[titleLabel release];
		}
	}

	[tools addObject:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease]];
	
	if(item.rightBarButtonItem)
	{
		[tools addObject:item.rightBarButtonItem];
	}
	
	[toolbar setItems:tools];
	[tools release];
}

- (void) pushViewController:(UIViewController*)controller animated:(BOOL)animated;
{
	[self pushViewController:controller fromRect:CGRectZero animated:animated];
}

- (void) pushViewController:(UIViewController*)controller fromRect:(CGRect)rect animated:(BOOL)animated
{
	CGRect destRect=self.view.bounds;
	destRect.size.height-=toolbar.frame.size.height;
	destRect.origin.y=toolbar.frame.size.height;
	
	if(rect.size.width>0 ||
	   rect.size.height>0 ||
	   rect.origin.x>0 ||
	   rect.origin.y>0)
	{
		controller.view.frame=rect;
		controller.view.contentMode=UIViewContentModeScaleToFill;
	}
	else 
	{
		controller.view.frame=destRect;
	}

	NSString * backButtonTitle=nil;
	
	if([viewControllers count]>0)
	{
		backButtonTitle=[[[viewControllers lastObject] navigationItem] title];
	
		if([backButtonTitle length]==0)
		{
			backButtonTitle=@"Back";
		}
	}
	
	[viewControllers addObject:controller];
	
	if(animated)
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:0.3];
		
		controller.view.layer.opacity=0.0;
		
		toolbar.layer.opacity=0.0;
		
		[UIView commitAnimations];
	}
	
	[self setNavigationItem:controller.navigationItem backButtonTitle:backButtonTitle];
	
	if(animated)
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:0.3];
	}
	
	controller.view.frame=destRect;
	
	controller.view.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;

	[controller viewWillAppear:YES];
	
	[self.view addSubview:controller.view];
	
	controller.view.layer.opacity=1.0;
	
	toolbar.layer.opacity=1.0;
	
	if(animated)
	{
		[UIView commitAnimations];
	}
	
	// not sure if we should call this, but otherwise it does not get called for some reason...
	[controller viewDidAppear:YES];
	
	//[controller.view setNeedsLayout];
}

- (void)viewDidAppear:(BOOL)animated
{
	[[self topViewController] viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
	[[self topViewController] viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[[self topViewController] viewWillDisappear:animated];
}

- (void) viewDidDisappear:(BOOL)animated
{
	[[self topViewController] viewDidDisappear:animated];
}

- (UIViewController*) topViewController
{
	if([viewControllers count]>0)
	{
		return [viewControllers lastObject];
	}
	else 
	{
		return nil;
	}
}

- (UIBarButtonItem*) backButtonWithTitle:(NSString*)backButtonTitle
{
	UIImage * backButtonImage = [UIImage imageNamed:@"navigationBarBackButton.png"];
	
	UIImage * backButtonHighlightImage=nil;
	
	// store the cap width for use later when we set the text
	CGFloat backButtonCapWidth = 14.0;
	
	// Create stretchable images for the normal and highlighted states
	UIImage* buttonImage = [backButtonImage stretchableImageWithLeftCapWidth:backButtonCapWidth topCapHeight:0.0];
	UIImage* buttonHighlightImage = [backButtonHighlightImage stretchableImageWithLeftCapWidth:backButtonCapWidth topCapHeight:0.0];
	
	// Create a custom button
	UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
	
	// Set the title to use the same font and shadow as the standard back button
	button.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]];
	button.titleLabel.textColor = [UIColor whiteColor];
	button.titleLabel.shadowOffset = CGSizeMake(0,-1);
	button.titleLabel.shadowColor = [UIColor darkGrayColor];
	
	// Set the break mode to truncate at the end like the standard back button
	button.titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
	
	// Inset the title on the left and right
	button.titleEdgeInsets = UIEdgeInsetsMake(0, 6.0, 0, 3.0);
	
	// Make the button as high as the passed in image
	button.frame = CGRectMake(0, 0, 0, buttonImage.size.height);
	
	CGSize textSize = [backButtonTitle sizeWithFont:button.titleLabel.font];
	
	// Change the button's frame. The width is either the width of the new text or the max width
	button.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y, (textSize.width + (backButtonCapWidth * 1.5)) > MAX_BACK_BUTTON_WIDTH ? MAX_BACK_BUTTON_WIDTH : (textSize.width + (backButtonCapWidth * 1.5)), button.frame.size.height);
	
	// Set the text on the button
	[button setTitle:backButtonTitle forState:UIControlStateNormal];
	
	// Set the stretchable images as the background for the button
	[button setBackgroundImage:buttonImage forState:UIControlStateNormal];
	[button setBackgroundImage:buttonHighlightImage forState:UIControlStateHighlighted];
	[button setBackgroundImage:buttonHighlightImage forState:UIControlStateSelected];
	
	// Add an action for going back
	[button addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
		
	button.titleLabel.textColor = [UIColor colorWithRed:254.0/255.0 green:239.0/255.0 blue:218.0/225.0 alpha:1];
	
	return [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
}

- (UIViewController *) popViewController
{
	return [self popViewControllerAnimated:YES];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated; // Returns the popped controller.
{
	[self setNavigationBarTranslucent:NO];

	if ([viewControllers count]>0) 
	{
		UIViewController * controller=[viewControllers lastObject];
			
		if(animated)
		{
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
			[UIView setAnimationDuration:0.3];
			
			controller.view.layer.opacity=0.0;
			
			toolbar.layer.opacity=0.0;
			
			[UIView commitAnimations];
		}
		
		NSString * backButtonTitle=nil;
		
		if([viewControllers count]>1)
		{
			UIViewController * prevController=[viewControllers objectAtIndex:([viewControllers count]-2)];
			
			if([viewControllers count]>2)
			{
				UIViewController * prevPrevController=[viewControllers objectAtIndex:([viewControllers count]-3)];
																					  
				backButtonTitle=[[prevPrevController navigationItem] title];
				if([backButtonTitle length]==0)
				{
					backButtonTitle=@"Back";
				}
			}
				
			[self setNavigationItem:prevController.navigationItem backButtonTitle:backButtonTitle];
		}
		else 
		{
			[toolbar setItems:nil];
		}

		[controller.view removeFromSuperview];
		
		[viewControllers removeLastObject];
		
		if(animated)
		{
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
			[UIView setAnimationDuration:0.3];
		}
		
		toolbar.layer.opacity=1.0;
		
		if(animated)
		{
			[UIView commitAnimations];
		}
	}
	return nil;
}

- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated 
{
	[self setViewControllers:viewControllers];
}

- (void) setViewControllers:(NSMutableArray *)a
{
	if(![a isEqual:viewControllers])
	{
		[viewControllers removeAllObjects];
		
		[self pushViewController:[a objectAtIndex:0] animated:YES];
	
		for(int i=1;i<[a count];i++)
		{
			[viewControllers addObject:[a objectAtIndex:i]];
		}
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return YES;
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	[[self topViewController] didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[[self topViewController] willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)dealloc 
{
	[toolbar release];
	[backToolbar release];
	[viewControllers release];
    [super dealloc];
}

@end
