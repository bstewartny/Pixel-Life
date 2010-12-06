//
//  Friend.h
//  PhotoExplorer
//
//  Created by Robert Stewart on 12/6/10.
//  Copyright 2010 Evernote. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
@class Picture;
@class Feed;
@interface Friend : User {
	NSString * first_name;
	NSString * last_name;
	NSString * url;
	NSString * about;
	NSDate * birthday;
	NSString * location;
	Feed * albumFeed;
	Picture * picture;
}
@property(nonatomic,retain) NSString * first_name;
@property(nonatomic,retain) NSString * last_name;
@property(nonatomic,retain) NSString * url;
@property(nonatomic,retain) NSString * about;
@property(nonatomic,retain) NSDate * birthday;
@property(nonatomic,retain) NSString * location;
@property(nonatomic,retain) Feed * albumFeed;
@property(nonatomic,retain) Picture * picture;

@end
