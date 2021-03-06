#import <Foundation/Foundation.h>

@class User;

@interface Item : NSObject {
	NSString * uid;
	NSString * url;
	NSString * name;
	User * user;
	NSDate * created_date;
	NSString * short_created_date;
}
@property(nonatomic,retain) NSString * uid;
@property(nonatomic,retain) NSString * url;
@property(nonatomic,retain) NSString * name;
@property(nonatomic,retain) User * user;
@property(nonatomic,retain) NSDate * created_date;
@property(nonatomic,retain) NSString * short_created_date;

- (NSComparisonResult)compare:(Item *)p;

@end
