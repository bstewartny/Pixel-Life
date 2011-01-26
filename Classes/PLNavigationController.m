#import "PLNavigationController.h"


@implementation PLNavigationController

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{// Uses a horizontal slide transition. Has no effect if the view controller is already in the stack.
	if (![[[UIApplication sharedApplication] delegate] isPhone]) 
	{
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
		return [super popViewControllerAnimated:NO];
	}
	else 
	{
		return [super popViewControllerAnimated:animated];
	}

}
// Returns the popped controller.


@end
