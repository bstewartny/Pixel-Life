#import <UIKit/UIKit.h>
#import "PixelLifeAppDelegate.h"

#define kTabBarSettingsTag 0
#define kTabBarFriendsTag 1
#define kTabBarListsTag 2
#define kTabBarAlbumsTag 3
#define kTabBarRecentTag 4

@interface PixelLifeAppDelegate_iPhone : PixelLifeAppDelegate <UITabBarDelegate> {
	UITabBar * tabBar;
}
@property (nonatomic, retain) UITabBar * tabBar;

@end
