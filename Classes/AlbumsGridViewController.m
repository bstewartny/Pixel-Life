    //
//  AlbumsGridViewController.m
//  PhotoExplorer
//
//  Created by Robert Stewart on 12/5/10.
//  Copyright 2010 Evernote. All rights reserved.
//

#import "AlbumsGridViewController.h"
#import "Album.h"
#import "PhotoGridViewCell.h"
#import "PictureFeedGridViewController.h"

@implementation AlbumsGridViewController
 

- (AQGridViewCell *) gridView: (AQGridView *) aGridView cellForItemAtIndex: (NSUInteger) index
{
    static NSString * cellIdentifier = @"CellIdentifier";
	
    PhotoGridViewCell * photoCell = (PhotoGridViewCell *)[aGridView dequeueReusableCellWithIdentifier: cellIdentifier];
	if ( photoCell == nil )
	{
		photoCell = [[[PhotoGridViewCell alloc] initWithFrame: CGRectMake(0.0, 0.0, 200.0, 150.0)
											  reuseIdentifier: cellIdentifier] autorelease];
		photoCell.selectionStyle = AQGridViewCellSelectionStyleBlueGray;
	}
	
	Album * album=(Album*)[items objectAtIndex:index];
	photoCell.picture=[album picture];
	 
	
	
	return photoCell;
}

- (void) gridView: (AQGridView *) gridView didSelectItemAtIndex: (NSUInteger) index
{
	Album * album=(Album*)[items objectAtIndex:index];
	// show album...
	PictureFeedGridViewController * picturesController=[[PictureFeedGridViewController alloc] initWithFeed:album.pictureFeed title:album.name];
	
	[[self navigationController] pushViewController:picturesController animated:YES];
	
	[picturesController release];
}
 
@end
