#import <Foundation/Foundation.h>
#import "Picture.h"

@interface MostRecentAlbumPicture : Picture 
{
	NSString * albumId;
	NSString * accessToken;
}
@property(nonatomic,retain) NSString * albumId;
@property(nonatomic,retain) NSString * accessToken;

@end
