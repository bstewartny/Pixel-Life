//
//  FacebookFeed.h
//  PhotoExplorer
//
//  Created by Robert Stewart on 12/6/10.
//  Copyright 2010 Evernote. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Feed.h"
@class Facebook;

@interface FacebookFeed : Feed {
	Facebook * facebook;
}
@property(nonatomic,retain) Facebook * facebook;
- (id) initWithFacebook:(Facebook*)facebook;

- (NSString*) graphPath;

- (NSArray*) getItemsFromJson:(NSDictionary*)json;

@end
