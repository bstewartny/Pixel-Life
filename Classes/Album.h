//
//  Album.h
//  PhotoExplorer
//
//  Created by Robert Stewart on 12/5/10.
//  Copyright 2010 Evernote. All rights reserved.
//

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
}
@property(nonatomic,retain) Feed * pictureFeed;
@property(nonatomic,retain) Picture * picture; 
@property(nonatomic,retain) NSString * description;
@property(nonatomic,retain) NSString * location;
@property(nonatomic) NSInteger count;



@end
