#import "PLNavigationController.h"
#import <QuartzCore/QuartzCore.h>

@implementation PLNavigationController

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	if(![[[UIApplication sharedApplication] delegate] isPhone])
	{
		/*[UIView beginAnimations:@"transition" context:nil];
		[UIView setAnimationDuration:1.0];
		
		[UIView 
		 setAnimationTransition:UIViewAnimationTransitionCurlDown 
		 forView:self.view 
		 cache:NO];
		
		[super pushViewController:viewController animated:NO];
		
		[UIView commitAnimations];
		*/
		
		CATransition* transition = [CATransition animation];
		transition.duration = 0.2;
		transition.type = kCATransitionFade;
		transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
		
		[self.view.layer 
			addAnimation:transition forKey:kCATransition];
		
		
		[super pushViewController:viewController animated:NO];
	}
	else 
	{
		[super pushViewController:viewController animated:animated];
	}
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
	if (![[[UIApplication sharedApplication] delegate] isPhone]) 
	{
		 
		NSArray * vc=self.viewControllers;
		NSLog(@"nav has %d view controllers",[vc count]);
		
		UIViewController * prev=nil;
		for (UIViewController * c in vc)
		{
			if([c isEqual:self.topViewController])
			{
				break;
			}
			
			prev=c;
		}
		
		
		
		if(prev)
		{
			NSLog(@"found prev item in stack");
			
			leftItem=[prev.navigationItem.leftBarButtonItem retain];
			titleItem=[prev.navigationItem.titleView retain];
			rightItem=[prev.navigationItem.rightBarButtonItem retain];
			
			prev.navigationItem.leftBarButtonItem=nil;
			prev.navigationItem.titleView=nil;
			prev.navigationItem.rightBarButtonItem=nil;
		}
		
		 /*
		CATransition* transition = [CATransition animation];
		transition.duration = 0.2;
		
		transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
		
		transition.type = kCATransitionFade;
		 
		[self.view.layer 
		 addAnimation:transition forKey:kCATransition];
		
		 
		UIViewController * vc=[super popViewControllerAnimated:NO];
	   */
		
		
		[CATransaction begin];
		
		CATransition *transition;
		transition = [CATransition animation];
		transition.type = kCATransitionFade;          // Use any animation type and subtype you like
		//transition.subtype = kCATransitionFromTop;
		transition.duration = 0.3;
		
		CATransition *fadeTrans = [CATransition animation];
		fadeTrans.type = kCATransitionFade;
		fadeTrans.duration = 0.3;
	
		[CATransaction setValue:(id)kCFBooleanTrue
						 forKey:kCATransactionDisableActions];
		
		[[[[self.view subviews] objectAtIndex:0] layer] addAnimation:transition forKey:nil];
		[[[[self.view subviews] objectAtIndex:1] layer] addAnimation:fadeTrans forKey:nil];
		
		UIViewController * poped=[super  popViewControllerAnimated:NO];
		[CATransaction commit];
		
		return poped;
	}
	else 
	{
		return [super popViewControllerAnimated:animated];
	}
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	//NSLog(@"willShowViewController");
	 
	//NSLog(@"adding nav items back in...");
	if(leftItem)
	{
		viewController.navigationItem.leftBarButtonItem=leftItem;
		[leftItem release];
		leftItem=nil;
	}
	if(titleItem)
	{
		viewController.navigationItem.titleView=titleItem;
		[titleItem release];
		titleItem=nil;
	}
	if (rightItem) 
	{
		viewController.navigationItem.rightBarButtonItem=rightItem;
		[rightItem release];
		rightItem=nil;
	}
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{ 
	//NSLog(@"didShowViewController");
}


@end
