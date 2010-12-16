#import "CommentTableViewCell.h"
#import "Comment.h"
#import "Picture.h"
#import "User.h"
@implementation CommentTableViewCell
@synthesize comment,userLabel,messageLabel,userImageView;

- (void)setComment:(Comment *)newComment
{
    if (newComment != comment)
    {
        comment.picture.delegate = nil;
        [comment release];
        comment = nil;
        
        comment = [newComment retain];
        [comment.picture setDelegate:self];
        
		messageLabel.text=comment.message;
		userLabel.text=[NSString stringWithFormat:@"by %@ on %@",comment.user.name,[comment.created_date description]];
		
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

- (void) setImage:(UIImage*)image
{
	userImageView.image = image;
	[userImageView setNeedsDisplay];
	[self setNeedsDisplay];
}

- (void) load
{
	// The getter in the Picture class is overloaded...!
    // If the image is not yet downloaded, it returns nil and 
    // begins the asynchronous downloading of the image.
    UIImage *image = comment.picture.thumbnail;
	if (image == nil)
    {
		[self startLoading];
    }
	[self setImage:image];
	
}

- (void)picture:(Picture *)picture didLoadImage:(UIImage *)image
{
	[self setImage:image];
	[self finishedLoading];
    //[self bringSubviewToFront:imageView];
	[userImageView setNeedsDisplay];
}

- (void)picture:(Picture *)picture couldNotLoadImageError:(NSError *)error
{
	// Here we could show a "default" or "placeholder" image...
    [self finishedLoading];
}

- (void) startLoading
{
	
}

- (void) finishedLoading
{
	
}

- (void) dealloc
{
	[comment release];
	[userLabel release];
	//[dateLabel release];
	[userImageView release];
	[messageLabel release];
	[super dealloc];
}
@end
