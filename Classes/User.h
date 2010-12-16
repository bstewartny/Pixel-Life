#import <Foundation/Foundation.h>

@interface User : NSObject {
	NSString * uid;
	NSString * name;
}
@property(nonatomic,retain) NSString * uid;
@property(nonatomic,retain) NSString * name;

@end
