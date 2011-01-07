#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "PictureFeedGridViewController.h"
@class Album;
@interface PhoneAlbumGridViewController : PictureFeedGridViewController {
	Album * album;
}
@property(nonatomic,retain) Album * album;

- (id) initWithAlbum:(Album*)album;
@end
