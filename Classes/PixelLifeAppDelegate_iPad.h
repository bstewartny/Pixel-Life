#import <UIKit/UIKit.h>
#import "PixelLifeAppDelegate.h"

@interface PixelLifeAppDelegate_iPad : PixelLifeAppDelegate  
{

}

- (void) addSettingsButtonToController:(UIViewController*)controller;
- (void) addSegmentedControlTitleView:(UIViewController*)controller withSelectedIndex:(NSInteger)index;

@end

