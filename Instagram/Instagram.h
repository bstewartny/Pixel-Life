//
//  Instagram.h
//  PixelLife
//
//  Created by Robert Stewart on 3/4/11.
//  Copyright 2011 OmegaMuse, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kInstagramClientId @"9cd26052b0fa4644adaea995ed832c4c"
#define kInstagramSecret @"0925a3fc8e3d42d9b22b2add2ccabf9a"
#define kInstagramRedirectUri @"http://www.omegamuse.com/pixellife/oauth"
#define kInstagramLoginUrl @"https://instagram.com/oauth/authorize/?client_id=9cd26052b0fa4644adaea995ed832c4c&redirect_uri=http://www.omegamuse.com/pixellife/oauth&response_type=token"

@interface Instagram : NSObject {
	NSString * accessToken;
}
@property(nonatomic,retain) NSString * accessToken;


- (void) login;

@end
