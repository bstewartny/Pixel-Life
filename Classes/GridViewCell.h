//
//  GridViewCell.h
//  PhotoExplorer
//
//  Created by Robert Stewart on 12/5/10.
//  Copyright 2010 Evernote. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AQGridViewCell.h"


@interface GridViewCell : AQGridViewCell {
	UIActivityIndicatorView * scrollingWheel;
}
- (void)load;
@end
