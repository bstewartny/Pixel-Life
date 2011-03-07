#import <Foundation/Foundation.h>

@interface FacebookAccount : NSObject <NSCoding> {
	NSString * name;
	NSString * uid;
	NSString * accessToken;
	NSDate * expirationDate;
}
@property(nonatomic,retain) NSString * name;
@property(nonatomic,retain) NSString * accessToken;
@property(nonatomic,retain) NSDate * expirationDate;
@property(nonatomic,retain) NSString * uid;

- (BOOL)isSessionValid;

@end
