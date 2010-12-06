//
//  GridViewCell.m
//  PhotoExplorer
//
//  Created by Robert Stewart on 12/5/10.
//  Copyright 2010 Evernote. All rights reserved.
//

#import "GridViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation GridViewCell

- (id) initWithFrame: (CGRect) frame reuseIdentifier: (NSString *) aReuseIdentifier
{
    self = [super initWithFrame: frame reuseIdentifier: aReuseIdentifier];
    if ( self == nil )
        return nil;

	scrollingWheel = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(frame.size.width/2-10, frame.size.height/2-10, 20.0, 20.0)];
	scrollingWheel.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
	scrollingWheel.hidesWhenStopped = YES;
	[scrollingWheel stopAnimating];
	[self.contentView addSubview:scrollingWheel];
	
    return self;
}

- (void) load
{
	// subclass
}

- (void) startLoading
{
	[self.contentView bringSubviewToFront:scrollingWheel];
	[scrollingWheel startAnimating];
}

- (void) finishedLoading
{
	[scrollingWheel stopAnimating];
	[self.contentView sendSubviewToBack:scrollingWheel];
}

- (void) dealloc
{
	[scrollingWheel release];
    
	[super dealloc];
}

@end
