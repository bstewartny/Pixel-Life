//
//  User.h
//  PhotoExplorer
//
//  Created by Robert Stewart on 12/6/10.
//  Copyright 2010 Evernote. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface User : NSObject {
	NSString * uid;
	NSString * name;
}
@property(nonatomic,retain) NSString * uid;
@property(nonatomic,retain) NSString * name;

@end
