#import <UIKit/UIKit.h>
#import "PixelLifeAppDelegate.h"

#define kTabBarSettingsTag 0
#define kTabBarFriendsTag 1
#define kTabBarListsTag 2
#define kTabBarAlbumsTag 3

@interface PixelLifeAppDelegate_iPhone : PixelLifeAppDelegate {
	UITabBar * tabBar;
}
@property (nonatomic, retain) UITabBar * tabBar;

@end
