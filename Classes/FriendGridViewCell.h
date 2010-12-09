//
//  FriendGridViewCell.h
//  PhotoExplorer
//
//  Created by Robert Stewart on 12/8/10.
//  Copyright 2010 Evernote. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PictureGridViewCell.h"

@interface FriendGridViewCell : PictureGridViewCell {
	UIView * nameView;
	UILabel * firstNameLabel;
	UILabel * lastNameLabel;
}

@end
