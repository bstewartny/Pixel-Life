#import "CommentTableViewCell.h"
#import "Comment.h"
#import "Picture.h"
#import "User.h"

#define kCellPadding 5
#define kImageSize 50
#define kUserLabelHeight 20
#define kDateLabelHeight 20
#define kUserLabelFontSize 17.0
#define kDateLabelFontSize 14.0
#define kMessageLabelFontSize 17.0

@implementation CommentTableViewCell
@synthesize comment,userLabel,messageLabel,userImageView,scrollingWheel,dateLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	if(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])
	{
		self.backgroundColor=[UIColor viewFlipsideBackgroundColor];
		self.contentView.backgroundColor=[UIColor viewFlipsideBackgroundColor];
		
		userLabel=[[UILabel alloc] initWithFrame:CGRectZero];
		userLabel.backgroundColor=[UIColor clearColor];
		userLabel.font=[UIFont boldSystemFontOfSize:kUserLabelFontSize];
		userLabel.textColor=[UIColor whiteColor];
		
		messageLabel=[[UILabel alloc] initWithFrame:CGRectZero];
		messageLabel.backgroundColor=[UIColor clearColor];
		messageLabel.font=[UIFont systemFontOfSize:kMessageLabelFontSize];
		messageLabel.numberOfLines=20.0;
		messageLabel.lineBreakMode=UILineBreakModeWordWrap;
		messageLabel.textColor=[UIColor whiteColor];
		
		dateLabel=[[UILabel alloc] initWithFrame:CGRectZero];
		dateLabel.backgroundColor=[UIColor clearColor];
		dateLabel.font=[UIFont systemFontOfSize:kDateLabelFontSize];
		dateLabel.textColor=[UIColor lightGrayColor];
		
		userImageView=[[UIImageView alloc] initWithFrame:CGRectZero];
		scrollingWheel=[[UIActivityIndicatorView alloc] initWithFrame:CGRectZero];
		scrollingWheel.hidesWhenStopped=YES;
		scrollingWheel.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
		
		[self.contentView addSubview:userLabel];
		[self.contentView addSubview:messageLabel];
		[self.contentView addSubview:dateLabel];
		[self.contentView addSubview:userImageView];
	}
	return self;
	
}
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
		userLabel.text=comment.user.name;
		messageLabel.text=comment.message;
		dateLabel.text=[NSString stringWithFormat:@"on %@",[format stringFromDate:comment.created_date]];
		
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

	CGFloat cellWidth=self.frame.size.width;
	
	self.userImageView.frame=CGRectMake(kCellPadding,kCellPadding, kImageSize,kImageSize);  
	self.scrollingWheel.frame=CGRectMake(kCellPadding+((kImageSize-20)/2),kCellPadding+((kImageSize-20)/2), 20,20);  
	
	CGFloat labelsLeft=kImageSize + (2*kCellPadding);
	CGFloat labelsWidth=cellWidth - (labelsLeft + (2*kCellPadding));
	CGFloat message_height=[CommentTableViewCell heightForMessage:self.comment.message withWidth:labelsWidth];

	self.userLabel.frame=CGRectMake(labelsLeft, kCellPadding, labelsWidth, kUserLabelHeight );
	
	self.messageLabel.frame=CGRectMake(labelsLeft, kCellPadding+kUserLabelHeight+kCellPadding, labelsWidth, message_height);

	self.dateLabel.frame=CGRectMake(labelsLeft,kCellPadding+kUserLabelHeight+kCellPadding+message_height+kCellPadding,labelsWidth,kDateLabelHeight);
}
	
+ (CGFloat) heightForMessage:(NSString*)message withWidth:(CGFloat)width
{
	CGSize constraint=CGSizeMake(width, 20000.0);
	
	CGSize size=[message sizeWithFont:[UIFont systemFontOfSize:kMessageLabelFontSize] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
				 
	return size.height;
}
				 
+ (CGFloat) cellHeightForComment:(Comment*)comment withCellWidth:(CGFloat)cellWidth
{
	CGFloat labelsLeft=kImageSize + (2*kCellPadding);
	CGFloat labelsWidth=cellWidth - (labelsLeft + (2*kCellPadding));
	CGFloat message_height=[CommentTableViewCell heightForMessage:comment.message withWidth:labelsWidth];
	
	// height of other labels and padding above and below message label
	CGFloat height=kCellPadding + kUserLabelHeight + kCellPadding + message_height + kCellPadding + kDateLabelHeight + kCellPadding;	
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
		[self setNeedsLayout];
	}
}

- (void) load
{
	if(dealloc_called) return;
	//NSLog(@"load called on comment cell...");
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
	if(dealloc_called) return;
	[self setImage:image];
	[self finishedLoading];
}

- (void)picture:(Picture *)picture couldNotLoadImageError:(NSError *)error
{
	if(dealloc_called) return;
	// Here we could show a "default" or "placeholder" image...
    [self finishedLoading];
}

- (void) startLoading
{
	[scrollingWheel startAnimating];
	[self setNeedsLayout];
}

- (void) finishedLoading
{
	[scrollingWheel stopAnimating];
	[scrollingWheel release];
	scrollingWheel=nil;
}

- (void) dealloc
{	
	dealloc_called=YES;
	
	[scrollingWheel release];
	scrollingWheel=nil;
	[comment.picture setDelegate:nil];
	[comment release];
	[userLabel release];
	[userImageView release];
	[dateLabel release];
	[messageLabel release];
	[super dealloc];
}
@end
