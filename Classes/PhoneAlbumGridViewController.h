#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "PictureFeedGridViewController.h"
@class Album;
@interface PhoneAlbumGridViewController : PictureFeedGridViewController {
	Album * album;
	UIBarButtonItem * showCommentsButton;
}
@property(nonatomic,retain) Album * album;
@property(nonatomic,retain) IBOutlet UIBarButtonItem * showCommentsButton;


- (id) initWithAlbum:(Album*)album;


- (IBAction) showComments:(id)sender;
- (IBAction) addFavorite:(id)sender;
- (IBAction) addComment:(id)sender;

@end
