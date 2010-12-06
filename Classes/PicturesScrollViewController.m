    //
//  PictureFeedScrollViewController.m
//  PhotoExplorer
//
//  Created by Robert Stewart on 12/6/10.
//  Copyright 2010 Evernote. All rights reserved.
//

#import "PicturesScrollViewController.h"
#import "Picture.h"
#import "PictureImageView.h"

@implementation PicturesScrollViewController
@synthesize scrollView, pictures,currentItemIndex;

- (id)initWithPictures:(NSArray*)pictures
{
    if(self=[super initWithNibName:@"PicturesScrollView" bundle:nil])
	{
		self.pictures=pictures;
		 
		self.view.backgroundColor=[UIColor blackColor];
	}
    return self;
}

-(void) addPicturesToScrollView
{
	CGFloat left=0;
	CGFloat top=0;
	CGFloat width=scrollView.bounds.size.width;
	CGFloat height=scrollView.bounds.size.height;
	
	for(Picture * picture in pictures)
	{
		CGFloat x=left;
		CGFloat y=top;
		
		CGRect frame=CGRectMake(x,y,width,height);
		
		PictureImageView * picView=[[PictureImageView alloc] initWithFrame:frame picture:picture];
		
		[scrollView addSubview:picView];
		
		left+=width;
	
	}
	[scrollView setContentSize:CGSizeMake([pictures count]*width, height)];
	
}

- (void) setPictureFrames
{
	CGFloat left=0;
	CGFloat top=0;
	CGFloat width=scrollView.bounds.size.width;
	CGFloat height=scrollView.bounds.size.height;
	
	for(PictureImageView * picView in scrollView.subviews)
	{
		CGFloat x=left;
		CGFloat y=top;
		
		CGRect frame=CGRectMake(x,y,width,height);
		picView.frame=frame;
		[picView setNeedsDisplay];
		
		left+=width;
	}
	[scrollView setContentSize:CGSizeMake([pictures count]*width, height)];
	[scrollView setNeedsDisplay];
}
 

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	scrollView.backgroundColor=[UIColor blackColor];
	
	[self addPicturesToScrollView];
	
	[self loadVisiblePictures]; 
	
	[self goToCurrentItem];
}

- (void) goToCurrentItem
{
	scrollView.contentOffset=CGPointMake(currentItemIndex * scrollView.bounds.size.width, 0);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	[self loadVisiblePictures]; 
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
{
    if (!decelerate) 
    {
        [self loadVisiblePictures]; 
    }
}

- (void) loadVisiblePictures
{
	for (PictureImageView * picView in scrollView.subviews) 
	{
		NSLog(@"class of picView: %@",[[picView class] description]);
		if(CGRectIntersectsRect(picView.frame, scrollView.bounds))
		{
			if([ picView isKindOfClass:[PictureImageView class]])
			{
				[picView load];
			}
		}
	}
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	[self setPictureFrames];
	[self loadVisiblePictures];
}
 
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[pictures release];
	[scrollView release];
    [super dealloc];
}


@end
