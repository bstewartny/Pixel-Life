//
//  MutableInt.h
//  PixelLife
//
//  Created by Robert Stewart on 3/28/11.
//  Copyright 2011 OmegaMuse, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MutableInt : NSObject {
	int intValue;
}

- (void)setIntValue:(int)v;
- (int) intValue;
- (void) incValue;
@end
