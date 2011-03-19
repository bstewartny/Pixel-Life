#import <Foundation/Foundation.h>
#import "PictureGridViewCell.h"

@interface PhotoGridViewCell : PictureGridViewCell {
	UILabel * label1;
	UILabel * label2;
	UILabel * label3;
	BOOL showBorder;
 
}
@property(nonatomic) BOOL showBorder;
- (UILabel*)createLabelWithFrame:(CGRect)frame;

@end
