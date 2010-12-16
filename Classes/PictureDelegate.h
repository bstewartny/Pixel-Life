#import <Foundation/Foundation.h>

@class Picture;

@protocol PictureDelegate

@required
- (void)picture:(Picture *)item couldNotLoadImageError:(NSError *)error;

@optional
- (void)picture:(Picture *)item didLoadImage:(UIImage *)image;

@end
