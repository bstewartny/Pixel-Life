//
//  PictureFeedScrollViewController.h
//  PhotoExplorer
//
//  Created by Robert Stewart on 12/6/10.
//  Copyright 2010 Evernote. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PicturesScrollViewController : UIViewController {
	IBOutlet UIScrollView * scrollView;
	NSArray * pictures;
	NSInteger currentItemIndex;
}
@property(nonatomic,retain) NSArray * pictures;
@property(nonatomic,retain) IBOutlet UIScrollView * scrollView;
@property(nonatomic) NSInteger currentItemIndex;
@end
