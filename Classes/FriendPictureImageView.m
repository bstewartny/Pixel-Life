#import "FriendPictureImageView.h"
#import "User.h"
#import "Friend.h"

@implementation FriendPictureImageView
@synthesize user;

- (id) initWithFrame: (CGRect) frame
{
	//NSLog(@"FriendPictureImageView.initWithFrame");
    self = [super initWithFrame: frame];
    if ( self == nil )
        return nil;
	
	CGRect rect=frame; 
	[self createLabelViewsWithFrame:rect];
}

- (void) createLabelViewsWithFrame:(CGRect)rect
{
	nameView=[[UIView alloc] initWithFrame:CGRectMake(0,rect.size.height-45,rect.size.width,45)];
	nameView.backgroundColor=[UIColor blackColor];
	nameView.alpha=0.5;
	
	[self addSubview:nameView];
	[self bringSubviewToFront:nameView];
	
	firstNameLabel=[[UILabel alloc] initWithFrame:CGRectMake(5,5,rect.size.width-10,15)];
	firstNameLabel.font=[UIFont fontWithName:@"Verdana" size:14];
	firstNameLabel.textColor=[UIColor whiteColor];
	firstNameLabel.backgroundColor=[UIColor clearColor];
	
	[nameView addSubview:firstNameLabel];
	[nameView bringSubviewToFront:firstNameLabel];
	
	lastNameLabel=[[UILabel alloc] initWithFrame:CGRectMake(5,22,rect.size.width-10,15)];
	lastNameLabel.font=[UIFont fontWithName:@"Verdana" size:14];
	lastNameLabel.textColor=[UIColor whiteColor];
	lastNameLabel.backgroundColor=[UIColor clearColor];
	
	[nameView addSubview:lastNameLabel];
	[nameView bringSubviewToFront:lastNameLabel];
	
    return self;
}

- (void) setUser:(User*)newUser
{
	if(newUser==user)
	{
		return;
	}
	[user release];
	user=[newUser retain];
	
	self.picture=[user picture];
	
	if(nameView==nil)
	{
		[self createLabelViewsWithFrame:self.frame];
	}
	
	if([user isKindOfClass:[Friend class]])
	{
		Friend * fr=(Friend*)user;
		if([fr.last_name length]>0 && [fr.first_name length]>0)
		{
			firstNameLabel.text=fr.first_name;
			lastNameLabel.text=fr.last_name;
		}
		else {
			firstNameLabel.text=nil;
			lastNameLabel.text=fr.name;
		}
	}
	else 
	{
		firstNameLabel.text=nil;
		lastNameLabel.text=user.name;
	}
}

- (void) dealloc
{
	[user release];
	[nameView release];
	[firstNameLabel release];
	[lastNameLabel release];
	[super dealloc];
}

@end
