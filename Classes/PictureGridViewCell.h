#import <Foundation/Foundation.h>
#import "GridViewCell.h"

@class Picture;
@interface PictureGridViewCell : GridViewCell {
	Picture * picture;
	UIImageView * imageView;
	CGSize maxImageSize;
}
@property(nonatomic,retain) Picture * picture;
@end
