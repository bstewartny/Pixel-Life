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
	scrollingWheel.frame=CGRectMake(self.frame.size.width/2-10, self.frame.size.height/2-10, 20.0, 20.0);
	[scrollingWheel startAnimating];
}

- (void) finishedLoading
{
	[scrollingWheel stopAnimating];
}

- (void) dealloc
{
	[scrollingWheel release];
    
	[super dealloc];
}

@end
