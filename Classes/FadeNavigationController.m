//
//  FadeNavigationController.m
//  PhotoExplorer
//
//  Created by Robert Stewart on 12/23/10.
//  Copyright 2010 Evernote. All rights reserved.
//

#import "FadeNavigationController.h"
#import <QuartzCore/QuartzCore.h>

@implementation FadeNavigationController

- (void) pushViewController:(UIViewController*)controller animated:(BOOL)animated
{
	/*CATransition *transition = [CATransition animation];
	transition.duration = 0.3;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	transition.subtype = kCATransitionReveal;

	[self.view.layer addAnimation:transition forKey:nil];
*/
	[super pushViewController:controller animated:animated];
}

- (UIViewController *) popViewControllerAnimated:(BOOL)animated
{
	/*CATransition *transition = [CATransition animation];
	transition.duration = 0.3;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	transition.subtype = kCATransitionReveal;
	[self.view.layer addAnimation:transition forKey:nil];*/
	return [super popViewControllerAnimated:animated	];
}


@end
