#import <Foundation/Foundation.h>

@interface UserSettings : NSObject {

}

+ (void) saveSetting:(NSString*)key value:(NSString*)valueString;
+ (NSString *)getSetting:(NSString*)key;

@end
