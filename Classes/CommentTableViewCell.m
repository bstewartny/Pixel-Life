#import "CommentTableViewCell.h"
#import "Comment.h"
#import "Picture.h"
#import "User.h"
@implementation CommentTableViewCell
@synthesize comment,userLabel,messageLabel,userImageView,scrollingWheel;

- (void)setComment:(Comment *)newComment
{
    if (newComment != comment)
    {
        comment.picture.delegate = nil;
        [comment release];
        comment = nil;
        
        comment = [newComment retain];
        [comment.picture setDelegate:self];
        
		NSDateFormatter * format = [[[NSDateFormatter alloc] init] autorelease];
		[format setDateFormat:@"MMM d, yyyy"];
		
		messageLabel.text=comment.message;
		userLabel.text=[NSString stringWithFormat:@"by %@ on %@",comment.user.name,[format stringFromDate:comment.created_date]];
		
        if (comment.picture != nil)
        {
            // This is to avoid the item loading the image
            // when this setter is called; we only want that
            // to happen depending on the scrolling of the table
            if ([comment.picture hasLoadedThumbnail])
            {
				[self setImage:comment.picture.thumbnail];
            }
            else
            {
				[self setImage:nil];
            }
        }
    }
}

- (void) layoutSubviews
{
	[super layoutSubviews];
	
	self.userImageView.frame=CGRectMake(5,7, 50,50);  
	
	CGFloat message_height=[CommentTableViewCell heightForMessage:self.comment.message withWidth:self.messageLabel.frame.size.width];

	NSLog(@"message_height in layoutSubviews: %f",message_height);
	
	self.messageLabel.frame=CGRectMake(60, 7, self.messageLabel.frame.size.width, message_height);

	self.userLabel.frame=CGRectMake(60,7+message_height+3,self.userLabel.frame.size.width,self.userLabel.frame.size.height);
}
	
+ (CGFloat) heightForMessage:(NSString*)message withWidth:(CGFloat)width
{
	NSLog(@"heightForMessage: %f",width);
	CGSize constraint=CGSizeMake(width, 20000.0);
	
	CGSize size=[message sizeWithFont:[UIFont fontWithName:@"Helvetica" size:17.0] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
				 
	return size.height;
}
				 
+ (CGFloat) cellHeightForComment:(Comment*)comment
{
	CGFloat message_height=[CommentTableViewCell heightForMessage:comment.message withWidth:240];
	
	NSLog(@"message_height in cellHeightForComment: %f",message_height);
	
	CGFloat height=message_height + 7 + 25;
	
	if(height>65.0)
	{
		return height;
	}
	else 
	{
		return 65.0;
	}
}

- (void) setImage:(UIImage*)image
{
	userImageView.image = image;
	if(image!=nil)
	{
		[self finishedLoading];
	}
	[self setNeedsLayout];
}

- (void) load
{
	NSLog(@"load called on comment cell...");
	// The getter in the Picture class is overloaded...!
    // If the image is not yet downloaded, it returns nil and 
    // begins the asynchronous downloading of the image.
    if (userImageView.image==nil) 
	{
		UIImage *image = comment.picture.thumbnail;
		if (image == nil)
		{
			[self startLoading];
		}
		[self setImage:image];
	}
}

- (void)picture:(Picture *)picture didLoadImage:(UIImage *)image
{
	[self setImage:image];
	[self finishedLoading];
}

- (void)picture:(Picture *)picture couldNotLoadImageError:(NSError *)error
{
	// Here we could show a "default" or "placeholder" image...
    [self finishedLoading];
}

- (void) startLoading
{
	[scrollingWheel startAnimating];
}

- (void) finishedLoading
{
	[scrollingWheel stopAnimating];
	[scrollingWheel release];
	scrollingWheel=nil;
}

- (void) dealloc
{
	[scrollingWheel release];
	scrollingWheel=nil;
	[comment release];
	[userLabel release];
	[userImageView release];
	[messageLabel release];
	[super dealloc];
}
@end
