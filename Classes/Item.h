//
//  Item.h
//  PhotoExplorer
//
//  Created by Robert Stewart on 12/6/10.
//  Copyright 2010 Evernote. All rights reserved.
//

#import <Foundation/Foundation.h>
@class User;

@interface Item : NSObject {
	NSString * uid;
	NSString * url;
	NSString * name;
	User * user;
	NSDate * created_date;
	NSDate * updated_date;
}
@property(nonatomic,retain) NSString * uid;
@property(nonatomic,retain) NSString * url;
@property(nonatomic,retain) NSString * name;
@property(nonatomic,retain) User * user;
@property(nonatomic,retain) NSDate * created_date;
@property(nonatomic,retain) NSDate * updated_date;


@end
