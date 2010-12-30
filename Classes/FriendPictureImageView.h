#import <Foundation/Foundation.h>
#import "PictureImageView.h"

@class User;
@interface FriendPictureImageView : PictureImageView 
{
	User * user;
	UIView * nameView;
	UILabel * firstNameLabel;
	UILabel * lastNameLabel;
}

@property(nonatomic,retain) User * user;

- (id) initWithFrame: (CGRect) frame user: (User *) user;

@end
