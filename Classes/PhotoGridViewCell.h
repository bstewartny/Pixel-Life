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
