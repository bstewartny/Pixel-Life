#import "FadeNavigationController.h"
#import <QuartzCore/QuartzCore.h>

@implementation FadeNavigationController

- (void) pushViewController:(UIViewController*)controller animated:(BOOL)animated
{/*
	CATransition *transition = [CATransition animation];
	transition.duration = 0.3;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	transition.subtype = kCATransitionReveal;

	[self.view.layer addAnimation:transition forKey:nil];
*/
	[super pushViewController:controller animated:YES];
}

- (UIViewController *) popViewControllerAnimated:(BOOL)animated
{
	//NSLog(@"popViewControllerAnimated");
	/*CATransition *transition = [CATransition animation];
	transition.duration = 0.3;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	transition.subtype = kCATransitionReveal;
	[self.view.layer addAnimation:transition forKey:nil];*/
	//self.navigationBar.translucent=NO;
	return [super popViewControllerAnimated:YES	];
}

@end
