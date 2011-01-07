#import <Foundation/Foundation.h>
#import "PictureGridViewCell.h"

@interface PhotoGridViewCell : PictureGridViewCell {
	UILabel * label1;
	UILabel * label2;
	UILabel * label3;
	BOOL showBorder;
	NSDateFormatter * format;
 
}
@property(nonatomic) BOOL showBorder;

@end
