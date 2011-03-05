//
//  Instagram.m
//  PixelLife
//
//  Created by Robert Stewart on 3/4/11.
//  Copyright 2011 OmegaMuse, LLC. All rights reserved.
//

#import "Instagram.h"
#import "IGLoginDialog.h"

@implementation Instagram
@synthesize accessToken;

- (void) login
{
	// show web form for user to login...
	
	IGLoginDialog * loginDialog = [[IGLoginDialog alloc] initWithURL:kInstagramLoginUrl
                                          loginParams:nil
                                             delegate:self];
	
    [loginDialog show];
	
	// TODO: how/when to release dialog?
	
}

///////////////////////////////////////////////////////////////////////////////////////////////////
//FBLoginDialogDelegate

/**
 * Set the authToken and expirationDate after login succeed
 */
- (void)fbDialogLogin:(NSString *)token expirationDate:(NSDate *)expirationDate {
	self.accessToken = token;
	//self.expirationDate = expirationDate;
	//if ([self.sessionDelegate respondsToSelector:@selector(fbDidLogin)]) {
	//	[_sessionDelegate fbDidLogin];
	//}
	
}

/**
 * Did not login call the not login delegate
 */
- (void)fbDialogNotLogin:(BOOL)cancelled {
	//if ([self.sessionDelegate respondsToSelector:@selector(fbDidNotLogin:)]) {
	//	[_sessionDelegate fbDidNotLogin:cancelled];
	//}
}

- (void) dealloc
{
	[accessToken release];
	[super dealloc];
}
@end
