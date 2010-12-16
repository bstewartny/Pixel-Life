#import <Foundation/Foundation.h>
#import "Item.h"

@class Picture;
@interface Comment : Item {
	NSString * message;
	Picture * picture;
}
@property(nonatomic,retain) NSString * message;
@property(nonatomic,retain) Picture * picture;
@end
