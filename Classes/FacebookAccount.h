#import <Foundation/Foundation.h>

@interface FacebookAccount : NSObject <NSCoding> {
	NSString * name;
	
	NSString * accessToken;
	NSDate * expirationDate;
}
@property(nonatomic,retain) NSString * name;
@property(nonatomic,retain) NSString * accessToken;
@property(nonatomic,retain) NSDate * expirationDate;

- (BOOL)isSessionValid;

@end
