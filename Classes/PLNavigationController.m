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
		//return [super popViewControllerAnimated:NO];
		
		
		/*[UIView beginAnimations:@"transition" context:nil];
		[UIView setAnimationDuration:1.0];
		
		[UIView 
		 setAnimationTransition:UIViewAnimationTransitionCurlUp 
		 forView:self.view 
		 cache:NO];
		
		UIViewController * vc=[super popViewControllerAnimated:NO];
		
		//[super pushViewController:viewController animated:NO];
		
		[UIView commitAnimations];*/
		
		CATransition* transition = [CATransition animation];
		transition.duration = 0.2;
		
		transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
		
		transition.type = kCATransitionFade;
		//transition.subtype = kCATransitionFromTop;
		
		[self.view.layer 
		 addAnimation:transition forKey:kCATransition];
		
		//[self.navigationBar.layer
		// addAnimation:transition forKey:kCATransition];
		
		UIViewController * vc=[super popViewControllerAnimated:NO];
		
		
		
		
		
	}
	else 
	{
		return [super popViewControllerAnimated:animated];
	}
}

@end
