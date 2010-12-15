//
//  PictureFeedScrollViewController.h
//  PhotoExplorer
//
//  Created by Robert Stewart on 12/6/10.
//  Copyright 2010 Evernote. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class PictureCaptionViewController;
@interface PicturesScrollViewController : UIViewController {
	IBOutlet UIScrollView * scrollView;
	NSArray * pictures;
	NSInteger currentItemIndex;
	IBOutlet UIToolbar * toolbar;
	//PictureCaptionViewController * captionViewController;
	
	IBOutlet UIImageView * infoImageView;
	IBOutlet UILabel * infoUserLabel;
	IBOutlet UILabel * infoNameLabel;
	IBOutlet UILabel * infoDescriptionLabel;
	IBOutlet UILabel * infoDateLabel;
	
	IBOutlet UIView * infoView;
	
}
@property(nonatomic,retain) NSArray * pictures;
@property(nonatomic,retain) IBOutlet UIScrollView * scrollView;
@property(nonatomic) NSInteger currentItemIndex;
@property(nonatomic,retain) IBOutlet UIToolbar * toolbar;

@property(nonatomic,retain) IBOutlet UIView * infoView;
@property(nonatomic,retain) IBOutlet UIImageView * infoImageView;
@property(nonatomic,retain) IBOutlet UILabel * infoUserLabel;
@property(nonatomic,retain) IBOutlet UILabel * infoNameLabel;
@property(nonatomic,retain) IBOutlet UILabel * infoDescriptionLabel;
@property(nonatomic,retain) IBOutlet UILabel * infoDateLabel;

@end
