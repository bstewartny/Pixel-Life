//
//  PhotoGridViewCell.h
//  PhotoExplorer
//
//  Created by Robert Stewart on 12/4/10.
//  Copyright 2010 Evernote. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PictureGridViewCell.h"

@interface PhotoGridViewCell : PictureGridViewCell {
	UILabel * label1;
	UILabel * label2;
	UILabel * label3;
	BOOL showBorder;
	NSCalendar * gregorian;
	NSDateFormatter * format;
	CGSize maxImageSize;
}
@property(nonatomic) BOOL showBorder;

@end
