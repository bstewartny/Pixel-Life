#import <Foundation/Foundation.h>
#import "Item.h"

@class Feed;
@class Picture;

@interface Album : Item {
	Feed * pictureFeed;
	Picture * picture;
	NSString * description;
	NSString * location;
	NSInteger count;
	NSInteger commentCount;
}
@property(nonatomic,retain) Feed * pictureFeed;
@property(nonatomic,retain) Picture * picture; 
@property(nonatomic,retain) NSString * description;
@property(nonatomic,retain) NSString * location;
@property(nonatomic) NSInteger count;
@property(nonatomic) NSInteger commentCount;

 
@end
