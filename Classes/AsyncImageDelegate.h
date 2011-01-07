#import <Foundation/Foundation.h>

@class AsyncImage;

@protocol AsyncImageDelegate

@required
- (void)image:(AsyncImage *)item couldNotLoadImageError:(NSError *)error;

@optional
- (void)image:(AsyncImage *)item didLoadImage:(UIImage *)image;
@end

@end
