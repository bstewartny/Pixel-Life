//
//  MutableInt.m
//  PixelLife
//
//  Created by Robert Stewart on 3/28/11.
//  Copyright 2011 OmegaMuse, LLC. All rights reserved.
//

#import "MutableInt.h"


@implementation MutableInt


- (void)setIntValue:(int)v
{
	intValue=v;
}
- (int) intValue
{
	return intValue;
}

- (void)incValue
{
	intValue++;
}
@end
