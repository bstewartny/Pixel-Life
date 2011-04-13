#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "FriendsGridViewController.h"

@interface PhoneFriendsGridViewController : FriendsGridViewController <UISearchDisplayDelegate> {
 
	IBOutlet UITabBar * tabBar;
}

@property(nonatomic,retain) IBOutlet UITabBar * tabBar;


@end
