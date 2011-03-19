#import <UIKit/UIKit.h>

@interface PLCustomNavigationController : UIViewController {
	NSMutableArray * viewControllers;
	//UINavigationBar * navBar;
	UIToolbar * toolbar;
	UIToolbar * backToolbar;	
}
@property(nonatomic,retain) NSMutableArray * viewControllers;

- (UIViewController *)topViewController; // The top view controller on the stack.
- (id)initWithRootViewController:(UIViewController *)rootViewController; // Convenience method pushes the root view controller without animation.
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated; // Uses a horizontal slide transition. Has no effect if the view controller is already in the stack.
- (UIViewController *)popViewControllerAnimated:(BOOL)animated; // Returns the popped controller.
- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0); // If animated is YES, then simulate a push or pop depending on whether the new top view controller was previously in the stack.
- (void)setNavigationBarTranslucent:(BOOL)translucent;
- (void)setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated;
@end
