//
//  FriendPictureImageView.h
//  PhotoExplorer
//
//  Created by Robert Stewart on 12/28/10.
//  Copyright 2010 Evernote. All rights reserved.
//

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
